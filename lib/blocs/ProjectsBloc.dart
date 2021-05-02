import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/exceptions/DisplayableException.dart';
import 'package:gobz_app/models/BlocState.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/repositories/ProjectRepository.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';
import 'package:gobz_app/widgets/forms/projects/inputs/ProjectSearchInput.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectRepository _projectRepository;

  ProjectsBloc({required ProjectRepository projectRepository})
      : _projectRepository = projectRepository,
        super(ProjectsState());

  @override
  Stream<ProjectsState> mapEventToState(ProjectsEvent event) async* {
    if (event is FetchProjects) {
      yield* _onFetchProjects(event, state);
    } else if (event is SearchTextChanged) {
      yield state.copyWith(searchText: ProjectSearchInput.dirty(event.searchText));
    }
  }

  Stream<ProjectsState> _onFetchProjects(ProjectsEvent event, ProjectsState state) async* {
    yield state.copyWith(isLoading: true);
    try {
      final List<Project> projects = await _projectRepository.getAllProjects();
      yield state.copyWith(projects: projects);
    } catch (e) {
      Log.error("Failed to retrieve projects", e);
      yield state.copyWith(
          error: DisplayableException(
              internMessage: e.toString(), messageToDisplay: "La récupération des projets a échoué"));
    }
  }
}

// Events
abstract class ProjectsEvent {}

class FetchProjects extends ProjectsEvent {}

class SearchTextChanged extends ProjectsEvent {
  final String searchText;

  SearchTextChanged(this.searchText);
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
