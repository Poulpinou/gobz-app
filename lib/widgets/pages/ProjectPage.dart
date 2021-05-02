import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/ProjectBloc.dart';
import 'package:gobz_app/mixins/DisplayableMessage.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';

import 'EditProjectPage.dart';

class ProjectPage extends StatelessWidget {
  final Project project;

  const ProjectPage({Key? key, required this.project}) : super(key: key);

  static Route route(Project project) {
    return MaterialPageRoute<void>(builder: (_) => ProjectPage(project: project));
  }

  // Actions
  void _editProject(BuildContext context) async {
    final Project? project = await Navigator.push(context, EditProjectPage.route(project: this.project));

    if (project != null) {
      context.read<ProjectBloc>().add(FetchProject());
    }
  }

  void _refreshProject(BuildContext context) {
    context.read<ProjectBloc>().add(FetchProject());
  }

  void _deleteProject(BuildContext context) async {
    final bool? isConfirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Supprimer ${project.name}?'),
              content: Text('Attention, cette action est définitive!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Oui'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Non'),
                ),
              ],
            ));

    if (isConfirmed != null && isConfirmed == true) {
      context.read<ProjectBloc>().add(DeleteProject());
    }
  }

  // Build Parts
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<ProjectBloc, ProjectState>(
          buildWhen: (previous, current) => previous.project.name != current.project.name,
          builder: (context, state) => Text(state.project.name)),
      actions: [
        PopupMenuButton<Function>(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.create),
          ),
          onSelected: (function) => function(),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<Function>>[
              PopupMenuItem(
                child: const Text("Actualiser"),
                value: () => _refreshProject(context),
              ),
              PopupMenuItem(
                child: const Text("Modifier"),
                value: () => _editProject(context),
              ),
              PopupMenuItem(
                child: const Text("Supprimer"),
                value: () => _deleteProject(context),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildHandler({required Widget child}) {
    return BlocListener<ProjectBloc, ProjectState>(
      listener: (context, state) {
        if (state.projectDeleted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text("${state.project.name} as été supprimé"),
              backgroundColor: Colors.greenAccent,
            ));
          Navigator.pop(context, null);
        } else if (state.isErrored) {
          final String message;
          if (state.error is DisplayableMessage) {
            message = (state.error as DisplayableMessage).displayableMessage;
          } else {
            message = "Une erreur s'est produite";
          }
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(message),
              backgroundColor: Colors.redAccent,
            ));
        }
      },
      child: child,
    );
  }

  Widget _buildInfos() {
    return BlocBuilder<ProjectBloc, ProjectState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) => Row(
        children: [
          Expanded(
            child: Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.image,
                    size: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.project.description),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectBloc>(
      create: (context) {
        final ProjectBloc bloc = ProjectBloc(context.read<ProjectRepository>(), project);

        bloc.add(FetchProject());

        return bloc;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildHandler(
          child: BlocBuilder<ProjectBloc, ProjectState>(
            buildWhen: (previous, current) => previous.isLoading != current.isLoading,
            builder: (context, state) => Column(
              children: [
                _buildInfos(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
