import 'package:flutter/material.dart';
import 'package:Pemesanan_Ruang/report_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Aplikasi Pemesanan Ruang Studi',
    theme: ThemeData(
      primaryColor: Colors.orange,
      hintColor: Colors.deepOrange,
      scaffoldBackgroundColor: Color.fromARGB(255, 23, 90, 145),
      fontFamily: 'Roboto',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepOrange,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.deepOrange,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.deepOrange),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrange, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    home: LoginPage(),
  ));
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              style: TextStyle(
                  color: const Color.fromARGB(
                      255, 255, 255, 255)), // Ubah warna teks yang dimasukkan
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(
                    color: const Color.fromARGB(
                        255, 255, 255, 255)), // Ubah warna label
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: const Color.fromARGB(
                        255, 255, 255, 255)), // Ubah warna label
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LaporPage()),
                );
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white), // Ubah warna teks tombol
              ),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                'Belum punya akun? Daftar disini',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(
                    color: const Color.fromARGB(
                        255, 255, 255, 255)), // Ubah warna label
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: const Color.fromARGB(
                        255, 255, 255, 255)), // Ubah warna label
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(
                    color: const Color.fromARGB(
                        255, 255, 254, 254)), // Ubah warna label
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk registrasi di sini
                // Setelah registrasi, Anda dapat mengarahkan kembali pengguna ke halaman login
                Navigator.pop(
                    context); // Mengarahkan kembali ke halaman sebelumnya (halaman login)
              },
              child: Text(
                'Registrasi',
                style: TextStyle(color: Colors.white), // Ubah warna teks tombol
              ),
            ),
          ],
        ),
      ),
    );
  }
}
