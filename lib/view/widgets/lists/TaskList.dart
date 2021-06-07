import 'package:flutter/material.dart';
import 'package:gobz_app/data/models/Task.dart';

import 'items/TaskListItem.dart';

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
          .map(
            (task) => TaskListItem(
              task: task,
              selected: _selectedId == null ? false : task.id == _selectedId,
              onClick: () => _selectTask(task),
            ),
          )
          .toList(),
    );
  }
}
