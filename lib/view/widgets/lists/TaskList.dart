import 'package:flutter/material.dart';
import 'package:gobz_app/data/models/Task.dart';
import 'package:gobz_app/view/widgets/generic/AvatarRow.dart';

class TaskList extends StatefulWidget {
  final List<Task> tasks;
  final int? selectedId;
  final Function(Task? task)? onTaskSelect;

  const TaskList({
    Key? key,
    required this.tasks,
    this.selectedId,
    this.onTaskSelect,
  }) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  int? _selectedId;

  @override
  void initState() {
    _selectedId = widget.selectedId;

    super.initState();
  }

  void _selectTask(Task task) {
    setState(() {
      _selectedId = _selectedId != task.id ? task.id : null;
    });

    widget.onTaskSelect?.call(_selectedId != null ? widget.tasks.firstWhere((task) => task.id == _selectedId) : null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widget.tasks
          .map((task) => TaskListItem(
                task: task,
                selected: _selectedId == null ? false : task.id == _selectedId,
                onTap: _selectTask,
              ))
          .toList(),
    );
  }
}

class TaskListItem extends StatelessWidget {
  final Task task;
  final bool selected;
  final Function(Task task)? onTap;

  const TaskListItem({
    Key? key,
    required this.task,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: InkWell(
        onTap: () => onTap?.call(task),
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
