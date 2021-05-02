import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/ProjectEditionBloc.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';
import 'package:gobz_app/widgets/forms/projects/ProjectForm.dart';

class EditProjectPage extends StatelessWidget {
  final Project project;

  const EditProjectPage({Key? key, required this.project}) : super(key: key);

  static Route<Project> route({required Project project}) {
    return MaterialPageRoute<Project>(
        builder: (context) => EditProjectPage(
              project: project,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectEditionBloc>(
      create: (context) => ProjectEditionBloc(context.read<ProjectRepository>(), project: project),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edition de ${project.name}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
              child: UpdateProjectForm(
                  project: project,
                  onValidate: (project) {
                    Navigator.pop(context, project);
                  })),
        ),
      ),
    );
  }
}
