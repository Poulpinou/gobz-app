import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/AuthBloc.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';
import 'package:gobz_app/widgets/screens/ProjectsScreen.dart';
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
        title: const Text('Accueil'),
        screen: const Text('Accueil'),
        navigationBarItem:
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil")),
    _HomePageScreenInfo(
        title: const Text('Run'),
        screen: const Text('Run'),
        navigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions), label: "Run")),
    _HomePageScreenInfo(
        title: const Text('Projets'),
        screen: ProjectScreen(),
        navigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.list_alt), label: "Projets")),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => ProjectRepository())],
      child: Scaffold(
        appBar: AppBar(
          title: _screenInfos.elementAt(_selectedIndex).title,
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: TextButton(
                      child: const Text("Déconnexion"),
                      onPressed: () =>
                          context.read<AuthBloc>().add(AuthLogoutRequested()),
                    ),
                  ),
                ];
              },
            )
          ],
        ),
        body: SafeArea(
          child: _screenInfos.elementAt(_selectedIndex).screen,
        ),

        /*Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Builder(
                builder: (context) {
                  final User user = context.select(
                    (AuthBloc bloc) => bloc.state.user,
                  );
                  return Text('User: ${user.name}');
                },
              ),
            ],
          ),*/

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: _screenInfos.map((info) => info.navigationBarItem).toList(),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class _HomePageScreenInfo {
  final Widget title;
  final Widget screen;
  final BottomNavigationBarItem navigationBarItem;

  const _HomePageScreenInfo(
      {required this.title,
      required this.screen,
      required this.navigationBarItem});
}
