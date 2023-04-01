import 'package:flutter/material.dart';
import 'package:rr_mobile/models/api.dart';
import 'package:rr_mobile/models/rng_color.dart';

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
          ],
        ),
      ),
    );
  }
}

class Scenarios extends StatelessWidget {
  final Position searchPos;

  const Scenarios({this.searchPos = Position.top, super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.only(
          top: searchPos == Position.top ? 100 : 0,
          bottom: searchPos == Position.bottom ? 100 : 0),
      child: FutureBuilder(
        future: Api.getScenarios(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Wrap(
              children: List.generate(
                snapshot.data?.length ?? 0,
                (idx) => Container(
                  height: 110,
                  width: mq.size.width / 2 - 40,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: RngColor.getColor(),
                  ),
                  child: const Center(
                    child: Text(""),
                  ),
                ),
              ),
            ),
          );
        },
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
