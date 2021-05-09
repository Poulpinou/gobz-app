import 'package:flutter/material.dart';
import 'package:gobz_app/models/Task.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: tasks.map((task) => TaskListItem(task: task)).toList(),
    );
  }
}

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
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
              task.text +
                  "gds dtrjqer qyhsrjyj rheq hsysrtr sgqsrt hq hst qrg trh qsrg rsht syd jfhq SH T QDGQD TH SDTH RSG S THSRY J SFH SYRFH TQD H SG WDV GFN SXFN F H",
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                  ),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
