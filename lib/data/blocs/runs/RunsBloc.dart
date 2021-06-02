import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/models/BlocState.dart';
import 'package:gobz_app/data/models/Run.dart';
import 'package:gobz_app/data/repositories/RunRepository.dart';

class RunsBloc extends Bloc<RunsEvent, RunsState> {
  final RunRepository runRepository;

  RunsBloc(this.runRepository, {bool fetchOnStart = false}) : super(RunsState()) {
    if (fetchOnStart) {
      add(_FetchRuns());
    }
  }

  @override
  Stream<RunsState> mapEventToState(RunsEvent event) async* {
    if (event is _FetchRuns) {
      yield* _onFetchRuns(state);
    }
  }

  Stream<RunsState> _onFetchRuns(RunsState state) async* {
    yield state.loading();
    try {
      final List<Run> runs = await runRepository.getRuns();
      yield state.copyWith(runs: runs);
    } catch (e) {
      yield state.errored(
        DisplayableException(
          "La récupération des runs a échoué",
          errorMessage: "Failed to retrieve runs",
          error: e is Exception ? e : null,
        ),
      );
    }
  }
}

// Events
abstract class RunsEvent {}

abstract class RunsEvents {
  static _FetchRuns fetch() => _FetchRuns();
}

class _FetchRuns extends RunsEvent {}

// States
class RunsState extends BlocState {
  final List<Run> runs;

  RunsState({
    bool? isLoading,
    Exception? error,
    this.runs = const [],
  }) : super(isLoading: isLoading, error: error);

  @override
  RunsState copyWith({
    bool? isLoading,
    Exception? error,
    List<Run>? runs,
  }) =>
      RunsState(
        isLoading: isLoading ?? false,
        error: error,
        runs: runs ?? this.runs,
      );
}
