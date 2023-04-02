import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rr_mobile/models/persistance.dart';
import 'package:rr_mobile/models/scenario.dart';
import 'package:http/http.dart' as http;
import 'package:rr_mobile/models/user.dart';

class Api {
  static const String baseUrl = "http://localhost:8080";

  static Future<List<Scenario>?> getScenarios() async {
    final response = await http.get(Uri.parse("$baseUrl/scenarios"));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<Scenario> scenarios = List.generate(body["scenarios"].length,
          (idx) => Scenario.fromJson(body["scenarios"][idx]));
      return scenarios;
    }
    return null;
  }

  static Future<List<Scenario>?> getAdditionalScenarios() async {
    final response = await http.get(Uri.parse("$baseUrl/additional"));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      debugPrint(body.toString());
      final List<Scenario> scenarios = List.generate(body["scenarios"].length,
          (idx) => Scenario.fromJson(body["scenarios"][idx]));

      // Get the scenarios from the database
      final List<Scenario> dbScenarios = await Pers.getScenarios();
      final List<Scenario> additionalScenarios = [];
      for (final scenario in scenarios) {
        if (!dbScenarios.any((element) => element.id == scenario.id)) {
          additionalScenarios.add(scenario);
        }
      }
      return additionalScenarios;
    }
    return null;
  }

  static Future<Scenario?> getScenario(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/scenario/$id"));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Scenario.fromJson(body);
    }
    return null;
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

  static Future<User?> login(String email, String password) async {
    final response = await http.post(Uri.parse("$baseUrl/login"),
        body: jsonEncode({"usernameOrEmail": email, "password": password}),
        headers: {"Content-Type": "application/json"});

    debugPrint(response.body);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return User.fromJson(body);
    }
    return null;
  }

  static Future<User?> register(
      String email, String username, String password) async {
    final response = await http.post(Uri.parse("$baseUrl/register"),
        body: jsonEncode(
            {"email": email, "username": username, "password": password}),
        headers: {"Content-Type": "application/json"});

    debugPrint(response.body);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return User.fromJson(body["user"]);
    }
    return null;
  }
}
