import 'package:gobz_app/clients/ApiClient.dart';
import 'package:gobz_app/clients/GobzApiClient.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/models/requests/ChapterCreationRequest.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class ChapterRepository {
  final ApiClient _client = GobzApiClient();

  Future<List<Chapter>> getChapters(int projectId) async {
    final List<dynamic> responseData = await _client.get("/projects/$projectId/chapters");

    try {
      return responseData.map((chapterData) => Chapter.fromJson(chapterData)).toList();
    } catch (e) {
      Log.error("Failed to create chapters from response", e);
      rethrow;
    }
  }

  Future<Chapter> createChapter(int projectId, ChapterCreationRequest request) async {
    final Map<String, dynamic> responseData = await _client.post("/projects/$projectId/chapters", body: request.toJson());

    try {
      return Chapter.fromJson(responseData);
    } catch (e) {
      Log.error("Failed to create chapter from response", e);
      rethrow;
    }
  }
}
