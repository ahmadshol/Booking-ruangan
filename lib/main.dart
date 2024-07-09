// main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'admin_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pemesanan Ruang Studi',
      theme: ThemeData(
        primaryColor: Colors.orange,
        hintColor: Colors.deepOrange,
        scaffoldBackgroundColor: Color.fromARGB(255, 23, 90, 145),
        fontFamily: 'Roboto',
      ),
      home: LoginPage(),
      routes: {
        '/register': (context) => RegisterPage(),
        '/admin': (context) => AdminPage(),
        '/user': (context) => MainMenuPage(),
      },
    );
  }
}
