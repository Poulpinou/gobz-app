import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/ProjectBloc.dart';
import 'package:gobz_app/mixins/DisplayableMessage.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';

class ProjectPage extends StatelessWidget {
  final Project project;

  const ProjectPage({Key? key, required this.project}) : super(key: key);

  static Route route(Project project) {
    return MaterialPageRoute<void>(
        builder: (_) => ProjectPage(project: project));
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: BlocBuilder<ProjectBloc, ProjectState>(
          buildWhen: (previous, current) =>
              previous.project.name != current.project.name,
          builder: (context, state) => Text(state.project.name)),
      actions: [
        PopupMenuButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.create),
          ),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry>[
              PopupMenuItem(
                child: TextButton(
                  child: const Text("Actualiser"),
                  onPressed: () =>
                      context.read<ProjectBloc>().add(FetchProject()),
                ),
              ),
              PopupMenuItem(
                child: TextButton(
                  child: const Text("Modifier"),
                  onPressed: () => {},
                ),
              ),
              PopupMenuItem(
                child: TextButton(
                  child: const Text("Supprimer"),
                  onPressed: () =>
                      context.read<ProjectBloc>().add(DeleteProject()),
                ),
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
          Navigator.pop(context);
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
            ));
        }
      },
      child: child,
    );
  }

  Widget _buildInfos() {
    return Row(
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
                  child: Text(project.description),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectBloc>(
      create: (context) {
        final ProjectBloc bloc =
            ProjectBloc(context.read<ProjectRepository>(), project);

        bloc.add(FetchProject());

        return bloc;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildHandler(
          child: BlocBuilder<ProjectBloc, ProjectState>(
            buildWhen: (previous, current) =>
                previous.isLoading != current.isLoading,
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
