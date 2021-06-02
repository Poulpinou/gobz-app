import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/formInputs/tasks/TaskTextInput.dart';
import 'package:gobz_app/data/models/BlocState.dart';
import 'package:gobz_app/data/models/Task.dart';
import 'package:gobz_app/data/models/requests/TaskCreationRequest.dart';
import 'package:gobz_app/data/models/requests/TaskUpdateRequest.dart';
import 'package:gobz_app/data/repositories/TaskRepository.dart';

class TaskEditionBloc extends Bloc<TaskEditionEvent, TaskEditionState> {
  final int? _stepId;
  final TaskRepository _taskRepository;

  TaskEditionBloc(this._taskRepository, {int? stepId, Task? task})
      : _stepId = stepId,
        super(task != null ? TaskEditionState.fromTask(task) : TaskEditionState.pure());

  @override
  Stream<TaskEditionState> mapEventToState(TaskEditionEvent event) async* {
    if (event is _TaskTextChanged) {
      yield state.copyWith(text: TaskTextInput.dirty(event.text));
    } else if (event is _CreateTaskFormSubmitted) {
      yield* _onCreateTaskSubmitted(state);
    } else if (event is _UpdateTaskFormSubmitted) {
      yield* _onUpdateTaskSubmitted(state);
    }
  }

  Stream<TaskEditionState> _onCreateTaskSubmitted(TaskEditionState state) async* {
    if (state.status.isValidated) {
      yield state.loading();
      try {
        final Task? task = await _taskRepository.createTask(_stepId!, TaskCreationRequest(text: state.text.value));

        yield state.copyWith(task: task);
      } catch (e) {
        yield state.errored(
          DisplayableException(
            "Échec de la création de la tâche",
            errorMessage: 'Task creation failed',
            error: e is Exception ? e : null,
          ),
        );
      }
    }
  }

  Stream<TaskEditionState> _onUpdateTaskSubmitted(TaskEditionState state) async* {
    if (state.status.isValidated) {
      yield state.loading();
      try {
        final Task? task = await _taskRepository.updateTask(state.task!.id, TaskUpdateRequest(text: state.text.value));

        yield state.copyWith(task: task);
      } catch (e) {
        yield state.errored(
          DisplayableException(
            "Échec de la sauvegarde de la tâche",
            errorMessage: 'Task update failed',
            error: e is Exception ? e : null,
          ),
        );
      }
    }
  }
}

// Events
abstract class TaskEditionEvent {}

abstract class TaskEditionEvents {
  static _TaskTextChanged textChanged(String text) => _TaskTextChanged(text);

  static _CreateTaskFormSubmitted createFormSubmitted() => _CreateTaskFormSubmitted();

  static _UpdateTaskFormSubmitted updateFormSubmitted() => _UpdateTaskFormSubmitted();
}

class _TaskTextChanged extends TaskEditionEvent {
  final String text;

  _TaskTextChanged(this.text);
}

class _CreateTaskFormSubmitted extends TaskEditionEvent {}

class _UpdateTaskFormSubmitted extends TaskEditionEvent {}

// State
class TaskEditionState extends BlocState with FormzMixin {
  final Task? task;
  final bool hasBeenUpdated;
  final TaskTextInput text;

  const TaskEditionState._({
    bool? isLoading,
    Exception? error,
    this.hasBeenUpdated = false,
    this.task,
    this.text = const TaskTextInput.pure(),
  }) : super(isLoading: isLoading, error: error);

  factory TaskEditionState.pure() => TaskEditionState._();

  factory TaskEditionState.fromTask(Task task) => TaskEditionState._(
        task: task,
        text: TaskTextInput.pure(taskText: task.text),
      );

  @override
  TaskEditionState copyWith({
    bool? isLoading,
    Exception? error,
    Task? task,
    TaskTextInput? text,
  }) =>
      TaskEditionState._(
        isLoading: isLoading ?? false,
        error: error,
        task: task ?? this.task,
        hasBeenUpdated: task != null,
        text: text ?? this.text,
      );

  @override
  List<FormzInput> get inputs => [text];
}
