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
    return RPage(
      children: [
        Text(scenario.name),
        Text(scenario.description),
      ],
    );
  }
}
