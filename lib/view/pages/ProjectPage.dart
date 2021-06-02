import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/projects/ProjectBloc.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/models/ProjectInfos.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';
import 'package:gobz_app/view/widgets/generic/SectionDisplay.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'ChaptersPage.dart';
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
      context.read<ProjectBloc>().add(ProjectEvents.fetch());
    }
  }

  void _refreshProject(BuildContext context) {
    context.read<ProjectBloc>().add(ProjectEvents.fetch());
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
      context.read<ProjectBloc>().add(ProjectEvents.delete());
    }
  }

  void _goToChapters(BuildContext context) async {
    await Navigator.push(context, ChaptersPage.route(project));

    _refreshProject(context);
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
              value: () => _editProject(context),
            ),
            PopupMenuItem(
              child: const Text("Supprimer"),
              value: () => _deleteProject(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHandler({required Widget child}) {
    return BlocHandler<ProjectBloc, ProjectState>.custom(
      mapErrorToNotification: (state) {
        if (state.projectDeleted) {
          return BlocNotification.success("${state.project.name} a été supprimé")
              .copyWith(postAction: (context) => Navigator.pop(context, null));
        }
      },
      child: child,
    );
  }

  Widget _buildProjectInfos(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) => SectionDisplay(
        title: 'Infos',
        icon: Icons.info,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.image,
                  size: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "General",
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text("Créé le ${DateFormat("dd/MM/yyyy à hh:mm").format(state.project.createdAt)}"),
                      Text("Public: ${state.project.isShared ? 'oui' : 'non'}"),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    state.project.description,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressInfos(BuildContext context) {
    return SectionDisplay(
      title: 'Avancement',
      icon: Icons.library_add_check_sharp,
      action: TextButton(
        child: const Text("Consulter"),
        onPressed: () => _goToChapters(context),
      ),
      child: BlocBuilder<ProjectBloc, ProjectState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          if (state.projectInfos == null) {
            return Center(
              child: Text("Impossible de récupérer les infos"),
            );
          }

          final ProjectInfos infos = state.projectInfos!;
          final double donePercent = infos.progressInfos.tasksAmount == 0
              ? 0
              : infos.progressInfos.tasksDoneAmount / infos.progressInfos.tasksAmount;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: CircularPercentIndicator(
                  animation: true,
                  animationDuration: 600,
                  radius: 80.0,
                  lineWidth: 8.0,
                  percent: donePercent,
                  center: new Text("${(donePercent * 100).toStringAsFixed(1)}%"),
                  progressColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Chapitres: ${infos.progressInfos.chaptersAmount}"),
                    Text("Etapes: ${infos.progressInfos.stepsAmount}"),
                    Text("Tâches: ${infos.progressInfos.tasksAmount}"),
                    Text("Tâches terminées: ${infos.progressInfos.tasksDoneAmount}"),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResourcesInfos(BuildContext context) {
    return SectionDisplay(
      title: 'Ressources',
      icon: Icons.storage,
      child: const Text("Arrive bientôt!"),
    );
  }

  Widget _buildMembersInfos(BuildContext context) {
    return SectionDisplay(
      title: 'Membres',
      icon: Icons.group,
      child: const Text("Arrive bientôt!"),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return SectionDisplay(
      title: 'Statistiques',
      icon: Icons.bar_chart,
      child: const Text("Arrive bientôt!"),
    );
  }

  // Build
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectBloc>(
      create: (context) => ProjectBloc(
        context.read<ProjectRepository>(),
        project,
        fetchOnStart: true,
      ),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildHandler(
          child: BlocBuilder<ProjectBloc, ProjectState>(
            buildWhen: (previous, current) => previous.isLoading != current.isLoading,
            builder: (context, state) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProjectInfos(context),
                    _buildProgressInfos(context),
                    _buildMembersInfos(context),
                    _buildResourcesInfos(context),
                    _buildStatistics(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
