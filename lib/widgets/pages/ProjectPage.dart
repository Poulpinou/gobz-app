import 'package:flutter/material.dart';
import 'package:gobz_app/models/Project.dart';

class ProjectPage extends StatelessWidget {
  final Project project;

  const ProjectPage({Key? key, required this.project}) : super(key: key);

  static Route route(Project project) {
    return MaterialPageRoute<void>(
        builder: (_) => ProjectPage(project: project));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: Text(project.description),
    );
  }
}
