import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/models/BlocState.dart';
import 'package:gobz_app/data/models/Step.dart';
import 'package:gobz_app/data/repositories/StepRepository.dart';

class StepBloc extends Bloc<StepEvent, StepState> {
  final StepRepository _stepRepository;

  StepBloc(this._stepRepository, Step step) : super(StepState(step: step));

  @override
  Stream<StepState> mapEventToState(StepEvent event) async* {
    if (event is _FetchStep) {
      yield* _fetchStep();
    }
  }

  Stream<StepState> _fetchStep() async* {
    yield state.loading();
    try {
      final Step step = await _stepRepository.getStep(state.step.id);
      yield state.copyWith(step: step);
    } catch (e) {
      yield state.errored(
        DisplayableException(
          "La récupération de l'étape a échoué",
          errorMessage: "Failed to retrieve step",
          error: e is Exception ? e : null,
        ),
      );
    }
  }
}

// Events
abstract class StepEvent {}

abstract class StepEvents {
  static _FetchStep fetch() => _FetchStep();
}

class _FetchStep extends StepEvent {}

// State
class StepState extends BlocState {
  final Step step;
  final bool stepDeleted;

  const StepState({
    bool? isLoading,
    Exception? error,
    required this.step,
    this.stepDeleted = false,
  }) : super(isLoading: isLoading, error: error);

  StepState copyWith({
    bool? isLoading,
    Exception? error,
    Step? step,
    bool? stepDeleted,
  }) =>
      StepState(
        step: step ?? this.step,
        isLoading: isLoading ?? false,
        error: error,
        stepDeleted: stepDeleted ?? this.stepDeleted,
      );
}
