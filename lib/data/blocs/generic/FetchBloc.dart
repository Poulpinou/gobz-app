import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/generic/states/FetchBlocState.dart';

class FetchBloc<T> extends Bloc<FetchEvent, FetchBlocState<T>> {
  final Future<T> fetchFunction;
  final Future<void>? deleteFunction;

  FetchBloc({
    required this.fetchFunction,
    required this.deleteFunction,
    FetchBlocState<T>? defaultState,
    bool fetchOnStart = false,
  }) : super(defaultState ?? FetchState<T>()) {
    if (fetchOnStart) {
      add(FetchDataEvent());
    }
  }

  @override
  Stream<FetchBlocState<T>> mapEventToState(FetchEvent event) async* {
    if (event is FetchDataEvent) {
      yield* _fetchData();
    } else if (event is FetchDataEvent) {
      yield* _deleteData();
    }
  }

  Stream<FetchBlocState<T>> _fetchData() async* {
    yield state.loading();
    try {
      yield state.fetched(await fetchFunction);
    } on Exception catch (e) {
      yield state.errored(e);
    }
  }

  Stream<FetchBlocState<T>> _deleteData() async* {
    if (deleteFunction == null) return;

    yield state.loading();
    try {
      await deleteFunction;
      yield state.deleted();
    } on Exception catch (e) {
      yield state.errored(e);
    }
  }
}

// Events
abstract class FetchEvent {}

abstract class FetchEvents {
  static FetchDataEvent fetch() => FetchDataEvent();

  static DeleteDataEvent delete() => DeleteDataEvent();
}

class FetchDataEvent extends FetchEvent {}

class DeleteDataEvent extends FetchEvent {}

// State
class FetchState<T> extends FetchBlocState<T> {
  FetchState({
    bool? isLoading,
    Exception? error,
    FetchStatus fetchStatus = FetchStatus.UNFECTHED,
    T? data,
  }) : super(
          isLoading: isLoading,
          error: error,
          fetchStatus: fetchStatus,
          data: data,
        );

  @override
  FetchBlocState copyWith({
    bool? isLoading,
    Exception? error,
    FetchStatus? fetchStatus,
    T? data,
  }) =>
      FetchState(
        isLoading: isLoading ?? false,
        error: error,
        fetchStatus: fetchStatus ?? this.fetchStatus,
        data: data ?? this.data,
      );
}
