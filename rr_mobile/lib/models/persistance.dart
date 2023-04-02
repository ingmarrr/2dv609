import 'package:rr_mobile/models/scenario.dart';
import 'package:sqflite/sqflite.dart';

class Pers {
  static Future<Database> get db async {
    return openDatabase(
      'rr.db',
      version: 1,
    );
  }

  static Future<List<Scenario>> getScenarios() async {
    final db = await Pers.db;
    final scenarios = await db.query('scenarios');
    return List.generate(
        scenarios.length, (idx) => Scenario.fromJson(scenarios[idx]));
  }
}
