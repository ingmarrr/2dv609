import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rr_mobile/models/persistance.dart';
import 'package:rr_mobile/models/rng_color.dart';
import 'package:rr_mobile/models/scenario.dart';
import 'package:rr_mobile/widgets/bottom_navbar.dart';
import 'package:rr_mobile/widgets/page.dart';

class HomeView extends StatelessWidget {
  static const String id = '/';

  HomeView({super.key});

  final scenariosProvider = FutureProvider.autoDispose<List<Scenario>>((ref) {
    return Pers.getScenarios();
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    const pos = Position.top;

    return RPage(
      children: [
        SafeArea(
          child: Scenarios(
            searchPos: pos,
            scenariosProvider: scenariosProvider,
          ),
        ),
        const Search(pos: pos),
        const Positioned(
          bottom: 0,
          left: 0,
          child: BottomNavbar(),
        )
      ],
    );
  }
}

class Scenarios extends ConsumerWidget {
  final Position searchPos;
  final AutoDisposeFutureProvider<List<Scenario>?> scenariosProvider;
  final Future<void> Function(Scenario)? onTap;
  final Future<void> Function(Scenario)? onLongPress;
  final Future<void> Function(Scenario)? onDoubleTap;

  Scenarios({
    this.searchPos = Position.top,
    required this.scenariosProvider,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenariosAsync = ref.watch(scenariosProvider);

    return Container(
      padding: EdgeInsets.only(
        top: searchPos == Position.top ? 100 : 0,
        bottom: searchPos == Position.bottom ? 135 : 35,
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
        data: (data) {
          if (data == null) {
            return const Center(
              child: Text('Found nothing.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            );
          }
          return SingleChildScrollView(
            child: Wrap(
              children: List.generate(
                data.length,
                (idx) => ScenarioTile(
                  scenario: data[idx],
                  onTap: onTap,
                  onLongPress: onLongPress,
                  onDoubleTap: onDoubleTap,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ScenarioTile extends StatelessWidget {
  final Scenario scenario;
  final void Function(Scenario)? onTap;
  final void Function(Scenario)? onLongPress;
  final void Function(Scenario)? onDoubleTap;

  const ScenarioTile({
    super.key,
    required this.scenario,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
  });

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
      child: InkWell(
        onTap: () => onTap != null ? onTap!(scenario) : {},
        onDoubleTap: () => onDoubleTap != null ? onDoubleTap!(scenario) : {},
        onLongPress: () => onLongPress != null ? onLongPress!(scenario) : {},
        child: ListTile(
          title: Text(scenario.name),
          subtitle: Text(scenario.description),
        ),
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
