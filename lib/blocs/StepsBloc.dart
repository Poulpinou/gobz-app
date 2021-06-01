import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/models/Step.dart';
import 'package:gobz_app/repositories/StepRepository.dart';

class StepsBloc extends Bloc<StepsEvent, StepsState> {
  final Chapter chapter;
  final StepRepository stepRepository;

  StepsBloc({required this.chapter, required this.stepRepository, bool fetchOnStart = false}) : super(StepsState()) {
    if (fetchOnStart) {
      add(_FetchSteps());
    }
  }

  @override
  Stream<StepsState> mapEventToState(StepsEvent event) async* {
    if (event is _FetchSteps) {
      yield* _onFetchSteps(state);
    } else if (event is _DeleteStep) {
      yield* _onDeleteStep(event, state);
    }
  }

  Stream<StepsState> _onFetchSteps(StepsState state) async* {
    yield state.loading();
    try {
      final List<Step> steps = await stepRepository.getSteps(chapter.id);
      yield state.copyWith(steps: steps);
    } catch (e) {
      yield state.errored(
        DisplayableException(
          "La récupération des étapes a échoué",
          errorMessage: "Failed to retrieve steps",
          error: e is Exception ? e : null,
        ),
      );
    }
  }

  Stream<StepsState> _onDeleteStep(_DeleteStep event, StepsState state) async* {
    yield state.loading();
    try {
      await stepRepository.deleteStep(event.step.id);
      yield state.copyWith(deletedStep: event.step);
    } catch (e) {
      yield state.errored(
        DisplayableException(
          "La suppression de ${event.step.name} a échoué",
          errorMessage: "Failed to delete step",
          error: e is Exception ? e : null,
        ),
      );
    }

    add(StepsEvents.fetch());
  }
}

// Events
abstract class StepsEvent {}

abstract class StepsEvents {
  static _FetchSteps fetch() => _FetchSteps();

  static _DeleteStep deleteStep(Step step) => _DeleteStep(step);
}

class _FetchSteps extends StepsEvent {}

class _DeleteStep extends StepsEvent {
  final Step step;

  _DeleteStep(this.step);
}

// States
class StepsState extends BlocState {
  final List<Step> steps;
  final Step? deletedStep;

  StepsState({
    bool? isLoading,
    Exception? error,
    this.steps = const [],
    this.deletedStep,
  }) : super(isLoading: isLoading, error: error);

  @override
  StepsState copyWith({
    bool? isLoading,
    Exception? error,
    List<Step>? steps,
    Step? deletedStep,
  }) =>
      StepsState(
        isLoading: isLoading ?? false,
        error: error,
        steps: steps ?? this.steps,
        deletedStep: deletedStep,
      );
}
