import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/models/requests/ProjectCreationRequest.dart';
import 'package:gobz_app/models/requests/ProjectUpdateRequest.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';
import 'package:gobz_app/widgets/forms/projects/inputs/ProjectDescriptionInput.dart';
import 'package:gobz_app/widgets/forms/projects/inputs/ProjectNameInput.dart';

class ProjectEditionBloc extends Bloc<ProjectEditionEvent, ProjectEditionState> {
  final ProjectRepository _projectRepository;

  ProjectEditionBloc(this._projectRepository, {Project? project})
      : super(project != null ? ProjectEditionState.fromProject(project) : ProjectEditionState.pure());

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
      yield state.copyWith(isLoading: true);
      try {
        final Project project = (await _projectRepository
            .createProject(ProjectCreationRequest(state.name.value, state.description.value, state.isShared)));

        yield state.copyWith(project: project);
      } catch (e) {
        Log.error('Project creation failed', e);
        yield state.copyWith(
          error: DisplayableException(
            internMessage: e.toString(),
            messageToDisplay: "Échec de la création du projet",
          ),
        );
      }
    }
  }

  Stream<ProjectEditionState> _onUpdateProjectFormSubmitted(ProjectEditionState state) async* {
    if (state.status.isValidated) {
      yield state.copyWith(isLoading: true);
      try {
        final Project project = (await _projectRepository.updateProject(
            state.project!.id, ProjectUpdateRequest(state.name.value, state.description.value, state.isShared)));

        yield state.copyWith(project: project);
      } catch (e) {
        Log.error('Project update failure', e);
        yield state.copyWith(
          error: DisplayableException(
            internMessage: e.toString(),
            messageToDisplay: "Échec de la sauvegarde du projet",
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

  static _CreateProjectFormSubmitted creationFormSubmitted() => _CreateProjectFormSubmitted();

  static _UpdateProjectFormSubmitted updateFormSubmitted() => _UpdateProjectFormSubmitted();
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
class ProjectEditionState extends BlocState with FormzMixin {
  final Project? project;
  final bool hasBeenUpdated;
  final ProjectNameInput name;
  final ProjectDescriptionInput description;
  final bool isShared;

  const ProjectEditionState._({
    bool? isLoading,
    Exception? error,
    this.project,
    this.hasBeenUpdated = false,
    this.name = const ProjectNameInput.pure(),
    this.description = const ProjectDescriptionInput.pure(),
    this.isShared = true,
  }) : super(isLoading: isLoading, error: error);

  factory ProjectEditionState.pure() => ProjectEditionState._();

  factory ProjectEditionState.fromProject(Project project) => ProjectEditionState._(
      project: project,
      name: ProjectNameInput.pure(projectName: project.name),
      description: ProjectDescriptionInput.pure(projectDescription: project.description),
      isShared: project.isShared);

  @override
  List<FormzInput> get inputs => [name, description];

  ProjectEditionState copyWith(
          {bool? isLoading,
          Exception? error,
          Project? project,
          ProjectNameInput? name,
          ProjectDescriptionInput? description,
          bool? isShared}) =>
      ProjectEditionState._(
        isLoading: isLoading ?? false,
        error: error,
        project: project ?? this.project,
        hasBeenUpdated: project != null,
        name: name ?? this.name,
        description: description ?? this.description,
        isShared: isShared ?? this.isShared,
      );
}
