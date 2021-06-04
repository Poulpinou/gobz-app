import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Step.dart';
import 'package:gobz_app/models/requests/StepCreationRequest.dart';
import 'package:gobz_app/models/requests/StepUpdateRequest.dart';
import 'package:gobz_app/repositories/StepRepository.dart';
import 'package:gobz_app/widgets/forms/steps/inputs/StepDescriptionInput.dart';
import 'package:gobz_app/widgets/forms/steps/inputs/StepNameInput.dart';

class StepEditionBloc extends Bloc<StepEditionEvent, StepEditionState> {
  final int? _chapterId;
  final StepRepository _stepRepository;

  StepEditionBloc(this._stepRepository, {int? chapterId, Step? step})
      : _chapterId = chapterId,
        super(step != null ? StepEditionState.fromStep(step) : StepEditionState.pure());

  @override
  Stream<StepEditionState> mapEventToState(StepEditionEvent event) async* {
    if (event is _StepNameChanged) {
      yield state.copyWith(name: StepNameInput.dirty(event.name));
    } else if (event is _StepDescriptionChanged) {
      yield state.copyWith(description: StepDescriptionInput.dirty(event.description));
    } else if (event is _CreateStepFormSubmitted) {
      yield* _onCreateStepSubmitted(state);
    } else if (event is _UpdateStepFormSubmitted) {
      yield* _onUpdateStepSubmitted(state);
    }
  }

  Stream<StepEditionState> _onCreateStepSubmitted(StepEditionState state) async* {
    if (state.status.isValidated) {
      yield state.loading();
      try {
        final Step? step = await _stepRepository.createStep(
            _chapterId!,
            StepCreationRequest(
              name: state.name.value,
              description: state.description.value,
            ));

        yield state.copyWith(step: step);
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

        yield state.copyWith(step: step);
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

  static _CreateStepFormSubmitted createFormSubmitted() => _CreateStepFormSubmitted();

  static _UpdateStepFormSubmitted updateFormSubmitted() => _UpdateStepFormSubmitted();
}

class _StepNameChanged extends StepEditionEvent {
  final String name;

  _StepNameChanged(this.name);
}

class _StepDescriptionChanged extends StepEditionEvent {
  final String description;

  _StepDescriptionChanged(this.description);
}

class _CreateStepFormSubmitted extends StepEditionEvent {}

class _UpdateStepFormSubmitted extends StepEditionEvent {}

// State
class StepEditionState extends BlocState with FormzMixin {
  final Step? step;
  final bool hasBeenUpdated;
  final StepNameInput name;
  final StepDescriptionInput description;

  const StepEditionState._({
    bool? isLoading,
    Exception? error,
    this.hasBeenUpdated = false,
    this.step,
    this.name = const StepNameInput.pure(),
    this.description = const StepDescriptionInput.pure(),
  }) : super(isLoading: isLoading, error: error);

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
    Step? step,
    StepNameInput? name,
    StepDescriptionInput? description,
  }) =>
      StepEditionState._(
        isLoading: isLoading ?? false,
        error: error,
        step: step ?? this.step,
        hasBeenUpdated: step != null,
        name: name ?? this.name,
        description: description ?? this.description,
      );

  @override
  List<FormzInput> get inputs => [name, description];
}
