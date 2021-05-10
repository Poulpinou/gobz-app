import 'package:gobz_app/clients/ApiClient.dart';
import 'package:gobz_app/clients/GobzApiClient.dart';
import 'package:gobz_app/models/Step.dart';
import 'package:gobz_app/models/requests/StepCreationRequest.dart';
import 'package:gobz_app/models/requests/StepUpdateRequest.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class StepRepository {
  final ApiClient _client = GobzApiClient();

  Future<List<Step>> getSteps(int chapterId) async {
    final List<dynamic> responseData = await _client.get("/chapters/$chapterId/steps");

    try {
      return responseData.map((stepData) => Step.fromJson(stepData)).toList();
    } catch (e) {
      Log.error("Failed to create steps from response", e);
      rethrow;
    }
  }

  Future<Step> getStep(int stepId) async {
    final Map<String, dynamic> responseData = await _client.get("/steps/$stepId");

    try {
      return Step.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create step from response", e);
      rethrow;
    }
  }

  Future<Step> createStep(int chapterId, StepCreationRequest request) async {
    final Map<String, dynamic> responseData = await _client.post("/chapters/$chapterId/steps", body: request.toJson());

    try {
      return Step.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create step from response", e);
      rethrow;
    }
  }

  Future<Step> updateStep(int stepId, StepUpdateRequest request) async {
    final Map<String, dynamic> responseData = await _client.put("/steps/$stepId", body: request.toJson());

    try {
      return Step.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create step from response", e);
      rethrow;
    }
  }

  Future<void> deleteStep(int stepId) async {
    return await _client.delete("/steps/$stepId");
  }
}
