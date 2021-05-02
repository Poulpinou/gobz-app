import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/AuthBloc.dart';
import 'package:gobz_app/models/User.dart';
import 'package:gobz_app/widgets/misc/Avatar.dart';
import 'package:gobz_app/widgets/pages/ProjectsPage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<_HomePageScreenInfo> _screenInfos = [
    _HomePageScreenInfo(
        title: 'Accueil',
        screen: const Text('Accueil'),
        navigationBarItem:
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil")),
    _HomePageScreenInfo(
        title: 'Run',
        screen: const Text('Run'),
        navigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions), label: "Run")),
    _HomePageScreenInfo(
        title: 'Projets',
        screen: ProjectsPage(),
        navigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.list_alt), label: "Projets")),
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
        PopupMenuButton<Function?>(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Avatar(
              user,
              size: 20,
            ),
          ),
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
                      user.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                child: const Text("Déconnexion"),
                value: () =>
                    context.read<AuthBloc>().add(AuthLogoutRequested()),
              ),
            ];
          },
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

class _HomePageScreenInfo {
  final String title;
  final Widget screen;
  final BottomNavigationBarItem navigationBarItem;

  const _HomePageScreenInfo(
      {required this.title,
      required this.screen,
      required this.navigationBarItem});
}
