import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rr_mobile/models/migrations.dart';
import 'package:rr_mobile/routes.dart';
import 'package:rr_mobile/views/home.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = openDatabase(
    'rr.db',
    version: 1,
    onCreate: (Database db, int version) async {
      Migrations.runMigrations(db);
    },
  );
  runApp(const ProviderScope(child: RRApp()));
}

class RRApp extends StatelessWidget {
  const RRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGen.generateRoute,
      initialRoute: HomeView.id,
    );
  }
}
