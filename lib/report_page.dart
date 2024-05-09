import 'package:flutter/material.dart';
import 'package:Pemesanan_Ruang/pesan.dart';

void main() {
  runApp(MaterialApp(
    title: 'Pemesanan Ruang Studi',
    theme: ThemeData(
      primaryColor: Colors.blue,
      hintColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
      ),
    ),
    home: LaporPage(),
  ));
}

class LaporPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PesanRuang'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Aplikasi Pemesanan Ruang Studi. Klik tombol dibawah ini untuk memesan Ruang Studi.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0,color: Colors.white),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListLaporPage()),
                );
              },
              child: Text('Pemesanan Ruang Studi'),
            ),
          ],
        ),
      ),
    );
  }
}
