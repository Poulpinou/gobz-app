import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/repositories/ChapterRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class ChaptersBloc extends Bloc<ChaptersEvent, ChaptersState> {
  final Project project;
  final ChapterRepository chapterRepository;

  ChaptersBloc({required this.project, required this.chapterRepository}):
        super(ChaptersState());

  @override
  Stream<ChaptersState> mapEventToState(ChaptersEvent event) async* {
    if (event is _FetchChapters) {
      yield* _onFetchChapters(event, state);
    }
  }

  Stream<ChaptersState> _onFetchChapters(_FetchChapters event, ChaptersState state) async* {
    yield state.copyWith(isLoading: true);
    try {
      final List<Chapter> chapters = await chapterRepository.getChapters(project.id);
      yield state.copyWith(chapters: chapters);
    }catch(e){
      Log.error("Failed to retrieve chapters", e);
      yield state.copyWith(error: DisplayableException(internMessage: e.toString(), messageToDisplay: "La récupération des chapitres a échoué"));
    }
  }
}

// Events
abstract class ChaptersEvent {
}

class ChaptersEvents {
  static _FetchChapters fetch() => _FetchChapters();
}

class _FetchChapters extends ChaptersEvent {
}

// States
class ChaptersState extends BlocState {
  final List<Chapter> chapters;

  ChaptersState({
    bool? isLoading,
    Exception? error,
    this.chapters = const [],
  }) : super(isLoading: isLoading, error: error);

  @override
  ChaptersState copyWith({bool? isLoading, Exception? error, List<Chapter>? chapters}) =>
      ChaptersState(
        isLoading: isLoading ?? false,
        error: error,
        chapters: chapters ?? this.chapters,
      );
}
