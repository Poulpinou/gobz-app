import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/ProjectsBloc.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/widgets/pages/NewProjectPage.dart';

import 'ProjectPage.dart';

class ProjectsPage extends StatelessWidget {
  Widget _fetching() {
    return Expanded(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Container(width: 10),
            const Text(" Récupération des projets...")
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProjectsBloc(projectRepository: RepositoryProvider.of(context)),
      child: Scaffold(
        body: Column(
          children: [
            _SearchBar(),
            BlocBuilder<ProjectsBloc, ProjectsState>(
              buildWhen: (previous, current) =>
                  previous.fetchStatus != current.fetchStatus ||
                  previous.searchText.value != current.searchText.value,
              builder: (context, state) {
                switch (state.fetchStatus) {
                  case ProjectStateStatus.UNFETCHED:
                    context.read<ProjectsBloc>().add(FetchProjectsRequested());
                    return _fetching();
                  case ProjectStateStatus.FETCHING:
                    return _fetching();
                  case ProjectStateStatus.FETCHED:
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
                        child: const Text(
                            "Aucun projet ne correspond à cette recherche"),
                      );
                    }

                    return Expanded(
                        child: _ProjectList(projects: state.filteredProjects));
                  case ProjectStateStatus.ERRORED:
                    return Center(
                      child: Row(
                        children: [
                          const Text("Impossible de récupérer les projets")
                        ],
                      ),
                    );
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(NewProjectPage.route()),
          child: const Icon(Icons.add),
        ),
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
                  icon: Icon(
                    Icons.search,
                  ),
                  hintText: "Chercher un projet",
                ),
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
    return ListView.separated(
      itemBuilder: (context, index) =>
          _ProjectListItem(project: projects[index]),
      itemCount: projects.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        color: Colors.white,
      ),
    );
  }
}

class _ProjectListItem extends StatelessWidget {
  final Project project;

  const _ProjectListItem({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(
                  Icons.image,
                  size: 50,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(project.description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => Navigator.of(context).push(ProjectPage.route(project)),
    );
  }
}
