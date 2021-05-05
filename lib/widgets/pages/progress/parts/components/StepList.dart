import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/TasksBloc.dart';
import 'package:gobz_app/models/Step.dart';
import 'package:gobz_app/repositories/TaskRepository.dart';
import 'package:gobz_app/widgets/misc/Accordion.dart';
import 'package:gobz_app/widgets/misc/BlocHandler.dart';
import 'package:gobz_app/widgets/misc/CircularLoader.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'TaskList.dart';

part 'TaskListWrapper.dart';

class StepList extends StatelessWidget {
  final List<Step> steps;

  const StepList({
    Key? key,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => StepListItem(
        step: steps[index],
      ),
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Theme.of(context).colorScheme.secondary,
      ),
      itemCount: steps.length,
    );
  }
}

class StepListItem extends StatelessWidget {
  final Step step;

  const StepListItem({Key? key, required this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.secondary;

    return Accordion(
      title: Row(
        children: [
          CircularPercentIndicator(
            animation: true,
            animationDuration: 600,
            radius: 40,
            lineWidth: 8.0,
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
          Expanded(
            child: Text(
              step.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6?.copyWith(color: color),
            ),
          ),
        ],
      ),
      content: _TaskListWrapper(step: step),
    );
  }
}
