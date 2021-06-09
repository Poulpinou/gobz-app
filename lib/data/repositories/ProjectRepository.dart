import 'package:gobz_app/data/clients/ApiClient.dart';
import 'package:gobz_app/data/clients/GobzApiClient.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/models/ProjectInfos.dart';
import 'package:gobz_app/data/models/ProjectMember.dart';
import 'package:gobz_app/data/models/ProjectProgress.dart';
import 'package:gobz_app/data/models/requests/ProjectCreationRequest.dart';
import 'package:gobz_app/data/models/requests/ProjectUpdateRequest.dart';
import 'package:gobz_app/data/utils/LoggingUtils.dart';

class ProjectRepository {
  final ApiClient _client = GobzApiClient(basePath: "/projects");

  Future<List<Project>> getAllProjects() async {
    final List<dynamic> responseData = await _client.get("");

    try {
      return responseData.map((projectData) => Project.fromJson(projectData)).toList();
    } catch (e) {
      Log.error("Failed to create projects from response", e);
      rethrow;
    }
  }

  Future<Project> getProject(int projectId) async {
    final Map<String, dynamic> responseData = await _client.get("/$projectId");

    try {
      return Project.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create project from response", e);
      rethrow;
    }
  }

  Future<ProjectInfos> getProjectInfos(int projectId) async {
    final Map<String, dynamic> responseData = await _client.get("/$projectId/infos");

    try {
      return ProjectInfos.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create project infos from response", e);
      rethrow;
    }
  }

  Future<ProjectProgress> getProjectProgress(int projectId) async {
    final Map<String, dynamic> responseData = await _client.get("/$projectId/progress");

    try {
      return ProjectProgress.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create project infos from response", e);
      rethrow;
    }
  }

  Future<List<ProjectMember>> getProjectMembers(int projectId) async {
    final List<dynamic> responseData = await _client.get("/$projectId/members");

    try {
      return responseData.map((memberData) => ProjectMember.fromJson(memberData)).toList();
    } catch (e) {
      Log.error("Failed to create project members from response", e);
      rethrow;
    }
  }

  Future<Project> createProject(ProjectCreationRequest request) async {
    final Map<String, dynamic> responseData = await _client.post("", body: request.toJson());

    try {
      return Project.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create project from response", e);
      rethrow;
    }
  }

  Future<Project> updateProject(int projectId, ProjectUpdateRequest request) async {
    final Map<String, dynamic> responseData = await _client.put("/$projectId", body: request.toJson());

    try {
      return Project.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create project from response", e);
      rethrow;
    }
  }

  Future<void> deleteProject(int projectId) async {
    return await _client.delete("/$projectId");
  }
}
