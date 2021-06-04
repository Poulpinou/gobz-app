import 'package:flutter/material.dart';
import 'package:gobz_app/data/models/Chapter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ChapterListItem extends StatelessWidget {
  final Chapter chapter;
  final Function? onClick;

  const ChapterListItem({
    Key? key,
    required this.chapter,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: CircularPercentIndicator(
                  animation: true,
                  animationDuration: 600,
                  radius: 60,
                  lineWidth: 8.0,
                  percent: chapter.completion!,
                  center: Text(chapter.completion! < 1 ? "${(chapter.completion! * 100).toStringAsFixed(1)}%" : "OK"),
                  progressColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                    Text(chapter.description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => onClick?.call(),
    );
  }
}
