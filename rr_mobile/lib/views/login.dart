import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rr_mobile/models/api.dart';
import 'package:rr_mobile/models/persistance.dart';
import 'package:rr_mobile/views/username.dart';
import 'package:rr_mobile/widgets/page.dart';

class LoginView extends HookConsumerWidget {
  static const String id = '/login';

  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final pwController = useTextEditingController();
    emailController.text = "john_doe@example.com";
    pwController.text = "password123";

    return RPage(
      children: [
        Center(
          child: Container(
            height: 300,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.9),
              // color: const Color(0xFF17779A).withOpacity(.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TField(
                    hintText: 'Email',
                    prefixIcon: Icons.person,
                    controller: emailController),
                const SizedBox(height: 20),
                TField(
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                    controller: pwController),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FormBtn(
                        text: 'Login',
                        onTap: () {
                          // First, make a request to sqflite to check for sessions
                          // If there is a session, then navigate to home
                          // If there is no session, then navigate to login
                          Pers.db.then((db) {
                            Pers.getSession().then((session) {
                              if (session != null) {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              }
                            });
                          });

                          // Next, make a request to the API to check if a user
                          // exists with the given username and password
                          // If the user exists, then navigate to home
                          // If the user does not exist, then navigate to login
                          Api.login(emailController.text, pwController.text)
                              .then((session) {
                            if (session != null) {
                              Navigator.pushNamed(context, '/');
                            }
                          });

                          Navigator.pushNamed(context, '/error');
                        }),
                    FormBtn(
                      text: 'Register',
                      onTap: () => Navigator.pushNamed(context, '/username',
                          arguments:
                              UVArgs(emailController.text, pwController.text)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FormBtn extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const FormBtn({required this.text, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: mq.size.width * .35,
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.9),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: const Offset(2, 2),
              blurRadius: 3,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}

class TField extends ConsumerWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;

  TField({
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    super.key,
  });

  final confirmationProvider = StateProvider.autoDispose<bool>((ref) => false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confirmed = ref.watch(confirmationProvider);

    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.8),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: const Offset(2, 2),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ]
          // border: Border.all(color: Colors.black.withOpacity(.1)),
          ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: hintText,
          hintText: hintText,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          prefixIcon: Icon(prefixIcon),
          suffixIcon:
              confirmed ? const Icon(Icons.check) : const Icon(Icons.clear),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onChanged: (value) {
          // Do something with the value entered in the TextField
        },
      ),
    );
  }
}
