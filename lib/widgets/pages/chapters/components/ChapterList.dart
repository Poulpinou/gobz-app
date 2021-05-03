import 'package:flutter/material.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ChapterList extends StatelessWidget {
  final List<Chapter> chapters;
  final Function(Chapter chapter)? onChapterClicked;

  const ChapterList({
    Key? key,
    required this.chapters,
    this.onChapterClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => ChapterListItem(
              chapter: chapters[index],
              onChapterClicked: onChapterClicked,
            ),
        separatorBuilder: (BuildContext context, int index) => Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
        itemCount: chapters.length);
  }
}

class ChapterListItem extends StatelessWidget {
  final Chapter chapter;
  final Function(Chapter chapter)? onChapterClicked;

  const ChapterListItem({
    Key? key,
    required this.chapter,
    this.onChapterClicked,
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
                  radius: 60,
                  lineWidth: 8.0,
                  percent: chapter.completion,
                  center: new Text(chapter.completion < 1 ? "${(chapter.completion * 100).toStringAsFixed(1)}%" : "OK"),
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
      onTap: () => onChapterClicked?.call(chapter),
    );
  }
}
