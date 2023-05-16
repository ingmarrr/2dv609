import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rr_mobile/models/api.dart';
import 'package:rr_mobile/views/home.dart';
import 'package:rr_mobile/views/login.dart';

class UVArgs {
  final String email;
  final String password;

  const UVArgs(this.email, this.password);
}

class UsernameView extends HookConsumerWidget {
  final String email;
  final String password;

  const UsernameView({required this.email, required this.password, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/color_splash.png'),
            fit: BoxFit.cover,
            opacity: .7,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TField(
                  hintText: 'Username',
                  prefixIcon: Icons.person,
                  controller: usernameController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FormBtn(
                      text: 'Cancel',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    FormBtn(
                      text: 'Submit',
                      onTap: () {
                        Api.register(email, usernameController.text, password);
                        Navigator.pushReplacementNamed(context, HomeView.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
