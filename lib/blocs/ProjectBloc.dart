import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/models/ProjectInfos.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository _projectRepository;

  ProjectBloc(this._projectRepository, Project project) : super(ProjectState(project: project));

  @override
  Stream<ProjectState> mapEventToState(ProjectEvent event) async* {
    if (event is FetchProject) {
      yield* _fetchProject();
    }
    if (event is DeleteProject) {
      yield* _deleteProject();
    }
  }

  Stream<ProjectState> _fetchProject() async* {
    yield state.copyWith(isLoading: true);
    try {
      final ProjectInfos projectInfos = await _projectRepository.getProjectInfos(state.project.id);
      yield state.copyWith(project: projectInfos.project, projectInfos: projectInfos);
    } catch (e) {
      Log.error("Failed to retrieve project", e);
      yield state.copyWith(
          error: DisplayableException(
              internMessage: e.toString(), messageToDisplay: "La récupération du projet a échoué"));
    }
  }

  Stream<ProjectState> _deleteProject() async* {
    yield state.copyWith(isLoading: true);
    try {
      await _projectRepository.deleteProject(state.project.id);
      yield state.copyWith(projectDeleted: true);
    } catch (e) {
      Log.error("Failed to delete project", e);
      yield state.copyWith(
          error:
              DisplayableException(internMessage: e.toString(), messageToDisplay: "La suppression du projet a échoué"));
    }
  }
}

// Events
abstract class ProjectEvent {}

class FetchProject extends ProjectEvent {}

class DeleteProject extends ProjectEvent {}

// State
class ProjectState extends BlocState {
  final Project project;
  final ProjectInfos? projectInfos;
  final bool projectDeleted;
  final bool projectUpToDate;

  const ProjectState(
      {bool? isLoading,
      Exception? error,
      required this.project,
      this.projectInfos,
      this.projectDeleted = false,
      this.projectUpToDate = false})
      : super(isLoading: isLoading, error: error);

  bool get shouldBeFetched => !projectUpToDate || projectInfos == null;

  ProjectState copyWith(
          {bool? isLoading,
          Exception? error,
          Project? project,
          ProjectInfos? projectInfos,
          bool? projectDeleted,
          bool? projectUpToDate}) =>
      ProjectState(
        project: project ?? this.project,
        isLoading: isLoading ?? false,
        error: error,
        projectInfos: projectInfos ?? this.projectInfos,
        projectDeleted: projectDeleted ?? this.projectDeleted,
        projectUpToDate: projectUpToDate ?? this.projectDeleted,
      );
}
