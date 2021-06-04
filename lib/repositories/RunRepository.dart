import 'package:gobz_app/clients/ApiClient.dart';
import 'package:gobz_app/clients/GobzApiClient.dart';
import 'package:gobz_app/models/Run.dart';
import 'package:gobz_app/models/requests/RunCreationRequest.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class RunRepository {
  final ApiClient _client = GobzApiClient(basePath: "/runs");

  Future<List<Run>> getRuns() async {
    final List<dynamic> responseData = await _client.get("");

    try {
      return responseData.map((runData) => Run.fromJson(runData)).toList();
    } catch (e) {
      Log.error("Failed to create runs from response", e);
      rethrow;
    }
  }

  Future<Run> getRun(int runId) async {
    final Map<String, dynamic> responseData = await _client.get("/$runId");

    try {
      return Run.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create run from response", e);
      rethrow;
    }
  }

  Future<Run> createRun(RunCreationRequest request) async {
    final Map<String, dynamic> responseData = await _client.post("", body: request.toJson());

    try {
      return Run.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create run from response", e);
      rethrow;
    }
  }

  Future<void> abandonRun(int runId) async {
    await _client.patch("/$runId");
  }

  Future<int> getMaxActiveAmount() async {
    return await _client.get("/maxActiveAmount");
  }
}
