import 'package:chat_flutter/pages/DashboardPage/dashboard_page.dart';
import 'package:chat_flutter/pages/LoginPage/login_page.dart';
import 'package:chat_flutter/pages/RegisterPage/register_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006492)),
        useMaterial3: true,
      ),
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        DashboardPage.id: (context) => const DashboardPage()
      },
    );
  }
}
