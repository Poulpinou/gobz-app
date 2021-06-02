import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/auth/AuthBloc.dart';
import 'package:gobz_app/data/configurations/AppConfig.dart';
import 'package:gobz_app/data/configurations/StorageKeysConfig.dart';
import 'package:gobz_app/data/models/enums/AuthStatus.dart';
import 'package:gobz_app/data/repositories/AuthRepository.dart';
import 'package:gobz_app/data/repositories/ChapterRepository.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';
import 'package:gobz_app/data/repositories/RunRepository.dart';
import 'package:gobz_app/data/repositories/StepRepository.dart';
import 'package:gobz_app/data/repositories/TaskRepository.dart';
import 'package:gobz_app/data/repositories/UserRepository.dart';
import 'package:gobz_app/data/themes/AppThemes.dart';
import 'package:gobz_app/data/utils/LocalStorageUtils.dart';
import 'package:gobz_app/view/pages/LoginPage.dart';
import 'package:gobz_app/view/pages/MainPage.dart';
import 'package:gobz_app/view/pages/SplashPage.dart';

class GobzApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => authRepository),
        RepositoryProvider(create: (_) => userRepository),
        RepositoryProvider(create: (_) => ProjectRepository()),
        RepositoryProvider(create: (_) => ChapterRepository()),
        RepositoryProvider(create: (_) => StepRepository()),
        RepositoryProvider(create: (_) => TaskRepository()),
        RepositoryProvider(create: (_) => RunRepository()),
      ],
      child: BlocProvider(
        create: (_) => AuthBloc(authRepository: authRepository, userRepository: userRepository),
        child: GobzAppView(),
      ),
    );
  }
}

class GobzAppView extends StatefulWidget {
  _GobzAppViewState createState() => _GobzAppViewState();
}

class _GobzAppViewState extends State<GobzAppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: AppConfig.instance.title,
      theme: AppThemes.dark,
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            switch (state.status) {
              case AuthStatus.AUTHENTICATED:
                _navigator.pushAndRemoveUntil<void>(
                  MainPage.route(),
                  (route) => false,
                );
                break;
              case AuthStatus.UNAUTHENTICATED:
                final bool wasConnected =
                    await LocalStorageUtils.getBool(StorageKeysConfig.instance.wasConnectedKey) ?? false;
                final bool stayConnected =
                    await LocalStorageUtils.getBool(StorageKeysConfig.instance.stayConnectedKey) ?? false;

                if (wasConnected && stayConnected) {
                  BlocProvider.of<AuthBloc>(context).add(AuthEvents.autoReconnectRequested());
                } else {
                  _navigator.pushAndRemoveUntil<void>(
                    LoginPage.route(),
                    (route) => false,
                  );
                }

                break;
              case AuthStatus.UNKNOWN:
              case AuthStatus.AUTHENTICATING:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
