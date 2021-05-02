abstract class BlocState {
  final bool _loading;
  final Exception? error;

  const BlocState({required bool? isLoading, required this.error}) : _loading = isLoading ?? false;

  bool get isErrored => error != null;

  bool get isLoading => _loading;

  BlocState copyWith({bool? isLoading, Exception? error});
}
