import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/ProjectsBloc.dart';
import 'package:gobz_app/mixins/DisplayableMessage.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/widgets/pages/projects/NewProjectPage.dart';
import 'package:gobz_app/widgets/pages/projects/ProjectPage.dart';
import 'package:gobz_app/widgets/pages/projects/parts/lists/ProjectList.dart';

part 'parts/components/SearchBar.dart';

class ProjectsPage extends StatelessWidget {
  Widget _buildFetching() {
    return Expanded(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(), Container(width: 10), const Text("Récupération des projets...")],
        ),
      ),
    );
  }

  Widget _buildHandler({required Widget child}) {
    return BlocListener<ProjectsBloc, ProjectsState>(
      listener: (context, state) {
        if (state.isErrored) {
          final String message;
          if (state.error is DisplayableMessage) {
            message = (state.error as DisplayableMessage).displayableMessage;
          } else {
            message = "Une erreur s'est produite";
          }
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(message),
            ));
        }
      },
      child: child,
    );
  }

  void _createProject(BuildContext context) async {
    final Project? project = await Navigator.push(context, NewProjectPage.route());

    if (project != null) {
      context.read<ProjectsBloc>().add(FetchProjects());

      Navigator.push(context, ProjectPage.route(project));
    }
  }

  void _clickProject(BuildContext context, Project project) async {
    await Navigator.push(context, ProjectPage.route(project));

    context.read<ProjectsBloc>().add(FetchProjects());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final ProjectsBloc bloc = ProjectsBloc(projectRepository: RepositoryProvider.of(context));

        bloc.add(FetchProjects());

        return bloc;
      },
      child: Scaffold(
        body: _buildHandler(
          child: Column(children: [
            _SearchBar(),
            BlocBuilder<ProjectsBloc, ProjectsState>(
              buildWhen: (previous, current) =>
                  previous.searchText.value != current.searchText.value || previous.isLoading != current.isLoading,
              builder: (context, state) {
                if (state.isLoading) {
                  return _buildFetching();
                }

                if (state.isErrored) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Impossible de récupérer les projets"),
                          ElevatedButton(
                              onPressed: () => context.read<ProjectsBloc>().add(FetchProjects()),
                              child: const Text("Réessayer"))
                        ],
                      ),
                    ),
                  );
                }

                if (state.projects.length == 0) {
                  return Expanded(
                    child: Center(
                      child: const Text("Vous n'avez encore aucun projet."),
                    ),
                  );
                }

                if (state.filteredProjects.length == 0) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: const Text("Aucun projet ne correspond à cette recherche"),
                  );
                }

                return Expanded(
                    child: ProjectList(
                        projects: state.filteredProjects,
                        onProjectClicked: (project) => _clickProject(context, project)));
              },
            ),
          ]),
        ),
        floatingActionButton: BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) => FloatingActionButton(
            onPressed: () => _createProject(context),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
