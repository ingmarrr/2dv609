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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Color.fromARGB(255, 91, 116, 164),
                // border: Border.all(
                //   color: Colors.grey,
                //   width: .5,
                // ),
                // color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
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
                  const SizedBox(height: 10),
                  InkWell(
                    child: const Text(
                      "Create Account.",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/username',
                      arguments:
                          UVArgs(emailController.text, pwController.text),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: FormBtn(
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

                              Navigator.pushNamed(context, '/unimplemented');
                            }),
                      ),
                      // const SizedBox(width: 10),
                      // Expanded(
                      //   child: FormBtn(
                      //     text: "Cancel",
                      //     onTap: () => Navigator.of(context).pop(),
                      //   ),
                      // )
                      // FormBtn(
                      //   text: 'Register',
                      //   onTap: () => Navigator.pushNamed(
                      //     context,
                      //     '/username',
                      //     arguments:
                      //         UVArgs(emailController.text, pwController.text),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 13),
        decoration: BoxDecoration(
          // color: Colors.white.withOpacity(.9),
          border: Border.all(
            color: Colors.black.withOpacity(0.5),
            width: .5,
          ),
          // borderRadius: BorderRadius.circular(5),
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
        // borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: confirmed ? Colors.green : Colors.black.withOpacity(0.5),
          width: .5,
        ),
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
