import 'package:flutter/material.dart';
import 'package:rr_mobile/models/api.dart';
import 'package:rr_mobile/models/rng_color.dart';

import 'home.dart';

class UsersView extends StatelessWidget {
  static const String id = '/users';

  const UsersView({super.key});

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
            SafeArea(child: Users(searchPos: pos)),
            Search(pos: pos),
          ],
        ),
      ),
    );
  }
}

class Users extends StatelessWidget {
  final Position searchPos;

  const Users({this.searchPos = Position.top, super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.only(
          top: searchPos == Position.top ? 100 : 0,
          bottom: searchPos == Position.bottom ? 100 : 0),
      child: FutureBuilder(
        future: Api.getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          return SingleChildScrollView(
            child: Wrap(
              children: List.generate(
                snapshot.data?.length ?? 0,
                (idx) => Container(
                  width: mq.size.width / 2 - 40,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: RngColor.getColor(),
                  ),
                  child: ListTile(
                    title: Text(
                      snapshot.data![idx].username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data![idx].email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
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
