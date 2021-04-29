import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/models/requests/ProjectCreationRequest.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';
import 'package:gobz_app/widgets/forms/inputs/ProjectDescriptionInput.dart';
import 'package:gobz_app/widgets/forms/inputs/ProjectNameInput.dart';

class ProjectEditionBloc
    extends Bloc<ProjectEditionEvent, ProjectEditionState> {
  final ProjectRepository _projectRepository;

  ProjectEditionBloc(this._projectRepository)
      : super(const ProjectEditionState());

  @override
  Stream<ProjectEditionState> mapEventToState(
      ProjectEditionEvent event) async* {
    if (event is ProjectNameChanged) {
      yield state.copyWith(name: ProjectNameInput.dirty(event.name));
    } else if (event is ProjectDescriptionChanged) {
      yield state.copyWith(
          description: ProjectDescriptionInput.dirty(event.description));
    } else if (event is ProjectIsSharedChanged) {
      yield state.copyWith(isShared: event.isShared);
    } else if (event is CreateProjectFormSubmitted) {
      yield* _onCreateProjectFormSubmitted(event, state);
    } else if (event is UpdateProjectFormSubmitted) {
      yield* _onUpdateProjectFormSubmitted(event, state);
    }
  }

  Stream<ProjectEditionState> _onCreateProjectFormSubmitted(
      CreateProjectFormSubmitted event, ProjectEditionState state) async* {
    if (state.status.isValidated) {
      yield state.copyWith(formStatus: FormzStatus.submissionInProgress);
      try {
        final Project project = (await _projectRepository.createProject(
            ProjectCreationRequest(
                state.name.value, state.description.value, state.isShared)));

        yield state.copyWith(
            project: project, formStatus: FormzStatus.submissionSuccess);
      } on Exception catch (e) {
        Log.error('Project creation failed', e);
        yield state.copyWith(formStatus: FormzStatus.submissionFailure);
      }
    }
  }

  Stream<ProjectEditionState> _onUpdateProjectFormSubmitted(
      UpdateProjectFormSubmitted event, ProjectEditionState state) async* {
    // TODO: implement method
    throw UnimplementedError();
  }
}

// Events
abstract class ProjectEditionEvent {
  const ProjectEditionEvent();
}

class ProjectNameChanged extends ProjectEditionEvent {
  final String name;

  const ProjectNameChanged(this.name);
}

class ProjectDescriptionChanged extends ProjectEditionEvent {
  final String description;

  const ProjectDescriptionChanged(this.description);
}

class ProjectIsSharedChanged extends ProjectEditionEvent {
  final bool isShared;

  const ProjectIsSharedChanged(this.isShared);
}

class CreateProjectFormSubmitted extends ProjectEditionEvent {
  const CreateProjectFormSubmitted();
}

class UpdateProjectFormSubmitted extends ProjectEditionEvent {
  const UpdateProjectFormSubmitted();
}

// State
class ProjectEditionState with FormzMixin {
  final Project? project;
  final FormzStatus formStatus;
  final ProjectNameInput name;
  final ProjectDescriptionInput description;
  final bool isShared;

  const ProjectEditionState(
      {this.project,
      this.formStatus = FormzStatus.pure,
      this.name = const ProjectNameInput.pure(),
      this.description = const ProjectDescriptionInput.pure(),
      this.isShared = true});

  @override
  List<FormzInput> get inputs => [name, description];

  ProjectEditionState copyWith(
          {Project? project,
          FormzStatus? formStatus,
          ProjectNameInput? name,
          ProjectDescriptionInput? description,
          bool? isShared}) =>
      ProjectEditionState(
          project: project ?? this.project,
          formStatus: formStatus ?? this.status,
          name: name ?? this.name,
          description: description ?? this.description,
          isShared: isShared ?? this.isShared);
}
