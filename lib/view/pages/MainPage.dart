import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/auth/AuthBloc.dart';
import 'package:gobz_app/data/models/User.dart';
import 'package:gobz_app/view/pages/HomePage.dart';
import 'package:gobz_app/view/widgets/generic/Avatar.dart';
import 'package:provider/provider.dart';

import 'ProjectsPage.dart';
import 'RunsPage.dart';

class MainPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MainPage());
  }

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<_MainPageScreenInfo> _screenInfos = [
    _MainPageScreenInfo(
        title: 'Accueil',
        screen: HomePage(),
        navigationBarItem: BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil")),
    _MainPageScreenInfo(
        title: 'Runs',
        screen: RunsPage(),
        navigationBarItem: BottomNavigationBarItem(icon: Icon(Icons.pending_actions), label: "Runs")),
    _MainPageScreenInfo(
        title: 'Projets',
        screen: ProjectsPage(),
        navigationBarItem: BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Projets")),
  ];

  AppBar _buildAppBar(BuildContext context) {
    final User user = context.select(
      (AuthBloc bloc) => bloc.state.user,
    );

    return AppBar(
      title: Text(
        _screenInfos.elementAt(_selectedIndex).title,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: [
        BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) => previous.user.id != current.user.id || previous.status != current.status,
          builder: (context, state) => PopupMenuButton<Function?>(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Avatar(
                state.user,
                size: 20,
              ),
            ),
            onSelected: (function) => function?.call(),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<Function?>>[
                PopupMenuItem(
                  child: Row(
                    children: [
                      Avatar(
                        user,
                        size: 15,
                      ),
                      Expanded(
                          child: Text(
                        state.user.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  child: const Text("Déconnexion"),
                  value: () => context.read<AuthBloc>().add(AuthEvents.logoutRequested()),
                ),
              ];
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: _screenInfos.elementAt(_selectedIndex).screen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: _screenInfos.map((info) => info.navigationBarItem).toList(),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class _MainPageScreenInfo {
  final String title;
  final Widget screen;
  final BottomNavigationBarItem navigationBarItem;

  const _MainPageScreenInfo({required this.title, required this.screen, required this.navigationBarItem});
}
