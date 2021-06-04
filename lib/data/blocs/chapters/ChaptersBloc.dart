import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/BlocState.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/models/Chapter.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/repositories/ChapterRepository.dart';

class ChaptersBloc extends Bloc<ChaptersEvent, ChaptersState> {
  final Project project;
  final ChapterRepository chapterRepository;

  ChaptersBloc({required this.project, required this.chapterRepository, bool fetchOnStart = false})
      : super(ChaptersState()) {
    if (fetchOnStart) {
      add(_FetchChapters());
    }
  }

  @override
  Stream<ChaptersState> mapEventToState(ChaptersEvent event) async* {
    if (event is _FetchChapters) {
      yield* _onFetchChapters(event, state);
    }
  }

  Stream<ChaptersState> _onFetchChapters(_FetchChapters event, ChaptersState state) async* {
    yield state.loading();
    try {
      final List<Chapter> chapters = await chapterRepository.getChapters(project.id);
      yield state.copyWith(chapters: chapters);
    } catch (e) {
      yield state.errored(
        DisplayableException(
          "La récupération des chapitres a échoué",
          errorMessage: "Failed to retrieve chapters",
          error: e is Exception ? e : null,
        ),
      );
    }
  }
}

// Events
abstract class ChaptersEvent {}

abstract class ChaptersEvents {
  static _FetchChapters fetch() => _FetchChapters();
}

class _FetchChapters extends ChaptersEvent {}

// States
class ChaptersState extends BlocState {
  final List<Chapter> chapters;

  ChaptersState({
    bool? isLoading,
    Exception? error,
    this.chapters = const [],
  }) : super(isLoading: isLoading, error: error);

  @override
  ChaptersState copyWith({bool? isLoading, Exception? error, List<Chapter>? chapters}) => ChaptersState(
        isLoading: isLoading ?? false,
        error: error,
        chapters: chapters ?? this.chapters,
      );
}
