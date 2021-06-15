import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/generic/states/EditionBlocState.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/formInputs/steps/StepDescriptionInput.dart';
import 'package:gobz_app/data/formInputs/steps/StepNameInput.dart';
import 'package:gobz_app/data/models/Step.dart';
import 'package:gobz_app/data/models/requests/StepCreationRequest.dart';
import 'package:gobz_app/data/models/requests/StepUpdateRequest.dart';
import 'package:gobz_app/data/repositories/StepRepository.dart';

class StepEditionBloc extends Bloc<StepEditionEvent, StepEditionState> {
  final StepRepository _stepRepository;

  StepEditionBloc._(this._stepRepository, StepEditionState state) : super(state);

  factory StepEditionBloc.creation(StepRepository stepRepository) {
    return StepEditionBloc._(stepRepository, StepEditionState.pure());
  }

  factory StepEditionBloc.edition(StepRepository stepRepository, Step step) {
    return StepEditionBloc._(stepRepository, StepEditionState.fromStep(step));
  }

  @override
  Stream<StepEditionState> mapEventToState(StepEditionEvent event) async* {
    if (event is _StepNameChanged) {
      yield state.copyWith(name: StepNameInput.dirty(event.name));
    } else if (event is _StepDescriptionChanged) {
      yield state.copyWith(description: StepDescriptionInput.dirty(event.description));
    } else if (event is _CreateStepFormSubmitted) {
      yield* _onCreateStepSubmitted(state, event);
    } else if (event is _UpdateStepFormSubmitted) {
      yield* _onUpdateStepSubmitted(state);
    }
  }

  Stream<StepEditionState> _onCreateStepSubmitted(StepEditionState state, _CreateStepFormSubmitted event) async* {
    if (state.status.isValidated) {
      yield state.loading();
      try {
        final Step? step = await _stepRepository.createStep(
            event.chapterId,
            StepCreationRequest(
              name: state.name.value,
              description: state.description.value,
            ));

        yield state.copyWith(step: step, formStatus: FormzStatus.submissionSuccess);
      } catch (e) {
        yield state.errored(
          DisplayableException(
            "Échec de la création du l'étape",
            errorMessage: 'Step creation failed',
            error: e is Exception ? e : null,
          ),
        );
      }
    }
  }

  Stream<StepEditionState> _onUpdateStepSubmitted(StepEditionState state) async* {
    if (state.status.isValidated) {
      yield state.loading();
      try {
        final Step? step = await _stepRepository.updateStep(
            state.step!.id,
            StepUpdateRequest(
              name: state.name.value,
              description: state.description.value,
            ));

        yield state.copyWith(step: step, formStatus: FormzStatus.submissionSuccess);
      } catch (e) {
        yield state.errored(
          DisplayableException(
            "Échec de la sauvegarde de l'étape",
            errorMessage: 'Step update failed',
            error: e is Exception ? e : null,
          ),
        );
      }
    }
  }
}

// Events
abstract class StepEditionEvent {}

abstract class StepEditionEvents {
  static _StepNameChanged nameChanged(String name) => _StepNameChanged(name);

  static _StepDescriptionChanged descriptionChanged(String description) => _StepDescriptionChanged(description);

  static _CreateStepFormSubmitted create(int chapterId) => _CreateStepFormSubmitted(chapterId);

  static _UpdateStepFormSubmitted update() => _UpdateStepFormSubmitted();
}

class _StepNameChanged extends StepEditionEvent {
  final String name;

  _StepNameChanged(this.name);
}

class _StepDescriptionChanged extends StepEditionEvent {
  final String description;

  _StepDescriptionChanged(this.description);
}

class _CreateStepFormSubmitted extends StepEditionEvent {
  final int chapterId;

  _CreateStepFormSubmitted(this.chapterId);
}

class _UpdateStepFormSubmitted extends StepEditionEvent {}

// State
class StepEditionState extends EditionBlocState {
  final Step? step;
  final StepNameInput name;
  final StepDescriptionInput description;

  const StepEditionState._({
    FormzStatus formStatus = FormzStatus.pure,
    Exception? error,
    this.step,
    this.name = const StepNameInput.pure(),
    this.description = const StepDescriptionInput.pure(),
  }) : super(formStatus: formStatus, error: error);

  factory StepEditionState.pure() => StepEditionState._();

  factory StepEditionState.fromStep(Step step) => StepEditionState._(
        step: step,
        name: StepNameInput.pure(stepName: step.name),
        description: StepDescriptionInput.pure(stepDescription: step.description),
      );

  @override
  StepEditionState copyWith({
    bool? isLoading,
    Exception? error,
    FormzStatus? formStatus,
    Step? step,
    StepNameInput? name,
    StepDescriptionInput? description,
  }) =>
      StepEditionState._(
        error: error,
        formStatus: formStatus ?? this.formStatus,
        step: step ?? this.step,
        name: name ?? this.name,
        description: description ?? this.description,
      );

  @override
  List<FormzInput> get inputs => [name, description];
}
