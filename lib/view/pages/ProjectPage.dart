import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/projects/ProjectBloc.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';
import 'package:gobz_app/view/components/forms/projects/ProjectForm.dart';
import 'package:gobz_app/view/components/specific/projects/modules/ProjectInfosModule.dart';
import 'package:gobz_app/view/components/specific/projects/modules/ProjectMembersModule.dart';
import 'package:gobz_app/view/components/specific/projects/modules/ProjectProgressModule.dart';
import 'package:gobz_app/view/components/specific/projects/modules/ProjectResourcesModule.dart';
import 'package:gobz_app/view/components/specific/projects/modules/ProjectStatisticsModule.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';
import 'package:gobz_app/view/widgets/generic/CircularLoader.dart';
import 'package:gobz_app/view/widgets/generic/FetchFailure.dart';

import 'FormPage.dart';

class ProjectPage extends StatelessWidget {
  static const double SPACE_BETWEEN_MODULES = 10;

  final int projectId;

  const ProjectPage({Key? key, required this.projectId}) : super(key: key);

  static Route route(int projectId) {
    return MaterialPageRoute<void>(builder: (_) => ProjectPage(projectId: projectId));
  }

  // Actions
  void _editProject(BuildContext context, Project project) async {
    final Project? result = await Navigator.push(
      context,
      FormPage.route<Project>(
        EditProjectForm(
          project: project,
          onValidate: (result) => Navigator.pop(context, result),
        ),
        title: "Edition de ${project.name}",
      ),
    );

    if (result != null) {
      context.read<ProjectBloc>().add(ProjectEvents.fetch());
    }
  }

  void _refreshProject(BuildContext context) {
    context.read<ProjectBloc>().add(ProjectEvents.fetch());
  }

  void _deleteProject(BuildContext context, Project project) async {
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
      context.read<ProjectBloc>().add(ProjectEvents.delete());
    }
  }

  // Build Parts
  AppBar _buildAppBar(BuildContext context, Project? project) {
    return AppBar(
      title: Text(project?.name ?? "Chargement du projet..."),
      actions: project != null
          ? [
              PopupMenuButton<Function>(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.more_vert),
                ),
                onSelected: (function) => function(),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Function>>[
                  PopupMenuItem(
                    child: const Text("Actualiser"),
                    value: () => _refreshProject(context),
                  ),
                  PopupMenuItem(
                    child: const Text("Modifier"),
                    value: () => _editProject(context, project),
                  ),
                  PopupMenuItem(
                    child: const Text("Supprimer"),
                    value: () => _deleteProject(context, project),
                  ),
                ],
              ),
            ]
          : null,
    );
  }

  Widget _buildBody(BuildContext context, ProjectState state) {
    if (state.isErrored) {
      return FetchFailure(
        message: "Le chargement du projet a échoué",
        error: state.error,
        retryFunction: () => _refreshProject(context),
      );
    }

    if (!state.hasBeenFetched) {
      return CircularLoader("Chargement du projet...");
    }

    final Project project = state.project!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProjectInfosModule.fromProject(project),
            Container(height: SPACE_BETWEEN_MODULES),
            ProjectProgressModule(projectId: projectId),
            Container(height: SPACE_BETWEEN_MODULES),
            ProjectMembersModule(projectId: projectId),
            Container(height: SPACE_BETWEEN_MODULES),
            ProjectResourcesModule(),
            Container(height: SPACE_BETWEEN_MODULES),
            ProjectStatisticsModule(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandler({required Widget child}) {
    return BlocHandler<ProjectBloc, ProjectState>.custom(
      mapEventToNotification: (state) {
        if (state.hasBeenDeleted) {
          return BlocNotification.success("${state.project?.name ?? "Le projet"} a été supprimé")
              .copyWith(postAction: (context) => Navigator.pop(context, null));
        }
      },
      child: child,
    );
  }

  // Build
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectBloc>(
      create: (context) => ProjectBloc(
        projectRepository: context.read<ProjectRepository>(),
        projectId: projectId,
        fetchOnStart: true,
      ),
      child: BlocBuilder<ProjectBloc, ProjectState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) => Scaffold(
          appBar: _buildAppBar(context, state.project),
          body: _buildHandler(child: _buildBody(context, state)),
        ),
      ),
    );
  }
}
