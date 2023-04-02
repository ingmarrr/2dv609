import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rr_mobile/models/api.dart';
import 'package:rr_mobile/models/persistance.dart';
import 'package:rr_mobile/models/scenario.dart';
import 'package:rr_mobile/views/home.dart';
import 'package:rr_mobile/widgets/page.dart';

class DownloadView extends HookConsumerWidget {
  static const String id = '/download';

  DownloadView({super.key});

  final scenariosProvider = FutureProvider.autoDispose<List<Scenario>?>((ref) {
    return Api.getAdditionalScenarios();
  });

  Future<void> onDoubleTap(Scenario scenario) async {
    await Pers.storeScenario(scenario);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RPage(
      children: [
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Downloads',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Scenarios(
          scenariosProvider: scenariosProvider,
          onDoubleTap: onDoubleTap,
        )
      ],
    );
  }
}
