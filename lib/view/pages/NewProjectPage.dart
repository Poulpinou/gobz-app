import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/projects/ProjectEditionBloc.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';
import 'package:gobz_app/view/components/forms/projects/ProjectForm.dart';

class NewProjectPage extends StatelessWidget {
  static Route<Project> route() {
    return MaterialPageRoute<Project>(builder: (_) => NewProjectPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectEditionBloc>(
      create: (context) => ProjectEditionBloc(context.read<ProjectRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nouveau projet"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: ProjectForm(
              onValidate: (project) => Navigator.pop(context, project),
            ),
          ),
        ),
      ),
    );
  }
}
