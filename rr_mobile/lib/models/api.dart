import 'dart:async';
import 'dart:convert';
import 'package:rr_mobile/models/scenario.dart';
import 'package:http/http.dart' as http;
import 'package:rr_mobile/models/user.dart';

class Api {
  static const String baseUrl = "http://localhost:8080/rr";

  static Future<List<Scenario>> getScenarios() async {
    final response = await http.get(Uri.parse("$baseUrl/scenarios"));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<Scenario> scenarios = body
          .map(
            (dynamic item) => Scenario.fromJson(item),
          )
          .toList();
      return scenarios;
    } else {
      throw "Can't get scenarios.";
    }
  }

  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/users"));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<User> users = List.generate(
          body["users"].length, (idx) => User.fromJson(body["users"][idx]));
      return users;
    } else {
      throw "Can't get users.";
    }
  }
}
