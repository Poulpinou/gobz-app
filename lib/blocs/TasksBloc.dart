import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Step.dart';
import 'package:gobz_app/models/Task.dart';
import 'package:gobz_app/repositories/TaskRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final Step step;
  final TaskRepository taskRepository;

  TasksBloc({required this.step, required this.taskRepository}) : super(TasksState());

  @override
  Stream<TasksState> mapEventToState(TasksEvent event) async* {
    if (event is _FetchTasks) {
      yield* _onFetchTasks(event, state);
    } else if (event is _ChangeSelected) {
      yield event.selected != null ? state.copyWith(selected: event.selected) : state.clearSelected();
    } else if (event is _DeleteTask) {
      yield* _onDeleteTask(event, state);
    }
  }

  Stream<TasksState> _onFetchTasks(_FetchTasks event, TasksState state) async* {
    yield state.copyWith(isLoading: true);
    try {
      final List<Task> tasks = await taskRepository.getTasks(step.id);
      yield state.copyWith(tasks: tasks);
    } catch (e) {
      Log.error("Failed to retrieve tasks", e);
      yield state.copyWith(
          error: DisplayableException(
              internMessage: e.toString(), messageToDisplay: "La récupération des tâches a échoué"));
    }
  }

  Stream<TasksState> _onDeleteTask(_DeleteTask event, TasksState state) async* {
    yield state.copyWith(isLoading: true);
    try {
      await taskRepository.deleteTask(event.task.id);
      yield state.selected?.id == event.task.id ? state.clearSelected() : state;
    } catch (e) {
      Log.error("Failed to delete task", e);
      yield state.copyWith(
          error: DisplayableException(
              internMessage: e.toString(), messageToDisplay: "La suppression de la tâche a échoué"));
    }

    add(TasksEvents.fetch());
  }
}

// Events
abstract class TasksEvent {}

abstract class TasksEvents {
  static _FetchTasks fetch() => _FetchTasks();

  static _ChangeSelected changeSelected(Task? task) => _ChangeSelected(task);

  static _DeleteTask deleteTask(Task task) => _DeleteTask(task);
}

class _FetchTasks extends TasksEvent {}

class _ChangeSelected extends TasksEvent {
  final Task? selected;

  _ChangeSelected(this.selected);
}

class _DeleteTask extends TasksEvent {
  final Task task;

  _DeleteTask(this.task);
}

// States
class TasksState extends BlocState {
  final List<Task> tasks;
  final Task? selected;

  TasksState({
    bool? isLoading,
    Exception? error,
    this.tasks = const [],
    this.selected,
  }) : super(isLoading: isLoading, error: error);

  @override
  TasksState copyWith({
    bool? isLoading,
    Exception? error,
    List<Task>? tasks,
    Task? selected,
  }) =>
      TasksState(
        isLoading: isLoading ?? false,
        error: error,
        tasks: tasks ?? this.tasks,
        selected: selected ?? this.selected,
      );

  TasksState clearSelected() => TasksState(selected: null);
}
