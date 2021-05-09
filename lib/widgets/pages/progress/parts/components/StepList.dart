import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/StepsBloc.dart';
import 'package:gobz_app/blocs/TasksBloc.dart';
import 'package:gobz_app/models/Step.dart';
import 'package:gobz_app/repositories/TaskRepository.dart';
import 'package:gobz_app/widgets/misc/Accordion.dart';
import 'package:gobz_app/widgets/misc/BlocHandler.dart';
import 'package:gobz_app/widgets/misc/CircularLoader.dart';
import 'package:gobz_app/widgets/misc/HoldMenu.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'TaskList.dart';

part 'TaskListWrapper.dart';

class StepList extends StatelessWidget {
  final List<Step> steps;
  final List<PopupMenuEntry<Function(Step step)>>? stepActions;

  const StepList({
    Key? key,
    required this.steps,
    this.stepActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => index < steps.length
          ? StepListItem(
              step: steps[index],
              stepActions: stepActions,
            )
          : Container(height: 80),
      itemCount: steps.length + 1,
    );
  }
}

class StepListItem extends StatelessWidget {
  final Step step;
  final List<PopupMenuEntry<Function(Step step)>>? stepActions;

  StepListItem({Key? key, required this.step, this.stepActions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.secondary;

    return HoldMenu<Function(Step step)>(
      items: stepActions ?? [],
      onSelected: (action) => action?.call(step),
      child: Accordion(
        title: Row(
          children: [
            CircularPercentIndicator(
              animation: true,
              animationDuration: 600,
              radius: 40,
              lineWidth: 5.0,
              percent: step.completion,
              center: step.completion < 1
                  ? Text(
                      "${(step.completion * 100).round()}%",
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
        content: _TaskListWrapper(step: step),
      ),
    );
  }
}
