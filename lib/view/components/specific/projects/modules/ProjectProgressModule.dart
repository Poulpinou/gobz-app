import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/projects/ProjectBloc.dart';
import 'package:gobz_app/data/models/ProjectProgress.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';
import 'package:gobz_app/view/pages/ChaptersPage.dart';
import 'package:gobz_app/view/widgets/generic/CircularLoader.dart';
import 'package:gobz_app/view/widgets/generic/FetchFailure.dart';
import 'package:gobz_app/view/widgets/generic/SectionDisplay.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProjectProgressModule extends StatelessWidget {
  final int projectId;

  const ProjectProgressModule({Key? key, required this.projectId}) : super(key: key);

  void _goToChapters(BuildContext context) async {
    await Navigator.push(context, ChaptersPage.route(projectId));
    context.read<ProjectBloc>().add(ProjectEvents.fetch());
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot<ProjectProgress> snapshot) {
    if (snapshot.hasError) {
      return FetchFailure(message: "La récupération de la progression a échoué");
    }

    if (snapshot.connectionState != ConnectionState.done) {
      return CircularLoader("Chargement de l'avancement...");
    }

    final ProjectProgress progress = snapshot.data!;

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
            percent: progress.completion,
            center: new Text("${(progress.completion * 100).toStringAsFixed(1)}%"),
            progressColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Chapitres: ${progress.chaptersAmount}"),
              Text("Etapes: ${progress.stepsAmount}"),
              Text("Tâches: ${progress.tasksAmount}"),
              Text("Tâches terminées: ${progress.tasksDoneAmount}"),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProjectProgress>(
      future: context.read<ProjectRepository>().getProjectProgress(projectId),
      builder: (context, snapshot) => SectionDisplay(
        title: 'Avancement',
        icon: Icons.library_add_check_sharp,
        action: TextButton(
          child: const Text("Consulter"),
          onPressed: () => _goToChapters(context),
        ),
        child: _buildBody(context, snapshot),
      ),
    );
  }
}
