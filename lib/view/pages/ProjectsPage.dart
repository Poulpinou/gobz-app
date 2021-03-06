import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/projects/ProjectsBloc.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';
import 'package:gobz_app/view/components/forms/projects/ProjectForm.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';
import 'package:gobz_app/view/widgets/generic/CircularLoader.dart';
import 'package:gobz_app/view/widgets/inputs/SearchBar.dart';
import 'package:gobz_app/view/widgets/lists/GenericList.dart';
import 'package:gobz_app/view/widgets/lists/items/ProjectListItem.dart';

import 'FormPage.dart';
import 'ProjectPage.dart';

class ProjectsPage extends StatelessWidget {
  // Actions
  void _createProject(BuildContext context) async {
    final Project? project = await Navigator.push(
      context,
      FormPage.route<Project>(
        NewProjectForm(
          onValidate: (result) => Navigator.pop(context, result),
        ),
        title: "Nouveau Projet",
      ),
    );

    if (project != null) {
      context.read<ProjectsBloc>().add(ProjectsEvents.fetch());

      Navigator.push(context, ProjectPage.route(project.id));
    }
  }

  void _clickProject(BuildContext context, Project project) async {
    await Navigator.push(context, ProjectPage.route(project.id));

    context.read<ProjectsBloc>().add(ProjectsEvents.fetch());
  }

  // Build
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectsBloc>(
      create: (context) => ProjectsBloc(
        projectRepository: RepositoryProvider.of<ProjectRepository>(context),
        fetchOnStart: true,
      ),
      child: Scaffold(
        body: BlocHandler<ProjectsBloc, ProjectsState>.simple(
          child: BlocBuilder<ProjectsBloc, ProjectsState>(
            buildWhen: (previous, current) => previous.isLoading != current.isLoading,
            builder: (context, state) => Column(children: [
              SearchBar(
                onChanged: (value) => context.read<ProjectsBloc>().add(ProjectsEvents.searchTextChanged(value)),
              ),
              BlocBuilder<ProjectsBloc, ProjectsState>(
                buildWhen: (previous, current) =>
                    previous.searchText.value != current.searchText.value || previous.isLoading != current.isLoading,
                builder: (context, state) {
                  if (state.isLoading) {
                    return Expanded(child: CircularLoader("R??cup??ration des projets..."));
                  }

                  if (state.isErrored) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Impossible de r??cup??rer les projets"),
                            ElevatedButton(
                                onPressed: () => context.read<ProjectsBloc>().add(ProjectsEvents.fetch()),
                                child: const Text("R??essayer"))
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
                      child: const Text("Aucun projet ne correspond ?? cette recherche"),
                    );
                  }

                  return Expanded(
                    child: GenericList<Project>(
                      data: state.filteredProjects,
                      itemBuilder: (context, project) => ProjectListItem(
                        project: project,
                        onClick: () => _clickProject(context, project),
                      ),
                      separatorBuilder: (context, index) => Divider(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  );
                },
              ),
            ]),
          ),
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
