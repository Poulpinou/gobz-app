import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/BlocState.dart';
import 'package:gobz_app/data/exceptions/DisplayableException.dart';
import 'package:gobz_app/data/formInputs/projects/ProjectSearchInput.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectRepository projectRepository;

  ProjectsBloc({required this.projectRepository, bool fetchOnStart = false}) : super(ProjectsState()) {
    if (fetchOnStart) {
      add(_FetchProjects());
    }
  }

  @override
  Stream<ProjectsState> mapEventToState(ProjectsEvent event) async* {
    if (event is _FetchProjects) {
      yield* _onFetchProjects(state);
    } else if (event is _SearchTextChanged) {
      yield state.copyWith(searchText: ProjectSearchInput.dirty(event.searchText));
    }
  }

  Stream<ProjectsState> _onFetchProjects(ProjectsState state) async* {
    yield state.loading();
    try {
      final List<Project> projects = await projectRepository.getAllProjects();
      yield state.copyWith(projects: projects);
    } catch (e) {
      yield state.errored(
        DisplayableException(
          "La récupération des projets a échoué",
          errorMessage: "Failed to retrieve projects",
          error: e is Exception ? e : null,
        ),
      );
    }
  }
}

// Events
abstract class ProjectsEvent {}

abstract class ProjectsEvents {
  static _FetchProjects fetch() => _FetchProjects();

  static _SearchTextChanged searchTextChanged(String searchText) => _SearchTextChanged(searchText);
}

class _FetchProjects extends ProjectsEvent {}

class _SearchTextChanged extends ProjectsEvent {
  final String searchText;

  _SearchTextChanged(this.searchText);
}

// State
class ProjectsState extends BlocState with FormzMixin {
  final ProjectSearchInput searchText;
  final List<Project> projects;
  final List<Project> filteredProjects;

  ProjectsState(
      {bool? isLoading,
      Exception? error,
      this.searchText = const ProjectSearchInput.pure(),
      this.projects = const [],
      this.filteredProjects = const []})
      : super(isLoading: isLoading, error: error);

  @override
  List<FormzInput> get inputs => [searchText];

  ProjectsState copyWith({bool? isLoading, Exception? error, ProjectSearchInput? searchText, List<Project>? projects}) {
    final List<Project> _projects = projects ?? this.projects;
    final ProjectSearchInput _searchText = searchText ?? this.searchText;
    final List<Project> _filteredProjects;
    // If search text or project list changed, recompute
    if (searchText != null || projects != null) {
      if (_searchText.valid) {
        _filteredProjects =
            _projects.where((project) => project.name.toUpperCase().contains(_searchText.value.toUpperCase())).toList();
      } else {
        _filteredProjects = _projects;
      }
    } else {
      _filteredProjects = this.filteredProjects;
    }

    return ProjectsState(
        isLoading: isLoading ?? false,
        error: error,
        searchText: _searchText,
        projects: _projects,
        filteredProjects: _filteredProjects);
  }
}
