import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/generic/states/EditionBlocState.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/formInputs/chapters/ChapterDescriptionInput.dart';
import 'package:gobz_app/data/formInputs/chapters/ChapterNameInput.dart';
import 'package:gobz_app/data/models/Chapter.dart';
import 'package:gobz_app/data/models/requests/ChapterCreationRequest.dart';
import 'package:gobz_app/data/models/requests/ChapterUpdateRequest.dart';
import 'package:gobz_app/data/repositories/ChapterRepository.dart';

class ChapterEditionBloc extends Bloc<ChapterEditionEvent, ChapterEditionState> {
  final ChapterRepository _chapterRepository;

  ChapterEditionBloc._(this._chapterRepository, ChapterEditionState state) : super(state);

  factory ChapterEditionBloc.creation(ChapterRepository chapterRepository) {
    return ChapterEditionBloc._(chapterRepository, ChapterEditionState.pure());
  }

  factory ChapterEditionBloc.edition(ChapterRepository chapterRepository, Chapter chapter) {
    return ChapterEditionBloc._(chapterRepository, ChapterEditionState.fromChapter(chapter));
  }

  @override
  Stream<ChapterEditionState> mapEventToState(ChapterEditionEvent event) async* {
    if (event is _ChapterNameChanged) {
      yield state.copyWith(name: ChapterNameInput.dirty(event.name));
    } else if (event is _ChapterDescriptionChanged) {
      yield state.copyWith(description: ChapterDescriptionInput.dirty(event.description));
    } else if (event is _CreateChapterFormSubmitted) {
      yield* _onCreateChapterSubmitted(state, event);
    } else if (event is _UpdateChapterFormSubmitted) {
      yield* _onUpdateChapterSubmitted(state);
    }
  }

  Stream<ChapterEditionState> _onCreateChapterSubmitted(
      ChapterEditionState state, _CreateChapterFormSubmitted event) async* {
    if (state.status.isValidated) {
      yield state.loading();
      try {
        final Chapter? chapter = await _chapterRepository.createChapter(
            event.projectId,
            ChapterCreationRequest(
              name: state.name.value,
              description: state.description.value,
            ));
        yield state.copyWith(formStatus: FormzStatus.submissionSuccess, chapter: chapter);
      } catch (e) {
        yield state.errored(
          DisplayableException(
            "Échec de la création du chapitre",
            errorMessage: 'Chapter creation failed',
            error: e is Exception ? e : null,
          ),
        );
      }
    }
  }

  Stream<ChapterEditionState> _onUpdateChapterSubmitted(ChapterEditionState state) async* {
    if (state.status.isValidated) {
      yield state.formSubmitting();
      try {
        final Chapter? chapter = await _chapterRepository.updateChapter(
            state.chapter!.id,
            ChapterUpdateRequest(
              name: state.name.value,
              description: state.description.value,
            ));
        yield state.copyWith(formStatus: FormzStatus.submissionSuccess, chapter: chapter);
      } catch (e) {
        yield state.formSubmissionFailed(
          DisplayableException(
            "Échec de la sauvegarde du chapitre",
            errorMessage: 'Chapter update failed',
            error: e is Exception ? e : null,
          ),
        );
      }
    }
  }
}

// Events
abstract class ChapterEditionEvent {}

abstract class ChapterEditionEvents {
  static _ChapterNameChanged nameChanged(String name) => _ChapterNameChanged(name);

  static _ChapterDescriptionChanged descriptionChanged(String description) => _ChapterDescriptionChanged(description);

  static _CreateChapterFormSubmitted create(int projectId) => _CreateChapterFormSubmitted(projectId);

  static _UpdateChapterFormSubmitted update() => _UpdateChapterFormSubmitted();
}

class _ChapterNameChanged extends ChapterEditionEvent {
  final String name;

  _ChapterNameChanged(this.name);
}

class _ChapterDescriptionChanged extends ChapterEditionEvent {
  final String description;

  _ChapterDescriptionChanged(this.description);
}

class _CreateChapterFormSubmitted extends ChapterEditionEvent {
  final int projectId;

  _CreateChapterFormSubmitted(this.projectId);
}

class _UpdateChapterFormSubmitted extends ChapterEditionEvent {}

// State
class ChapterEditionState extends EditionBlocState {
  final Chapter? chapter;
  final ChapterNameInput name;
  final ChapterDescriptionInput description;

  const ChapterEditionState._({
    FormzStatus formStatus = FormzStatus.pure,
    Exception? error,
    this.chapter,
    this.name = const ChapterNameInput.pure(),
    this.description = const ChapterDescriptionInput.pure(),
  }) : super(formStatus: formStatus, error: error);

  factory ChapterEditionState.pure() => ChapterEditionState._();

  factory ChapterEditionState.fromChapter(Chapter chapter) => ChapterEditionState._(
        chapter: chapter,
        name: ChapterNameInput.pure(chapterName: chapter.name),
        description: ChapterDescriptionInput.pure(chapterDescription: chapter.description),
      );

  @override
  ChapterEditionState copyWith({
    bool? isLoading,
    Exception? error,
    FormzStatus? formStatus,
    Chapter? chapter,
    ChapterNameInput? name,
    ChapterDescriptionInput? description,
  }) =>
      ChapterEditionState._(
        error: error,
        formStatus: formStatus ?? this.formStatus,
        chapter: chapter ?? this.chapter,
        name: name ?? this.name,
        description: description ?? this.description,
      );

  @override
  List<FormzInput> get inputs => [name, description];
}
