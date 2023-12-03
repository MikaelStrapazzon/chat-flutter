import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../DashboardPage/dashboard_page.dart';
import '../RegisterPage/register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  static String id = '/LoginPage';

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primaryContainer;
    Color secondaryColor = Theme.of(context).colorScheme.secondaryContainer;

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
                    'Semplice Moda ERP',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
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

                      http.post(
                          Uri.parse(
                              'http://192.168.0.112/SemplicePDM/login.php'),
                          body: {
                            'name': nameController.text,
                            'password': passwordController.text
                          }).then((value) {
                        if (value.body.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DashboardPage()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Name or Password is wrong')));
                        }
                      });
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
