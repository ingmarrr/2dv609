import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class Migrations {
  // Migrations, includes the tables: users, scenarios, sessions
  static const String createUsersTable = '''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY,
      name TEXT,
      email TEXT,
      password TEXT,
      createdAt TEXT,
      updatedAt TEXT
    );
  ''';

  static const String createScenariosTable = '''
    CREATE TABLE IF NOT EXISTS scenarios (
      id INTEGER PRIMARY KEY,
      name TEXT,
      category TEXT,
      description TEXT,
      keywords TEXT,
      instructions TEXT,
      createdAt TEXT,
      updatedAt TEXT
    );
  ''';

  // static const String createSessionsTable = '''
  //   CREATE TABLE IF NOT EXISTS sessions (
  //     id INTEGER PRIMARY KEY,
  //     userId INTEGER,
  //     token TEXT,
  //   );
  // ''';

  // Run the migrations
  static Future<void> runMigrations(Database db) async {
    await db.execute(createUsersTable);
    await db.execute(createScenariosTable);
    // await db.execute(createSessionsTable);

    final sql = await rootBundle.loadString('assets/migrations/scenarios.sql');
    await db.execute(sql);
    debugPrint("scenarios: $sql");

    /// This is a different option to load the data from the json file

    // final scenarios = await rootBundle.loadString('assets/data/scenarios.json');
    // debugPrint(const JsonCodec().decode(scenarios).toString());
    // await db.insert('scenarios', const JsonCodec().decode(scenarios));
  }
}
