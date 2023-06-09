import 'package:flutter/material.dart';
import 'package:rr_mobile/models/migrations.dart';
import 'package:rr_mobile/models/persistance.dart';
import 'package:rr_mobile/widgets/bottom_navbar.dart';

class RPage extends StatelessWidget {
  final List<Widget> children;

  const RPage({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        height: mq.size.height,
        width: mq.size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(color: Color(0xFFF3FAFF)),
        child: Stack(
          children: [
            ...children,
            const Positioned(
              bottom: 0,
              left: 0,
              child: BottomNavbar(),
            )
          ],
        ),
      ),
    );
  }
}
