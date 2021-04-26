import 'package:gobz_app/clients/ApiClient.dart';
import 'package:gobz_app/clients/GobzApiClient.dart';
import 'package:gobz_app/models/Project.dart';
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
      } on Exception catch (e) {
        Log.error("Failed tor build project from data: $element", e);
      }
    });

    return projects;
  }
}
