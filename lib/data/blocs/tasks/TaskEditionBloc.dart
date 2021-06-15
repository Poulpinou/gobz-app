import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/generic/states/EditionBlocState.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/formInputs/tasks/TaskTextInput.dart';
import 'package:gobz_app/data/models/Task.dart';
import 'package:gobz_app/data/models/requests/TaskCreationRequest.dart';
import 'package:gobz_app/data/models/requests/TaskUpdateRequest.dart';
import 'package:gobz_app/data/repositories/TaskRepository.dart';

class TaskEditionBloc extends Bloc<TaskEditionEvent, TaskEditionState> {
  final TaskRepository _taskRepository;

  TaskEditionBloc._(this._taskRepository, TaskEditionState state) : super(state);

  factory TaskEditionBloc.creation(TaskRepository taskRepository) {
    return TaskEditionBloc._(taskRepository, TaskEditionState.pure());
  }

  factory TaskEditionBloc.edition(TaskRepository taskRepository, Task task) {
    return TaskEditionBloc._(taskRepository, TaskEditionState.fromTask(task));
  }

  @override
  Stream<TaskEditionState> mapEventToState(TaskEditionEvent event) async* {
    if (event is _TaskTextChanged) {
      yield state.copyWith(text: TaskTextInput.dirty(event.text));
    } else if (event is _CreateTaskFormSubmitted) {
      yield* _onCreateTaskSubmitted(state, event);
    } else if (event is _UpdateTaskFormSubmitted) {
      yield* _onUpdateTaskSubmitted(state);
    }
  }

  Stream<TaskEditionState> _onCreateTaskSubmitted(TaskEditionState state, _CreateTaskFormSubmitted event) async* {
    if (state.status.isValidated) {
      yield state.loading();
      try {
        final Task? task = await _taskRepository.createTask(event.stepId, TaskCreationRequest(text: state.text.value));

        yield state.copyWith(task: task, formStatus: FormzStatus.submissionSuccess);
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

        yield state.copyWith(task: task, formStatus: FormzStatus.submissionSuccess);
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

  static _CreateTaskFormSubmitted create(int stepId) => _CreateTaskFormSubmitted(stepId);

  static _UpdateTaskFormSubmitted update() => _UpdateTaskFormSubmitted();
}

class _TaskTextChanged extends TaskEditionEvent {
  final String text;

  _TaskTextChanged(this.text);
}

class _CreateTaskFormSubmitted extends TaskEditionEvent {
  final int stepId;

  _CreateTaskFormSubmitted(this.stepId);
}

class _UpdateTaskFormSubmitted extends TaskEditionEvent {}

// State
class TaskEditionState extends EditionBlocState {
  final Task? task;
  final TaskTextInput text;

  const TaskEditionState._({
    FormzStatus formStatus = FormzStatus.pure,
    Exception? error,
    this.task,
    this.text = const TaskTextInput.pure(),
  }) : super(formStatus: formStatus, error: error);

  factory TaskEditionState.pure() => TaskEditionState._();

  factory TaskEditionState.fromTask(Task task) => TaskEditionState._(
        task: task,
        text: TaskTextInput.pure(taskText: task.text),
      );

  @override
  TaskEditionState copyWith({
    bool? isLoading,
    Exception? error,
    FormzStatus? formStatus,
    Task? task,
    TaskTextInput? text,
  }) =>
      TaskEditionState._(
        error: error,
        formStatus: formStatus ?? this.formStatus,
        task: task ?? this.task,
        text: text ?? this.text,
      );

  @override
  List<FormzInput> get inputs => [text];
}
