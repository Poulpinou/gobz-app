import 'package:gobz_app/clients/ApiClient.dart';
import 'package:gobz_app/clients/GobzApiClient.dart';
import 'package:gobz_app/models/User.dart';

class UserRepository {
  final ApiClient _client = GobzApiClient(basePath: "/users");

  User? _user;

  Future<User?> getCurrentUser() async {
    if (_user != null) return _user;

    Map<String, dynamic> responseData = await _client.get("/me");

    _user = User.fromJson(responseData);

    return _user;
  }
}
