import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/models/ProjectInfos.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository _projectRepository;

  ProjectBloc(this._projectRepository, Project project, {bool fetchOnStart = false})
      : super(ProjectState(project: project)) {
    if (fetchOnStart) {
      add(_FetchProject());
    }
  }

  @override
  Stream<ProjectState> mapEventToState(ProjectEvent event) async* {
    if (event is _FetchProject) {
      yield* _fetchProject();
    } else if (event is _DeleteProject) {
      yield* _deleteProject();
    }
  }

  Stream<ProjectState> _fetchProject() async* {
    yield state.loading();
    try {
      final ProjectInfos projectInfos = await _projectRepository.getProjectInfos(state.project.id);
      yield state.copyWith(project: projectInfos.project, projectInfos: projectInfos);
    } catch (e) {
      yield state.errored(
        DisplayableException(
          "La récupération du projet a échoué",
          errorMessage: "Failed to retrieve project",
          error: e is Exception ? e : null,
        ),
      );
    }
  }

  Stream<ProjectState> _deleteProject() async* {
    yield state.loading();
    try {
      await _projectRepository.deleteProject(state.project.id);
      yield state.copyWith(projectDeleted: true);
    } catch (e) {
      yield state.errored(
        DisplayableException(
          "La suppression du projet a échoué",
          errorMessage: "Failed to delete project",
          error: e is Exception ? e : null,
        ),
      );
    }
  }
}

// Events
abstract class ProjectEvent {}

abstract class ProjectEvents {
  static _FetchProject fetch() => _FetchProject();

  static _DeleteProject delete() => _DeleteProject();
}

class _FetchProject extends ProjectEvent {}

class _DeleteProject extends ProjectEvent {}

// State
class ProjectState extends BlocState {
  final Project project;
  final ProjectInfos? projectInfos;
  final bool projectDeleted;

  const ProjectState(
      {bool? isLoading, Exception? error, required this.project, this.projectInfos, this.projectDeleted = false})
      : super(isLoading: isLoading, error: error);

  bool get shouldBeFetched => projectInfos == null;

  ProjectState copyWith({
    bool? isLoading,
    Exception? error,
    Project? project,
    ProjectInfos? projectInfos,
    bool? projectDeleted,
  }) =>
      ProjectState(
        project: project ?? this.project,
        isLoading: isLoading ?? false,
        error: error,
        projectInfos: projectInfos ?? this.projectInfos,
        projectDeleted: projectDeleted ?? this.projectDeleted,
      );
}
