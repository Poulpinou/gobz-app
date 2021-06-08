import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/FetchBlocState.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final int projectId;
  final ProjectRepository projectRepository;

  ProjectBloc({required this.projectRepository, required this.projectId, bool fetchOnStart = false})
      : super(ProjectState()) {
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
      final Project project = await projectRepository.getProject(projectId);
      yield state.fetched(project);
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
      await projectRepository.deleteProject(projectId);
      yield state.deleted();
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
class ProjectState extends FetchBlocState<Project> {
  const ProjectState({
    bool? isLoading,
    Exception? error,
    FetchStatus fetchStatus = FetchStatus.UNFECTHED,
    Project? project,
  }) : super(
          isLoading: isLoading,
          error: error,
          fetchStatus: fetchStatus,
          data: project,
        );

  Project? get project => data;

  ProjectState copyWith({
    bool? isLoading,
    Exception? error,
    FetchStatus? fetchStatus,
    Project? data,
    bool? projectDeleted,
  }) =>
      ProjectState(
          project: data ?? this.data,
          isLoading: isLoading ?? false,
          error: error,
          fetchStatus: fetchStatus ?? this.fetchStatus);
}
