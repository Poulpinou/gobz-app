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
}

// Events
abstract class TasksEvent {}

abstract class TasksEvents {
  static _FetchTasks fetch() => _FetchTasks();
}

class _FetchTasks extends TasksEvent {}

// States
class TasksState extends BlocState {
  final List<Task> tasks;

  TasksState({
    bool? isLoading,
    Exception? error,
    this.tasks = const [],
  }) : super(isLoading: isLoading, error: error);

  @override
  TasksState copyWith({bool? isLoading, Exception? error, List<Task>? tasks}) => TasksState(
        isLoading: isLoading ?? false,
        error: error,
        tasks: tasks ?? this.tasks,
      );
}
