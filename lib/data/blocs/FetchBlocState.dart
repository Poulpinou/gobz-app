import 'package:gobz_app/data/blocs/BlocState.dart';

enum FetchStatus { UNFECTHED, FETCHED, DELETED }

abstract class FetchBlocState<T> extends BlocState {
  final FetchStatus fetchStatus;
  final T? data;

  const FetchBlocState({
    required this.fetchStatus,
    required this.data,
    required Exception? error,
    required bool? isLoading,
  }) : super(isLoading: isLoading, error: error);

  bool get hasBeenFetched => fetchStatus != FetchStatus.UNFECTHED && hasData;

  bool get hasBeenDeleted => fetchStatus == FetchStatus.DELETED;

  bool get hasData => data != null;

  @override
  FetchBlocState copyWith({bool? isLoading, Exception? error, FetchStatus? fetchStatus, T? data});

  @override
  S errored<S extends BlocState>(Exception error) => copyWith(error: error, fetchStatus: FetchStatus.UNFECTHED) as S;

  S deleted<S extends FetchBlocState>() => copyWith(fetchStatus: FetchStatus.DELETED) as S;

  S fetched<S extends FetchBlocState>(T data) => copyWith(fetchStatus: FetchStatus.FETCHED, data: data) as S;
}
