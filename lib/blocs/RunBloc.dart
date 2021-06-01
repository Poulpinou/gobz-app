import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Run.dart';
import 'package:gobz_app/repositories/RunRepository.dart';

class RunBloc extends Bloc<RunEvent, RunState> {
  final RunRepository _runRepository;

  RunBloc(this._runRepository, Run initialData) : super(RunState(run: initialData));

  @override
  Stream<RunState> mapEventToState(RunEvent event) async* {
    if (event is _FetchRun) {
      yield* _fetchRun();
    }
  }

  Stream<RunState> _fetchRun() async* {
    yield state.loading();
    try {
      final Run run = await _runRepository.getRun(state.run.id);
      yield state.copyWith(run: run);
    } catch (e) {
      yield state.errored(
        DisplayableException(
          "La récupération du run a échoué",
          errorMessage: "Failed to retrieve run",
          error: e is Exception ? e : null,
        ),
      );
    }
  }
}

// Events
abstract class RunEvent {}

abstract class RunEvents {
  static _FetchRun fetch() => _FetchRun();
}

class _FetchRun extends RunEvent {}

// State
class RunState extends BlocState {
  final Run run;

  RunState({
    bool? isLoading,
    Exception? error,
    required this.run,
  }) : super(isLoading: isLoading, error: error);

  @override
  RunState copyWith({
    bool? isLoading,
    Exception? error,
    Run? run,
  }) =>
      RunState(
        isLoading: isLoading ?? false,
        error: error,
        run: run ?? this.run,
      );
}
