import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/AuthBloc.dart';
import 'package:gobz_app/configurations/AppConfig.dart';
import 'package:gobz_app/configurations/StorageKeysConfig.dart';
import 'package:gobz_app/models/enums/AuthStatus.dart';
import 'package:gobz_app/repositories/AuthRepository.dart';
import 'package:gobz_app/repositories/ChapterRepository.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';
import 'package:gobz_app/repositories/RunRepository.dart';
import 'package:gobz_app/repositories/StepRepository.dart';
import 'package:gobz_app/repositories/TaskRepository.dart';
import 'package:gobz_app/repositories/UserRepository.dart';
import 'package:gobz_app/themes/AppThemes.dart';
import 'package:gobz_app/utils/LocalStorageUtils.dart';
import 'package:gobz_app/widgets/pages/HomePage.dart';
import 'package:gobz_app/widgets/pages/SplashPage.dart';
import 'package:gobz_app/widgets/pages/auth/LoginPage.dart';

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
                  HomePage.route(),
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
