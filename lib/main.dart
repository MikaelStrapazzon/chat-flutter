import 'package:chat_flutter/pages/ChatsPage/chats_page.dart';
import 'package:chat_flutter/pages/DashboardPage/dashboard_page.dart';
import 'package:chat_flutter/pages/LoginPage/login_page.dart';
import 'package:chat_flutter/pages/RegisterPage/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xet Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006492)),
        useMaterial3: true,
      ),
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        DashboardPage.id: (context) => const DashboardPage(),
        ChatsPage.id: (context) => const ChatsPage()
      },
    );
  }
}
