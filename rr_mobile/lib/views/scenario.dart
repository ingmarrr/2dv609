import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rr_mobile/models/scenario.dart';
import 'package:rr_mobile/widgets/page.dart';

class ScenarioView extends ConsumerWidget {
  static const String id = '/scenario';

  final Scenario scenario;
  const ScenarioView({required this.scenario, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RPage(children: [
      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scenario.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              scenario.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Instructions:",
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 15,
            ),
            ...scenario.instructions.split("\\n").map((ins) => Text(
                  ins,
                  style: const TextStyle(fontSize: 18),
                )),
          ],
        ),
      ),
    ]);
  }
}
