// main.dart

import 'package:Pemesanan_Ruang/pages/home_page.dart';
import 'package:Pemesanan_Ruang/pages/login_page.dart';
import 'package:Pemesanan_Ruang/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
        primaryColor: const Color.fromRGBO(220, 247, 250, 1),
        hintColor: Color.fromRGBO(254, 254, 254, 1),
        scaffoldBackgroundColor: Color.fromRGBO(83, 215, 232, 1),
        fontFamily: 'Roboto',
      ),
      home: LoginPage(),
      routes: {
        '/register': (context) => RegisterPage(),
        '/admin': (context) => HomePage(),
        '/user': (context) => SplashScreen(),
      },
    );
  }
}
