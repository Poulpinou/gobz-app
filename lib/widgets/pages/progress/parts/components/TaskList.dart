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
        children: [
          Icon(
            task.isDone ? Icons.check_circle_rounded : Icons.circle,
            size: 10,
          ),
          Padding(padding: EdgeInsets.all(4)),
          Text(
            task.text,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                ),
          ),
        ],
      ),
    );
  }
}
