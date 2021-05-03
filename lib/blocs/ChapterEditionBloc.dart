import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/models/requests/ChapterCreationRequest.dart';
import 'package:gobz_app/repositories/ChapterRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';
import 'package:gobz_app/widgets/forms/chapters/inputs/ChapterDescriptionInput.dart';
import 'package:gobz_app/widgets/forms/chapters/inputs/ChapterNameInput.dart';

class ChapterEditionBloc extends Bloc<ChapterEditionEvent, ChapterEditionState> {
  final int _projectId;
  final ChapterRepository _chapterRepository;

  ChapterEditionBloc(this._chapterRepository, this._projectId) : super(ChapterEditionState.pure());

  @override
  Stream<ChapterEditionState> mapEventToState(ChapterEditionEvent event) async* {
    if (event is _ChapterNameChanged) {
      yield state.copyWith(name: ChapterNameInput.dirty(event.name));
    } else if (event is _ChapterDescriptionChanged) {
      yield state.copyWith(description: ChapterDescriptionInput.dirty(event.description));
    } else if (event is _CreateChapterFormSubmitted) {
      yield* _onCreateChapterSubmitted(state);
    }
  }

  Stream<ChapterEditionState> _onCreateChapterSubmitted(ChapterEditionState state) async* {
    if (state.status.isValidated) {
      yield state.copyWith(isLoading: true);
      try {
        final Chapter? chapter = await _chapterRepository.createChapter(
            _projectId,
            ChapterCreationRequest(
              name: state.name.value,
              description: state.description.value,
            ));

        yield state.copyWith(chapter: chapter);
      } catch (e) {
        Log.error('Chapter creation failed', e);
        yield state.copyWith(
            error: DisplayableException(
          internMessage: e.toString(),
          messageToDisplay: "Echec de la création du chapitre",
        ));
      }
    }
  }
}

// Events
abstract class ChapterEditionEvent {}

abstract class ChapterEditionEvents {
  static _ChapterNameChanged nameChanged(String name) => _ChapterNameChanged(name);

  static _ChapterDescriptionChanged descriptionChanged(String description) => _ChapterDescriptionChanged(description);

  static _CreateChapterFormSubmitted create() => _CreateChapterFormSubmitted();
}

class _ChapterNameChanged extends ChapterEditionEvent {
  final String name;

  _ChapterNameChanged(this.name);
}

class _ChapterDescriptionChanged extends ChapterEditionEvent {
  final String description;

  _ChapterDescriptionChanged(this.description);
}

class _CreateChapterFormSubmitted extends ChapterEditionEvent {}

// State
class ChapterEditionState extends BlocState with FormzMixin {
  final Chapter? chapter;
  final ChapterNameInput name;
  final ChapterDescriptionInput description;

  const ChapterEditionState._({
    bool? isLoading,
    Exception? error,
    this.chapter,
    this.name = const ChapterNameInput.pure(),
    this.description = const ChapterDescriptionInput.pure(),
  }) : super(isLoading: isLoading, error: error);

  factory ChapterEditionState.pure() => ChapterEditionState._();

  @override
  ChapterEditionState copyWith({
    bool? isLoading,
    Exception? error,
    Chapter? chapter,
    ChapterNameInput? name,
    ChapterDescriptionInput? description,
  }) =>
      ChapterEditionState._(
        isLoading: isLoading ?? false,
        error: error,
        chapter: chapter ?? this.chapter,
        name: name ?? this.name,
        description: description ?? this.description,
      );

  @override
  List<FormzInput> get inputs => [name, description];
}