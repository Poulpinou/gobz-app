import 'package:gobz_app/data/clients/ApiClient.dart';
import 'package:gobz_app/data/clients/GobzApiClient.dart';
import 'package:gobz_app/data/models/User.dart';

class UserRepository {
  final ApiClient _client = GobzApiClient(basePath: "/users");

  Future<User?> getCurrentUser() async {
    final Map<String, dynamic> responseData = await _client.get("/me");

    return User.fromJson(responseData);
  }
}
