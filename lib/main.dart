import 'package:chat_flutter/pages/ChatScreenPage/chat_screen_page.dart';
import 'package:chat_flutter/pages/ChatsPage/chats_page.dart';
import 'package:chat_flutter/pages/LoginPage/login_page.dart';
import 'package:chat_flutter/pages/RegisterPage/register_page.dart';
import 'package:chat_flutter/pages/SplashScreenPage/splash_screen_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return GetMaterialApp(
      title: 'Xet Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006492)),
        useMaterial3: true,
      ),
      initialRoute: '/SplashScreen',
      getPages: [
        GetPage(name: '/SplashScreen', page: () => const SplashScreenPage()),
        GetPage(name: '/LoginPage', page: () => LoginPage()),
        GetPage(name: '/RegisterPage', page: () => RegisterPage()),
        GetPage(
            name: '/ChatScreenPage',
            page: () => const ChatScreenPage(
                  idChat: '',
                  userId: '',
                  keyChatList: '',
                  myId: '',
                )),
        GetPage(name: '/ChatsPage', page: () => const ChatsPage())
      ],
    );
  }
}
