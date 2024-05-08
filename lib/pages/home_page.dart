import 'package:circule_game/pages/game_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/home.png'),
                )),
              ),
              _buildButton(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GamePage(),
                  ),
                ),
                bgColor: Colors.green,
                title: 'Start Game',
              ),
              _buildButton(
                onTap: () => showAboutDialog(context),
                bgColor: Colors.orangeAccent,
                title: 'How to play',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAboutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(
          "How to play",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Close",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
        content: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 24),
              child: Image.asset('assets/images/home.png'),
            ),
            const Text(
              "Use your swipe left or right, up or down to move the tiles. When two tiles with the same number touch, they merge into one.\n"
                  "Join the same polygons until you get the circle.\n\nWhat are you waiting for, start playing now.\n\n\n\n"
                  "Version: 1.1.0",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      {required Color bgColor,
      required Function() onTap,
      required String title}) {
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        width: 200,
        height: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bgColor,
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
