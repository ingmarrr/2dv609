import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rr_mobile/models/api.dart';
import 'package:rr_mobile/models/migrations.dart';
import 'package:rr_mobile/models/persistance.dart';
import 'package:rr_mobile/models/rng_color.dart';
import 'package:rr_mobile/models/scenario.dart';
import 'package:rr_mobile/widgets/botton_navbar.dart';
import 'package:sqflite/sqflite.dart';

class HomeView extends StatelessWidget {
  static const String id = '/';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final mqPadding = mq.padding;
    final pos = Position.top;

    return Scaffold(
      body: Container(
        height: mq.size.height,
        width: mq.size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/color_splash.png'),
            fit: BoxFit.cover,
            opacity: .7,
          ),
        ),
        child: Stack(
          children: [
            SafeArea(child: Scenarios(searchPos: pos)),
            Search(pos: pos),
            const Positioned(
              bottom: 0,
              left: 0,
              child: BottomNavbar(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        final db = await openDatabase(
          'rr.db',
          version: 1,
        );
        // Migrations.runMigrations(db);
        final scenarios = await db.query('scenarios');
        print("Scenarios: $scenarios");
      }),
    );
  }
}

class Scenarios extends ConsumerWidget {
  final Position searchPos;

  Scenarios({this.searchPos = Position.top, super.key});

  final scenariosProvider = FutureProvider.autoDispose<List<Scenario>>((ref) {
    return Pers.getScenarios();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenariosAsync = ref.watch(scenariosProvider);

    return Container(
      padding: EdgeInsets.only(
        top: searchPos == Position.top ? 100 : 0,
        bottom: searchPos == Position.bottom ? 150 : 0,
      ),
      child: scenariosAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) {
          debugPrintStack(label: error.toString(), stackTrace: stack);
          return Center(
            child: Text(stack.toString()),
          );
        },
        data: (data) => SingleChildScrollView(
          child: Wrap(
            children: List.generate(
              data.length,
              (idx) => ScenarioTile(scenario: data[idx]),
            ),
          ),
        ),
      ),
    );
  }
}

class ScenarioTile extends StatelessWidget {
  final Scenario scenario;

  const ScenarioTile({super.key, required this.scenario});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Container(
      // height: 110,
      width: mq.size.width / 2 - 40,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: RngColor.getColor(),
      ),
      child: ListTile(
        title: Text(scenario.name),
        subtitle: Text(scenario.description),
      ),
    );
  }
}

enum Position {
  top,
  bottom,
}

class Search extends StatelessWidget {
  final Position pos;

  const Search({this.pos = Position.top, super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Positioned(
      top: pos == Position.top ? 20 : null,
      bottom: pos == Position.bottom ? 20 : null,
      child: SafeArea(
        child: Container(
          width: mq.size.width - 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(.2),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Search',
            ),
          ),
        ),
      ),
    );
  }
}
