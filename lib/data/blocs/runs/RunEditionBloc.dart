import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/generic/states/EditionBlocState.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/formInputs/runs/RunLimitDateInput.dart';
import 'package:gobz_app/data/formInputs/runs/RunStepInput.dart';
import 'package:gobz_app/data/formInputs/runs/RunTaskListInput.dart';
import 'package:gobz_app/data/models/Run.dart';
import 'package:gobz_app/data/models/Step.dart';
import 'package:gobz_app/data/models/Task.dart';
import 'package:gobz_app/data/models/requests/RunCreationRequest.dart';
import 'package:gobz_app/data/repositories/RunRepository.dart';

class RunEditionBloc extends Bloc<RunEditionEvent, RunEditionState> {
  final RunRepository _runRepository;

  RunEditionBloc._(this._runRepository, RunEditionState state) : super(state);

  factory RunEditionBloc.creation(RunRepository runRepository) {
    return RunEditionBloc._(runRepository, RunEditionState.pure());
  }

  @override
  Stream<RunEditionState> mapEventToState(RunEditionEvent event) async* {
    if (event is _RunLimitDateChanged) {
      yield state.copyWith(limitDate: RunLimitDateInput.dirty(event.limitDate));
    } else if (event is _RunStepChanged) {
      yield state.copyWith(step: RunStepInput.dirty(event.step), tasks: RunTaskListInput.pure());
    } else if (event is _RunTasksChanged) {
      yield state.copyWith(tasks: RunTaskListInput.dirty(event.tasks));
    } else if (event is _CreateRunFormSubmitted) {
      yield* _onCreateRunSubmitted(state);
    }
  }

  Stream<RunEditionState> _onCreateRunSubmitted(RunEditionState state) async* {
    if (state.status.isValidated) {
      yield state.loading();
      try {
        final Run? run = await _runRepository.createRun(
          RunCreationRequest(
            stepId: state.step.value!.id,
            taskIds: state.tasks.value!.map((task) => task.id).toList(),
            limitDate: state.limitDate.value,
          ),
        );

        yield state.copyWith(run: run, formStatus: FormzStatus.submissionSuccess);
      } catch (e) {
        yield state.errored(
          DisplayableException(
            "Échec de la création du run",
            errorMessage: 'Run creation failed',
            error: e is Exception ? e : null,
          ),
        );
      }
    }
  }
}

// Events
abstract class RunEditionEvent {}

abstract class RunEditionEvents {
  static _RunLimitDateChanged limitDateChanged(DateTime? limitDate) => _RunLimitDateChanged(limitDate);

  static _RunLimitDateChanged limitDateCleared() => _RunLimitDateChanged(null);

  static _RunStepChanged stepChanged(Step? step) => _RunStepChanged(step);

  static _RunTasksChanged tasksChanged(List<Task>? tasks) => _RunTasksChanged(tasks);

  static _CreateRunFormSubmitted create() => _CreateRunFormSubmitted();
}

class _RunLimitDateChanged implements RunEditionEvent {
  final DateTime? limitDate;

  const _RunLimitDateChanged(this.limitDate);
}

class _RunStepChanged implements RunEditionEvent {
  final Step? step;

  const _RunStepChanged(this.step);
}

class _RunTasksChanged implements RunEditionEvent {
  final List<Task>? tasks;

  const _RunTasksChanged(this.tasks);
}

class _CreateRunFormSubmitted implements RunEditionEvent {}

// State
class RunEditionState extends EditionBlocState {
  final Run? run;
  final RunLimitDateInput limitDate;
  final RunStepInput step;
  final RunTaskListInput tasks;

  const RunEditionState._({
    FormzStatus formStatus = FormzStatus.pure,
    Exception? error,
    this.run,
    this.limitDate = const RunLimitDateInput.pure(),
    this.step = const RunStepInput.pure(),
    this.tasks = const RunTaskListInput.pure(),
  }) : super(formStatus: formStatus, error: error);

  factory RunEditionState.pure() => RunEditionState._();

  bool get hasLimitDate => limitDate.hasLimitDate;

  @override
  RunEditionState copyWith({
    bool? isLoading,
    Exception? error,
    FormzStatus? formStatus,
    Run? run,
    RunLimitDateInput? limitDate,
    RunStepInput? step,
    RunTaskListInput? tasks,
  }) =>
      RunEditionState._(
        error: error,
        formStatus: formStatus ?? this.formStatus,
        run: run ?? this.run,
        limitDate: limitDate ?? this.limitDate,
        step: step ?? this.step,
        tasks: tasks ?? this.tasks,
      );

  @override
  List<FormzInput> get inputs => [limitDate, step, tasks];
}
