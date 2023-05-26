import 'package:flutter/material.dart';
import 'package:rr_mobile/models/scenario.dart';
import 'package:rr_mobile/views/download.dart';
import 'package:rr_mobile/views/home.dart';
import 'package:rr_mobile/views/login.dart';
import 'package:rr_mobile/views/scenario.dart';
import 'package:rr_mobile/views/username.dart';

class RouteGen {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return switch (settings.name) {
      "/" => move(HomeView()),
      "/login" => move(const LoginView()),
      "/username" => move(
          UsernameView.from(settings.arguments as UVArgs),
        ),
      "/download" => move(DownloadView()),
      "/scenario" => move(
          ScenarioView(scenario: settings.arguments as Scenario),
        ),
      "/unimplemented" => _unimplemented(),
      _ => _errorRoute()
    };
  }

  static PageRouteBuilder<dynamic> move(Widget target) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, anotherAnimation) {
        return target;
      },
      transitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (context, animation, anotherAnimation, child) {
        animation = CurvedAnimation(
          curve: Curves.easeIn,
          parent: animation,
        );
        return Align(
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(_),
            ),
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('ERROR'),
          ),
        );
      },
    );
  }

  static Route<dynamic> _unimplemented() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(_),
            ),
            title: const Text('Unimplemented'),
          ),
          body: const Center(
            child: Text('Unimplemented'),
          ),
        );
      },
    );
  }
}
