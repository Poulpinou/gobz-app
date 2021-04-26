import 'package:flutter/material.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/widgets/pages/ProjectPage.dart';

class ProjectList extends StatelessWidget {
  final List<Project> projects;

  const ProjectList({Key? key, required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) =>
          ProjectListItem(project: projects[index]),
      itemCount: projects.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class ProjectListItem extends StatelessWidget {
  final Project project;

  const ProjectListItem({Key? key, required this.project}) : super(key: key);

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
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
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
