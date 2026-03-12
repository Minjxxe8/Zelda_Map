import 'dart:convert';
import 'dart:io';

import '/model/user.dart';
import 'package:http/http.dart';

class UserDataSource {
  final Client _client;
  UserDataSource(this._client);

  Future<UserDto> fetchUser(String id) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final uri = Uri.parse('https://jsonplaceholder.typicode.com/users/$id');
      final request = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 5));

      // Conversion brute JSON -> DTO
      return UserDto.fromJson(jsonDecode(request.body));
    } on HttpException catch (e) {
      // Propagation de l'erreur technique
      throw ServerException.fromHttp(e);
    }
  }

  Future<List<UserDto>> fetchUsers() async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final uri = Uri.parse('https://jsonplaceholder.typicode.com/users');
      final request = await _client.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      final List<dynamic> users = jsonDecode(request.body);

      // Conversion brute JSON -> DTO
      return users.map((element) => UserDto.fromJson(element)).toList();
    } on HttpException catch (e) {
      // Propagation de l'erreur technique
      throw ServerException.fromHttp(e);
    }
  }
}

class ServerException implements Exception {
  String cause;
  ServerException(this.cause);

  factory ServerException.fromHttp(HttpException e) {
    return ServerException(e.message);
  }
}
