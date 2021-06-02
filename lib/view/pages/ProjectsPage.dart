import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/projects/ProjectsBloc.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';
import 'package:gobz_app/view/widgets/generic/CircularLoader.dart';
import 'package:gobz_app/view/widgets/inputs/SearchBar.dart';
import 'package:gobz_app/view/widgets/lists/ProjectList.dart';

import 'NewProjectPage.dart';
import 'ProjectPage.dart';

class ProjectsPage extends StatelessWidget {
  void _createProject(BuildContext context) async {
    final Project? project = await Navigator.push(context, NewProjectPage.route());

    if (project != null) {
      context.read<ProjectsBloc>().add(ProjectsEvents.fetch());

      Navigator.push(context, ProjectPage.route(project));
    }
  }

  void _clickProject(BuildContext context, Project project) async {
    await Navigator.push(context, ProjectPage.route(project));

    context.read<ProjectsBloc>().add(ProjectsEvents.fetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectsBloc(
        projectRepository: RepositoryProvider.of<ProjectRepository>(context),
        fetchOnStart: true,
      ),
      child: Scaffold(
        body: BlocHandler<ProjectsBloc, ProjectsState>.simple(
          child: Column(children: [
            SearchBar(
              onChanged: (value) => context.read<ProjectsBloc>().add(ProjectsEvents.searchTextChanged(value)),
            ),
            BlocBuilder<ProjectsBloc, ProjectsState>(
              buildWhen: (previous, current) =>
                  previous.searchText.value != current.searchText.value || previous.isLoading != current.isLoading,
              builder: (context, state) {
                if (state.isLoading) {
                  return Expanded(child: CircularLoader("Récupération des projets..."));
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
                              onPressed: () => context.read<ProjectsBloc>().add(ProjectsEvents.fetch()),
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
