import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';
import 'package:gobz_app/widgets/forms/inputs/ProjectSearchInput.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectRepository _projectRepository;

  ProjectsBloc({required ProjectRepository projectRepository})
      : _projectRepository = projectRepository,
        super(ProjectsState());

  @override
  Stream<ProjectsState> mapEventToState(ProjectsEvent event) async* {
    if (event is FetchProjectsRequested) {
      yield* _onFetchProjects(event, state);
    } else if (event is SearchTextChanged) {
      yield state.copyWith(
          searchText: ProjectSearchInput.dirty(event.searchText));
    }
  }

  Stream<ProjectsState> _onFetchProjects(
      ProjectsEvent event, ProjectsState state) async* {
    yield state.copyWith(fetchStatus: ProjectStateStatus.FETCHING);
    try {
      final List<Project> projects = await _projectRepository.getAllProjects();
      yield state.copyWith(
          fetchStatus: ProjectStateStatus.FETCHED, projects: projects);
    } on Exception catch (e) {
      Log.error("Failed to retrieve projects", e);
      yield state.copyWith(fetchStatus: ProjectStateStatus.ERRORED);
    }
  }
}

// Events
abstract class ProjectsEvent {}

class FetchProjectsRequested extends ProjectsEvent {}

class SearchTextChanged extends ProjectsEvent {
  final String searchText;

  SearchTextChanged(this.searchText);
}

// State
class ProjectsState with FormzMixin {
  final ProjectStateStatus fetchStatus;
  final ProjectSearchInput searchText;
  final List<Project> projects;
  final List<Project> filteredProjects;

  ProjectsState(
      {this.fetchStatus = ProjectStateStatus.UNFETCHED,
      this.searchText = const ProjectSearchInput.pure(),
      this.projects = const [],
      this.filteredProjects = const []});

  @override
  List<FormzInput> get inputs => [searchText];

  ProjectsState copyWith(
      {ProjectStateStatus? fetchStatus,
      ProjectSearchInput? searchText,
      List<Project>? projects}) {
    final List<Project> _projects = projects ?? this.projects;
    final ProjectSearchInput _searchText = searchText ?? this.searchText;
    final List<Project> _filteredProjects;
    // If search text or project list changed, recompute
    if (searchText != null || projects != null) {
      if (_searchText.valid) {
        _filteredProjects = _projects
            .where((project) => project.name
                .toUpperCase()
                .contains(_searchText.value.toUpperCase()))
            .toList();
      } else {
        _filteredProjects = _projects;
      }
    } else {
      _filteredProjects = this.filteredProjects;
    }

    return ProjectsState(
        fetchStatus: fetchStatus ?? this.fetchStatus,
        searchText: _searchText,
        projects: _projects,
        filteredProjects: _filteredProjects);
  }
}

enum ProjectStateStatus { UNFETCHED, FETCHING, FETCHED, ERRORED }
