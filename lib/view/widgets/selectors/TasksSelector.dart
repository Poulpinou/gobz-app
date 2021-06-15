/*
import 'dart:async';

import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/models/Chapter.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/models/Step.dart';
import 'package:gobz_app/data/models/Task.dart';
import 'package:gobz_app/data/repositories/ChapterRepository.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';
import 'package:gobz_app/data/repositories/StepRepository.dart';
import 'package:gobz_app/data/repositories/TaskRepository.dart';
import 'package:gobz_app/view/pages/generic/MultiSelector.dart';
import 'package:gobz_app/view/pages/generic/Selector.dart';

enum StartPoint { SCRATCH, PROJECT, CHAPTER, STEP }

class TasksSelectionField extends StatefulWidget {
  final StartPoint startPoint;
  final Function(List<Task> tasks) onChanged;
  final int? startId;
  final List<Task>? selected;

  const TasksSelectionField({
    Key? key,
    required this.startPoint,
    required this.onChanged,
    this.startId,
    this.selected,
  }) : super(key: key);

  @override
  _TasksSelectionFieldState createState() => _TasksSelectionFieldState();
}

class _TasksSelectionFieldState extends State<TasksSelectionField> {
  List<Task>? selected;
  int? stepId;

  @override
  void initState() {
    super.initState();

    selected = widget.selected;
    if (widget.startPoint == StartPoint.STEP) {
      stepId = widget.startId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            selected?.map((e) => e.text).join(",") ?? "Aucune tâche sélectionnée",
          ),
        ),
        IconButton(
          icon: Icon(Icons.folder),
          onPressed: () => _openSelector(context),
        ),
      ],
    );
  }

  void _openSelector(BuildContext context) async {
    final List<Task>? tasks = await _selectTasks(context);

    setState(() {
      selected = tasks ?? this.selected;
    });

    widget.onChanged(selected ?? []);
  }

  Future<List<Task>?> _selectTasks(BuildContext context) {
    if(selected != null && stepId != null){
      return _selectFromStep(context, stepId!);
    }

    if (widget.startId == null) {
      return _selectFromScratch(context);
    }

    switch (widget.startPoint) {
      case StartPoint.SCRATCH:
        return _selectFromScratch(context);
      case StartPoint.PROJECT:
        return _selectFromProject(context, widget.startId!);
      case StartPoint.CHAPTER:
        return _selectFromChapter(context, widget.startId!);
      case StartPoint.STEP:
        return _selectFromStep(context, widget.startId!);
    }
  }

  Future<List<Task>?> _selectFromStep(BuildContext context, int stepId) async {
    final List<Task> tasks = await context.read<TaskRepository>().getTasks(stepId);

    return Navigator.push<List<Task>?>(
      context,
      MultiSelector.route<Task>(
        title: Text("Choisissez une ou plusieurs tâches"),
        data: tasks,
        selected: selected,
        itemBuilder: (context, task, selected) => Row(
          children: [
            selected ? Icon(Icons.check) : Container(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(task.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Task>?> _selectFromChapter(BuildContext context, int chapterId) async {
    final List<Step> steps = await context.read<StepRepository>().getSteps(chapterId);

    return Navigator.push<List<Task>?>(
      context,
      MaterialPageRoute<List<Task>?>(
        builder: (context) => Selector<Step>(
          title: Text("Choisissez une étape"),
          data: steps,
          itemBuilder: (context, step) => Text(step.name),
          onSelect: (step) async {
            stepId = step.id;

            final List<Task>? tasks = await _selectFromStep(context, step.id);
            if (tasks != null) {
              Navigator.pop(context, tasks);
            }
          },
        ),
      ),
    );
  }

  Future<List<Task>?> _selectFromProject(BuildContext context, int projectId) async {
    final List<Chapter> chapters = await context.read<ChapterRepository>().getChapters(projectId);

    return Navigator.push<List<Task>?>(
      context,
      MaterialPageRoute<List<Task>?>(
        builder: (context) => Selector<Chapter>(
          title: Text("Choisissez un chapitre"),
          data: chapters,
          itemBuilder: (context, chapter) => Text(chapter.name),
          onSelect: (chapter) async {
            final List<Task>? tasks = await _selectFromChapter(context, chapter.id);
            if (tasks != null) {
              Navigator.pop(context, tasks);
            }
          },
        ),
      ),
    );
  }

  Future<List<Task>?> _selectFromScratch(BuildContext context) async {
    final List<Project> projects = await context.read<ProjectRepository>().getAllProjects();

    return Navigator.push<List<Task>?>(
      context,
      MaterialPageRoute<List<Task>?>(
        builder: (context) => Selector<Project>(
          title: Text("Choisissez un projet"),
          data: projects,
          itemBuilder: (context, project) => Text(project.name),
          onSelect: (project) async {
            final List<Task>? tasks = await _selectFromProject(context, project.id);
            if (tasks != null) {
              Navigator.pop(context, tasks);
            }
          },
        ),
      ),
    );
  }
}
*/
