import 'package:chat_flutter/pages/ChatsPage/chats_page.dart';
import 'package:flutter/material.dart';

import '../../services/fire_auth.dart';
import '../RegisterPage/register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  static String id = '/LoginPage';

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primaryContainer;
    Color secondaryColor = Theme.of(context).colorScheme.secondaryContainer;

    void login() async {
      try {
        await FireAuth.signInUsingEmailPassword(
          email: emailController.text,
          password: passwordController.text,
        ).then((value) => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ChatsPage())));
      } on Exception catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(e.toString())));
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          stops: const [0.1, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Expanded(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/logos/logo.png'),
                    width: 120,
                  ),
                  const Text(
                    'Xet Comunicações',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a email';
                      }

                      final emailRegex = RegExp(
                          r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      login();
                    },
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            child: const Text(
              "Don't have an account? Click here to register.",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
          )
        ]),
      ),
    );
  }
}
