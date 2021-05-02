import 'package:gobz_app/clients/ApiClient.dart';
import 'package:gobz_app/clients/GobzApiClient.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/models/ProjectInfos.dart';
import 'package:gobz_app/models/requests/ProjectCreationRequest.dart';
import 'package:gobz_app/models/requests/ProjectUpdateRequest.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class ProjectRepository {
  final ApiClient _client = GobzApiClient(basePath: "/projects");

  Future<List<Project>> getAllProjects() async {
    final List<dynamic> responseData = await _client.get("");

    final List<Project> projects = [];
    responseData.forEach((element) {
      try {
        final Project project = Project.fromJson(element);
        projects.add(project);
      } catch (e) {
        Log.error("Failed to build project from data: $element", e);
        rethrow;
      }
    });

    return projects;
  }

  Future<Project> getProject(int projectId) async {
    final Map<String, dynamic> responseData = await _client.get("/$projectId");
    return Project.fromJson(responseData);
  }

  Future<ProjectInfos> getProjectInfos(int projectId) async {
    final Map<String, dynamic> responseData = await _client.get("/$projectId/infos");
    return ProjectInfos.fromJson(responseData);
  }

  Future<Project> createProject(ProjectCreationRequest request) async {
    final Map<String, dynamic> responseData = await _client.post("", body: request.toJson());

    return Project.fromJson(responseData);
  }

  Future<Project> updateProject(int projectId, ProjectUpdateRequest request) async {
    final Map<String, dynamic> responseData = await _client.put("/$projectId", body: request.toJson());

    return Project.fromJson(responseData);
  }

  Future<void> deleteProject(int projectId) async {
    return await _client.delete("/$projectId");
  }
}
