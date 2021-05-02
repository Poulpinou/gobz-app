part of '../../ProjectPage.dart';

class _ProgressInfos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ProjectSectionDisplay(
      title: 'Avancement',
      icon: Icons.library_add_check_sharp,
      action: TextButton(
        child: const Text("Consulter"),
        onPressed: () => print("Going to chapters..."),
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
          final double donePercent = infos.progressInfos.tasksDoneAmount / infos.progressInfos.tasksAmount;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: CircularPercentIndicator(
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
}
