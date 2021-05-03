import 'package:flutter/material.dart' hide Step;
import 'package:gobz_app/models/Step.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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

  const StepListItem({
    Key? key,
    required this.step,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.secondary;

    return InkWell(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    animation: true,
                    animationDuration: 600,
                    radius: 60,
                    lineWidth: 8.0,
                    percent: step.completion,
                    center: step.completion < 1
                        ? Text("${(step.completion * 100).toStringAsFixed(1)}%")
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
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      size: 40,
                    ),
                    onPressed: () => print("Nothing happened..."),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
