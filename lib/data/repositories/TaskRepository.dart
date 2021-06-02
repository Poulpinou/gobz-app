import 'package:gobz_app/data/clients/ApiClient.dart';
import 'package:gobz_app/data/clients/GobzApiClient.dart';
import 'package:gobz_app/data/models/Task.dart';
import 'package:gobz_app/data/models/requests/TaskCreationRequest.dart';
import 'package:gobz_app/data/models/requests/TaskUpdateRequest.dart';
import 'package:gobz_app/data/utils/LoggingUtils.dart';

class TaskRepository {
  final ApiClient _client = GobzApiClient();

  Future<List<Task>> getTasks(int stepId) async {
    final List<dynamic> responseData = await _client.get("/steps/$stepId/tasks");

    try {
      return responseData.map((taskData) => Task.fromJson(taskData)).toList();
    } catch (e) {
      Log.error("Failed to create tasks from response", e);
      rethrow;
    }
  }

  Future<Task> getTask(int taskId) async {
    final Map<String, dynamic> responseData = await _client.get("/tasks/$taskId");

    try {
      return Task.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create task from response", e);
      rethrow;
    }
  }

  Future<Task> createTask(int stepId, TaskCreationRequest request) async {
    final Map<String, dynamic> responseData = await _client.post("/steps/$stepId/tasks", body: request.toJson());

    try {
      return Task.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create task from response", e);
      rethrow;
    }
  }

  Future<Task> updateTask(int taskId, TaskUpdateRequest request) async {
    final Map<String, dynamic> responseData = await _client.put("/tasks/$taskId", body: request.toJson());

    try {
      return Task.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create task from response", e);
      rethrow;
    }
  }

  Future<void> deleteTask(int taskId) async {
    return await _client.delete("/tasks/$taskId");
  }
}
