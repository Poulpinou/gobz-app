import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/repositories/ChapterRepository.dart';

class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {
  final ChapterRepository _chapterRepository;

  ChapterBloc(this._chapterRepository, Chapter chapter, {bool fetchOnStart = false})
      : super(ChapterState(chapter: chapter)) {
    if (fetchOnStart) {
      add(_FetchChapter());
    }
  }

  @override
  Stream<ChapterState> mapEventToState(ChapterEvent event) async* {
    if (event is _FetchChapter) {
      yield* _fetchChapter();
    } else if (event is _DeleteChapter) {
      yield* _deleteChapter();
    }
  }

  Stream<ChapterState> _fetchChapter() async* {
    yield state.loading();
    try {
      final Chapter chapter = await _chapterRepository.getChapter(state.chapter.id);
      yield state.copyWith(chapter: chapter);
    } catch (e) {
      yield state.errored(
        DisplayableException(
          "La récupération du chapitre a échoué",
          errorMessage: "Failed to retrieve chapter",
          error: e is Exception ? e : null,
        ),
      );
    }
  }

  Stream<ChapterState> _deleteChapter() async* {
    yield state.loading();
    try {
      await _chapterRepository.deleteChapter(state.chapter.id);
      yield state.copyWith(chapterDeleted: true);
    } catch (e) {
      yield state.errored(
        DisplayableException(
          "La suppression du chapitre a échoué",
          errorMessage: "Failed to delete chapter",
          error: e is Exception ? e : null,
        ),
      );
    }
  }
}

// Events
abstract class ChapterEvent {}

abstract class ChapterEvents {
  static _FetchChapter fetch() => _FetchChapter();

  static _DeleteChapter delete() => _DeleteChapter();
}

class _FetchChapter extends ChapterEvent {}

class _DeleteChapter extends ChapterEvent {}

// State
class ChapterState extends BlocState {
  final Chapter chapter;
  final bool chapterDeleted;

  ChapterState({
    bool? isLoading,
    Exception? error,
    required this.chapter,
    this.chapterDeleted = false,
  }) : super(isLoading: isLoading, error: error);

  @override
  ChapterState copyWith({
    bool? isLoading,
    Exception? error,
    Chapter? chapter,
    bool? chapterDeleted,
  }) =>
      ChapterState(
          isLoading: isLoading ?? false,
          error: error,
          chapter: chapter ?? this.chapter,
          chapterDeleted: chapterDeleted ?? this.chapterDeleted);
}
