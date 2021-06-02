import 'package:flutter/material.dart';
import 'package:gobz_app/data/models/Run.dart';
import 'package:gobz_app/data/models/enums/RunStatus.dart';
import 'package:gobz_app/view/widgets/texts/RunStatusDisplay.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RunListItem extends StatelessWidget {
  final Run run;
  final List<PopupMenuEntry<Function>>? actions;

  const RunListItem({Key? key, required this.run, this.actions}) : super(key: key);

  Widget _buildMenu(BuildContext context) {
    if (actions == null) {
      return Container();
    }

    return PopupMenuButton<Function>(
      onSelected: (action) => action.call(),
      itemBuilder: (context) => actions!,
      child: Icon(Icons.more_vert),
    );
  }

  Widget _buildTaskProgressBar(BuildContext context) {
    // Get those values from back
    final int totalTasks = run.tasks.length;
    final int doneTasks = run.tasks.where((task) => task.isDone).length;

    return LinearPercentIndicator(
      padding: EdgeInsets.zero,
      lineHeight: 16.0,
      animation: true,
      animationDuration: 600,
      //percent: run.completion!,
      percent: 0.5,
      center: Text("$doneTasks / $totalTasks"),
      progressColor: Theme.of(context).colorScheme.secondary,
      linearStrokeCap: LinearStrokeCap.roundAll,
    );
  }

  Widget _buildTimeProgressBar(BuildContext context) {
    if (run.status == RunStatus.DONE || run.status == RunStatus.ABANDONED) {
      return Container();
    }

    final Duration remainingDuration = run.limitDate.difference(DateTime.now());
    final String message;
    if (run.status == RunStatus.LATE) {
      message =
          "En retard depuis ${remainingDuration.inDays} jours et ${remainingDuration.inHours % (remainingDuration.inDays * 24)} heures";
    } else if (remainingDuration.inDays > 0) {
      message = "${remainingDuration.inDays} jours restants";
    } else {
      message =
          "${remainingDuration.inHours} heures et ${remainingDuration.inMinutes % (remainingDuration.inHours * 60)} minutes restantes";
    }

    return LinearPercentIndicator(
      padding: EdgeInsets.zero,
      lineHeight: 16.0,
      animation: true,
      animationDuration: 600,
      percent: 0.8,
      center: Text(message),
      progressColor: run.status == RunStatus.LATE ? Colors.redAccent : Color(0xFFE0C6A0),
      linearStrokeCap: LinearStrokeCap.roundAll,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RunStatusDisplay(
                    status: run.status,
                  ),
                ),
                //Container(width: 5),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        run.step.name,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Theme.of(context).colorScheme.secondary),
                        //textAlign: TextAlign.center,
                      ),
                      Text(
                        run.project.name,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildMenu(context),
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              child: _buildTimeProgressBar(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              child: _buildTaskProgressBar(context),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
