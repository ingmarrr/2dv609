import 'package:flutter/material.dart';
import 'package:rr_mobile/views/download.dart';
import 'package:rr_mobile/views/home.dart';
import 'package:rr_mobile/views/login.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Container(
      height: 60,
      width: mq.size.width - 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, HomeView.id),
          ),
          IconButton(
            icon: const Icon(Icons.storage),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, DownloadView.id),
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () => Navigator.pushNamed(context, "/unimplemented"),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, LoginView.id),
          ),
        ],
      ),
    );
  }
}
