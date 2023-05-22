import 'package:flutter/material.dart';
import 'package:rr_mobile/models/scenario.dart';
import 'package:rr_mobile/views/download.dart';
import 'package:rr_mobile/views/home.dart';
import 'package:rr_mobile/views/login.dart';
import 'package:rr_mobile/views/scenario.dart';
import 'package:rr_mobile/views/username.dart';
import 'package:rr_mobile/views/users.dart';

class RouteGen {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return switch (settings.name) {
      "/" => move(HomeView()),
      "/users" => move(const UsersView()),
      "/login" => move(const LoginView()),
      "/username" => move(UsernameView.from(settings.arguments as UVArgs)),
      "/download" => move(DownloadView()),
      // case "/scenario":
      //   final scenario = settings.arguments as Scenario;
      //   return move(ScenarioView());
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
          // child: SizeTransition(
          //   sizeFactor: animation,
          //   axisAlignment: 0.0,
          //   child: child,
          // ),
        );
      },
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('ERROR'),
          ),
        );
      },
    );
  }
}
