import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/models/Step.dart';
import 'package:gobz_app/repositories/StepRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class StepsBloc extends Bloc<StepsEvent, StepsState> {
  final Chapter chapter;
  final StepRepository stepRepository;

  StepsBloc({required this.chapter, required this.stepRepository}) : super(StepsState());

  @override
  Stream<StepsState> mapEventToState(StepsEvent event) async* {
    if (event is _FetchSteps) {
      yield* _onFetchSteps(event, state);
    }
  }

  Stream<StepsState> _onFetchSteps(_FetchSteps event, StepsState state) async* {
    yield state.copyWith(isLoading: true);
    try {
      final List<Step> steps = await stepRepository.getSteps(chapter.id);
      yield state.copyWith(steps: steps);
    } catch (e) {
      Log.error("Failed to retrieve steps", e);
      yield state.copyWith(
          error: DisplayableException(
              internMessage: e.toString(), messageToDisplay: "La récupération des étapes a échoué"));
    }
  }
}

// Events
abstract class StepsEvent {}

abstract class StepsEvents {
  static _FetchSteps fetch() => _FetchSteps();
}

class _FetchSteps extends StepsEvent {}

// States
class StepsState extends BlocState {
  final List<Step> steps;

  StepsState({
    bool? isLoading,
    Exception? error,
    this.steps = const [],
  }) : super(isLoading: isLoading, error: error);

  @override
  StepsState copyWith({bool? isLoading, Exception? error, List<Step>? steps}) => StepsState(
        isLoading: isLoading ?? false,
        error: error,
        steps: steps ?? this.steps,
      );
}
