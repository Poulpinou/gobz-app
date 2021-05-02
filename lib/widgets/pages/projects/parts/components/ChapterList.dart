import 'package:flutter/material.dart';
import 'package:gobz_app/models/Chapter.dart';

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
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(
                  Icons.image,
                  size: 50,
                ),
              ),
              Expanded(
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
