abstract class BlocState {
  final bool _loading;
  final Exception? error;

  const BlocState({required bool? isLoading, required this.error}) : _loading = isLoading ?? false;

  bool get isErrored => error != null;

  bool get isLoading => _loading;

  bool get isReady => isLoading && isErrored;

  BlocState copyWith({bool? isLoading, Exception? error});

  T loading<T extends BlocState>() => copyWith(isLoading: true) as T;

  T errored<T extends BlocState>(Exception error) => copyWith(error: error) as T;
}
