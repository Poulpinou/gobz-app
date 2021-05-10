import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Step.dart';
import 'package:gobz_app/repositories/StepRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

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
    yield state.copyWith(isLoading: true);
    try {
      final Step step = await _stepRepository.getStep(state.step.id);
      yield state.copyWith(step: step);
    } catch (e) {
      Log.error("Failed to retrieve step", e);
      yield state.copyWith(
          error: DisplayableException(
              internMessage: e.toString(), messageToDisplay: "La récupération de l'étape a échoué"));
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
