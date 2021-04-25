import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/ProjectsBloc.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class ProjectScreen extends StatelessWidget {
  Widget _fetching() {
    return Center(
        child: Row(
      children: [
        CircularProgressIndicator(),
        const Text(" Récupération des projets...")
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProjectsBloc(projectRepository: RepositoryProvider.of(context)),
      child: Column(
        children: [
          _SearchBar(),
          BlocBuilder<ProjectsBloc, ProjectsState>(
            buildWhen: (previous, current) =>
                previous.fetchStatus != current.fetchStatus,
            builder: (context, state) {
              switch (state.fetchStatus) {
                case ProjectStateStatus.UNFETCHED:
                  context.read<ProjectsBloc>().add(FetchProjectsRequested());
                  return _fetching();
                case ProjectStateStatus.FETCHING:
                case ProjectStateStatus.SORTING:
                  return _fetching();
                case ProjectStateStatus.FETCHED:
                case ProjectStateStatus.SORTED:
                  if (state.projects.length == 0) {
                    return Center(
                      child: const Text("Vous n'avez encore aucun projet."),
                    );
                  }

                  if (state.filteredProjects.length == 0) {
                    return Center(
                      child: const Text(
                          "Aucun projet ne correspond à cette recherche"),
                    );
                  }

                  return _ProjectList(projects: state.filteredProjects);
                case ProjectStateStatus.ERRORED:
                  return Center(
                      child: Row(
                    children: [
                      const Text("Impossible de récupérer les projets")
                    ],
                  ));
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).secondaryHeaderColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) =>
                    context.read<ProjectsBloc>().add(SearchTextChanged(value)),
                decoration: InputDecoration(
                    icon: Icon(Icons.search), hintText: "Chercher un projet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  final List<Project> projects;

  const _ProjectList({Key? key, required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: projects
            .map((project) => _ProjectListItem(project: project))
            .toList(),
      ),
    );
  }
}

class _ProjectListItem extends StatelessWidget {
  final Project project;

  const _ProjectListItem({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ElevatedButton(
        onPressed: () => Log.info("${project.name} clicked"),
        child: Row(
          children: [
            Text(project.name),
          ],
        ),
      ),
    );
  }
}
