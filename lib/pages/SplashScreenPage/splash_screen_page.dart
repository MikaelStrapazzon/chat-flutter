import 'package:chat_flutter/pages/LoginPage/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  static String id = '/SplashScreen';

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              LoginPage(), // Substitua HomeScreen pela tela que você deseja mostrar após a splash screen
        ),
      );
    });

    return const Scaffold(
      backgroundColor: Color.fromRGBO(225, 245, 255, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/logos/splash.gif'),
            ),
            Text(
              'Xet Comunicações',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
