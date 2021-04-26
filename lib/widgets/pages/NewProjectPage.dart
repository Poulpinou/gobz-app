import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/ProjectEditionBloc.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';
import 'package:gobz_app/widgets/forms/ProjectForm.dart';

class NewProjectPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NewProjectPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectEditionBloc>(
      create: (context) =>
          ProjectEditionBloc(context.read<ProjectRepository>()),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Nouveau projet"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(child: CreateProjectForm()),
        ),
      ),
    );
  }
}
