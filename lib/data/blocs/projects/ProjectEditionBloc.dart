import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/generic/states/EditionBlocState.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/formInputs/projects/ProjectDescriptionInput.dart';
import 'package:gobz_app/data/formInputs/projects/ProjectNameInput.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/models/requests/ProjectCreationRequest.dart';
import 'package:gobz_app/data/models/requests/ProjectUpdateRequest.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';

class ProjectEditionBloc extends Bloc<ProjectEditionEvent, ProjectEditionState> {
  final ProjectRepository _projectRepository;

  ProjectEditionBloc._(this._projectRepository, ProjectEditionState state) : super(state);

  factory ProjectEditionBloc.creation(ProjectRepository projectRepository) {
    return ProjectEditionBloc._(projectRepository, ProjectEditionState.pure());
  }

  factory ProjectEditionBloc.edition(ProjectRepository projectRepository, Project project) {
    return ProjectEditionBloc._(projectRepository, ProjectEditionState.fromProject(project));
  }

  @override
  Stream<ProjectEditionState> mapEventToState(ProjectEditionEvent event) async* {
    if (event is _ProjectNameChanged) {
      yield state.copyWith(name: ProjectNameInput.dirty(event.name));
    } else if (event is _ProjectDescriptionChanged) {
      yield state.copyWith(description: ProjectDescriptionInput.dirty(event.description));
    } else if (event is _ProjectIsSharedChanged) {
      yield state.copyWith(isShared: event.isShared);
    } else if (event is _CreateProjectFormSubmitted) {
      yield* _onCreateProjectFormSubmitted(state);
    } else if (event is _UpdateProjectFormSubmitted) {
      yield* _onUpdateProjectFormSubmitted(state);
    }
  }

  Stream<ProjectEditionState> _onCreateProjectFormSubmitted(ProjectEditionState state) async* {
    if (state.status.isValidated) {
      yield state.loading();
      try {
        final Project project = (await _projectRepository
            .createProject(ProjectCreationRequest(state.name.value, state.description.value, state.isShared)));

        yield state.copyWith(project: project, formStatus: FormzStatus.submissionSuccess);
      } catch (e) {
        yield state.errored(
          DisplayableException(
            "Échec de la création du projet",
            errorMessage: 'Project creation failed',
            error: e is Exception ? e : null,
          ),
        );
      }
    }
  }

  Stream<ProjectEditionState> _onUpdateProjectFormSubmitted(ProjectEditionState state) async* {
    if (state.status.isValidated) {
      yield state.loading();
      try {
        final Project project = (await _projectRepository.updateProject(
            state.project!.id, ProjectUpdateRequest(state.name.value, state.description.value, state.isShared)));

        yield state.copyWith(project: project, formStatus: FormzStatus.submissionSuccess);
      } catch (e) {
        yield state.errored(
          DisplayableException(
            "Échec de la sauvegarde du projet",
            errorMessage: 'Project update failure',
            error: e is Exception ? e : null,
          ),
        );
      }
    }
  }
}

// Events
abstract class ProjectEditionEvent {}

abstract class ProjectEditionEvents {
  static _ProjectNameChanged nameChanged(String name) => _ProjectNameChanged(name);

  static _ProjectDescriptionChanged descriptionChanged(String description) => _ProjectDescriptionChanged(description);

  static _ProjectIsSharedChanged isSharedChanged(bool isShared) => _ProjectIsSharedChanged(isShared);

  static _CreateProjectFormSubmitted create() => _CreateProjectFormSubmitted();

  static _UpdateProjectFormSubmitted update() => _UpdateProjectFormSubmitted();
}

class _ProjectNameChanged extends ProjectEditionEvent {
  final String name;

  _ProjectNameChanged(this.name);
}

class _ProjectDescriptionChanged extends ProjectEditionEvent {
  final String description;

  _ProjectDescriptionChanged(this.description);
}

class _ProjectIsSharedChanged extends ProjectEditionEvent {
  final bool isShared;

  _ProjectIsSharedChanged(this.isShared);
}

class _CreateProjectFormSubmitted extends ProjectEditionEvent {}

class _UpdateProjectFormSubmitted extends ProjectEditionEvent {}

// State
class ProjectEditionState extends EditionBlocState {
  final Project? project;
  final ProjectNameInput name;
  final ProjectDescriptionInput description;
  final bool isShared;

  const ProjectEditionState._({
    FormzStatus formStatus = FormzStatus.pure,
    Exception? error,
    this.project,
    this.name = const ProjectNameInput.pure(),
    this.description = const ProjectDescriptionInput.pure(),
    this.isShared = true,
  }) : super(formStatus: formStatus, error: error);

  factory ProjectEditionState.pure() => ProjectEditionState._();

  factory ProjectEditionState.fromProject(Project project) => ProjectEditionState._(
        project: project,
        name: ProjectNameInput.pure(projectName: project.name),
        description: ProjectDescriptionInput.pure(projectDescription: project.description),
        isShared: project.isShared,
      );

  @override
  List<FormzInput> get inputs => [name, description];

  ProjectEditionState copyWith(
          {bool? isLoading,
          Exception? error,
          Project? project,
          FormzStatus? formStatus,
          ProjectNameInput? name,
          ProjectDescriptionInput? description,
          bool? isShared}) =>
      ProjectEditionState._(
        error: error,
        formStatus: formStatus ?? this.formStatus,
        project: project ?? this.project,
        name: name ?? this.name,
        description: description ?? this.description,
        isShared: isShared ?? this.isShared,
      );
}
