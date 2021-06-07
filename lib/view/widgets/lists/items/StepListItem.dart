import 'package:flutter/material.dart' hide Step;
import 'package:gobz_app/data/models/Step.dart';
import 'package:gobz_app/view/components/specific/tasks/TaskListComponent.dart';
import 'package:gobz_app/view/widgets/generic/Accordion.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StepListItem extends StatelessWidget {
  final Step step;

  StepListItem({Key? key, required this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.secondary;

    return Accordion(
      contentPadding: EdgeInsets.all(8),
      title: Row(
        children: [
          CircularPercentIndicator(
            animation: true,
            animationDuration: 600,
            radius: 40,
            lineWidth: 5.0,
            percent: step.completion!,
            center: step.completion! < 1
                ? Text(
                    "${(step.completion! * 100).round()}%",
                    style: Theme.of(context).textTheme.headline6?.copyWith(color: color, fontSize: 10),
                  )
                : Icon(
                    Icons.check,
                    color: color,
                  ),
            progressColor: color,
          ),
          Container(width: 5),
          Expanded(
            child: Column(
              children: [
                Text(
                  step.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6?.copyWith(color: color),
                ),
                Text(
                  step.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
      content: TaskListComponent(step: step),
    );
  }
}
