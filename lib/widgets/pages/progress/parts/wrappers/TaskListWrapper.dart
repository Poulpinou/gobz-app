import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/TaskEditionBloc.dart';
import 'package:gobz_app/blocs/TasksBloc.dart';
import 'package:gobz_app/models/Step.dart';
import 'package:gobz_app/models/Task.dart';
import 'package:gobz_app/repositories/TaskRepository.dart';
import 'package:gobz_app/widgets/forms/tasks/TaskForm.dart';
import 'package:gobz_app/widgets/misc/BlocHandler.dart';
import 'package:gobz_app/widgets/misc/CircularLoader.dart';
import 'package:gobz_app/widgets/pages/progress/parts/components/TaskList.dart';

class TaskListWrapper extends StatefulWidget {
  final Step step;

  const TaskListWrapper({Key? key, required this.step}) : super(key: key);

  @override
  _TaskListWrapperState createState() => _TaskListWrapperState();
}

enum _FormMode { NORMAL, CREATION, EDITION }

class _TaskListWrapperState extends State<TaskListWrapper> {
  _FormMode _mode = _FormMode.NORMAL;

  void _onCreateTask() {
    setState(() {
      _mode = _FormMode.CREATION;
    });
  }

  void _onEditTask() {
    setState(() {
      _mode = _FormMode.EDITION;
    });
  }

  void _exitMode() {
    setState(() {
      _mode = _FormMode.NORMAL;
    });
  }

  void _onSelectedTaskChanged(BuildContext context, Task? task) {
    context.read<TasksBloc>().add(TasksEvents.changeSelected(task));
  }

  void _refreshTasks(BuildContext context) {
    context.read<TasksBloc>().add(TasksEvents.fetch());
  }

  void _deleteTask(BuildContext context, Task task) {
    context.read<TasksBloc>().add(TasksEvents.deleteTask(task));
  }

  Widget _buildBottomBar(BuildContext context) {
    switch (_mode) {
      case _FormMode.EDITION:
        return BlocBuilder<TasksBloc, TasksState>(
          builder: (context, state) => BlocProvider<TaskEditionBloc>(
            create: (context) => TaskEditionBloc(context.read<TaskRepository>(), task: state.selected),
            child: TaskForm(
              task: state.selected,
              onValidate: (task) {
                _exitMode();
                _refreshTasks(context);
              },
              onCancel: _exitMode,
            ),
          ),
        );

      case _FormMode.CREATION:
        return BlocProvider<TaskEditionBloc>(
          create: (context) => TaskEditionBloc(
            context.read<TaskRepository>(),
            stepId: widget.step.id,
          ),
          child: TaskForm(
            onValidate: (task) {
              _refreshTasks(context);
              _exitMode();
            },
            onCancel: _exitMode,
          ),
        );

      case _FormMode.NORMAL:
        return BlocBuilder<TasksBloc, TasksState>(
          buildWhen: (previous, current) => previous.selected?.id != current.selected?.id,
          builder: (context, state) => Row(
            children: [
              state.selected != null
                  ? IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: _onEditTask)
                  : Container(),
              state.selected != null
                  ? IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () => _deleteTask(context, state.selected!))
                  : Container(),
              Expanded(child: Container()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _onCreateTask,
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksBloc>(
      create: (context) => TasksBloc(
        step: widget.step,
        taskRepository: context.read<TaskRepository>(),
        fetchOnStart: true,
      ),
      child: BlocHandler<TasksBloc, TasksState>.simple(
        child: BlocBuilder<TasksBloc, TasksState>(
          buildWhen: (previous, current) => previous.isLoading != current.isLoading,
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularLoader("Récupération des tâches..."));
            }

            if (state.isErrored) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Impossible de récupérer les tâches"),
                    ElevatedButton(
                        onPressed: () => context.read<TasksBloc>().add(TasksEvents.fetch()),
                        child: const Text("Réessayer"))
                  ],
                ),
              );
            }

            return Column(
              children: [
                state.tasks.length == 0
                    ? Center(
                        child: const Text("Il n'y a aucune tâche dans cette étape"),
                      )
                    : TaskList(
                        tasks: state.tasks,
                        selectedId: state.selected?.id ?? null,
                        onTaskSelect: (task) => _onSelectedTaskChanged(context, task),
                      ),
                _buildBottomBar(context),
              ],
            );
          },
        ),
      ),
    );
  }
}
