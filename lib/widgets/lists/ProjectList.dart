import 'package:flutter/material.dart';
import 'package:gobz_app/models/Project.dart';

class ProjectList extends StatelessWidget {
  final List<Project> projects;
  final Function(Project)? onProjectClicked;

  const ProjectList({Key? key, required this.projects, this.onProjectClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => ProjectListItem(
        project: projects[index],
        onProjectClicked: onProjectClicked,
      ),
      itemCount: projects.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class ProjectListItem extends StatelessWidget {
  final Project project;
  final Function(Project)? onProjectClicked;

  const ProjectListItem({Key? key, required this.project, this.onProjectClicked}) : super(key: key);

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
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                    Text(project.description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => onProjectClicked?.call(project),
    );
  }
}
