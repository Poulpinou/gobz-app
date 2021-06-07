import 'package:flutter/material.dart';
import 'package:gobz_app/data/models/Task.dart';
import 'package:gobz_app/view/widgets/generic/AvatarRow.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final bool selected;
  final Function? onClick;

  const TaskListItem({
    Key? key,
    required this.task,
    this.selected = false,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: InkWell(
        onTap: () => onClick?.call(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Icon(
                task.isDone ? Icons.check_circle_rounded : Icons.circle,
                size: 10,
              ),
            ),
            Padding(padding: EdgeInsets.all(4)),
            Expanded(
              child: Text(
                task.text,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      decoration: task.isDone ? TextDecoration.lineThrough : null,
                      color: selected
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).textTheme.bodyText2?.color,
                    ),
                overflow: TextOverflow.visible,
              ),
            ),
            task.workers != null
                ? ConstrainedBox(
                    child: AvatarRow(
                      avatars: task.workers!,
                      avatarsSize: 12,
                      maxDisplayAmount: 3,
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: 100,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
