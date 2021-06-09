import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/models/Chapter.dart';
import 'package:gobz_app/data/repositories/ChapterRepository.dart';

import '../FetchBlocState.dart';

class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {
  final ChapterRepository chapterRepository;
  final int chapterId;

  ChapterBloc({required this.chapterRepository, required this.chapterId, bool fetchOnStart = false})
      : super(ChapterState()) {
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
      yield state.fetched(await chapterRepository.getChapter(chapterId));
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
      await chapterRepository.deleteChapter(chapterId);
      yield state.deleted();
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
class ChapterState extends FetchBlocState<Chapter> {
  const ChapterState({
    bool? isLoading,
    Exception? error,
    FetchStatus fetchStatus = FetchStatus.UNFECTHED,
    Chapter? chapter,
  }) : super(
          isLoading: isLoading,
          error: error,
          fetchStatus: fetchStatus,
          data: chapter,
        );

  Chapter? get chapter => data;

  ChapterState copyWith({
    bool? isLoading,
    Exception? error,
    FetchStatus? fetchStatus,
    Chapter? data,
    bool? chapterDeleted,
  }) =>
      ChapterState(
          chapter: data ?? this.data,
          isLoading: isLoading ?? false,
          error: error,
          fetchStatus: fetchStatus ?? this.fetchStatus);
}
