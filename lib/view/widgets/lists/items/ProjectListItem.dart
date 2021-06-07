import 'package:flutter/material.dart';
import 'package:gobz_app/data/models/Project.dart';

class ProjectListItem extends StatelessWidget {
  final Project project;
  final Function? onClick;

  const ProjectListItem({
    Key? key,
    required this.project,
    this.onClick,
  }) : super(key: key);

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
      onTap: () => onClick?.call(),
    );
  }
}
