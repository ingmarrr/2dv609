import 'package:flutter/material.dart';
import 'package:rr_mobile/routes.dart';
import 'package:rr_mobile/views/home.dart';

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
