import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/repositories/ChapterRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {
  final ChapterRepository _chapterRepository;

  ChapterBloc(this._chapterRepository, Chapter chapter) : super(ChapterState(chapter: chapter));

  @override
  Stream<ChapterState> mapEventToState(ChapterEvent event) async* {
    if (event is _FetchChapter) {
      yield* _fetchChapter();
    } else if (event is _DeleteChapter) {
      yield* _deleteChapter();
    }
  }

  Stream<ChapterState> _fetchChapter() async* {
    yield state.copyWith(isLoading: true);
    try {
      final Chapter chapter = await _chapterRepository.getChapter(state.chapter.id);
      yield state.copyWith(chapter: chapter);
    } catch (e) {
      Log.error("Failed to retrieve chapter", e);
      yield state.copyWith(
          error: DisplayableException(
              internMessage: e.toString(), messageToDisplay: "La récupération du chapitre a échoué"));
    }
  }

  Stream<ChapterState> _deleteChapter() async* {
    yield state.copyWith(isLoading: true);
    try {
      await _chapterRepository.deleteChapter(state.chapter.id);
      yield state.copyWith(chapterDeleted: true);
    } catch (e) {
      Log.error("Failed to delete chapter", e);
      yield state.copyWith(
          error:
              DisplayableException(internMessage: e.toString(), messageToDisplay: "La suppression du projet a échoué"));
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
        chapterDeleted: chapterDeleted ?? this.chapterDeleted
      );
}
