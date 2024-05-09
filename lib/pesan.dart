import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Aplikasi Pemesanan Ruang Studi',
    theme: ThemeData(
      primaryColor: Colors.green,
      hintColor: Colors.greenAccent,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.green),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    home: ListLaporPage(),
  ));
}

class ListLaporPage extends StatefulWidget {
  @override
  _ListLaporPageState createState() => _ListLaporPageState();
}

class _ListLaporPageState extends State<ListLaporPage> {
  List<String> laporanList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Ruangan'),
      ),
      body: laporanList.isEmpty
          ? Center(
              child: Text(
                'Ruangan Masih Kosong.',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: laporanList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(laporanList[index]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLaporPage()),
          ).then((value) {
            if (value != null && value.isNotEmpty) {
              setState(() {
                laporanList.add(value);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}

class AddLaporPage extends StatefulWidget {
  @override
  _AddLaporPageState createState() => _AddLaporPageState();
}

class _AddLaporPageState extends State<AddLaporPage> {
  TextEditingController _namaController = TextEditingController();
  TextEditingController _nimController = TextEditingController();
  TextEditingController _lokasiController = TextEditingController();
  String? _selectedRuangan; // Variabel untuk menyimpan ruangan yang dipilih

  // Daftar pilihan ruangan
  List<String> ruanganOptions = [
    'Ruangan 1',
    'Ruangan 2',
    'Ruangan 3',
    'Ruangan 4',
    'Ruangan 5',
    'Ruangan 6',
    'Ruangan 7',
    'Ruangan 8',
    'Ruangan 9',
    'Ruangan 10',
    'Ruangan 11',
    'Ruangan 12',
  ];

  // Method untuk menampilkan messagebox
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // dialog tidak bisa ditutup dengan mengetuk di luar dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesanan Berhasil !'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Ruangan yang anda pesan tanggal: ${_lokasiController.text}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Ruangan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
                hintText: 'Masukkan nama Anda',
                labelStyle:
                    TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            TextField(
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
              controller: _nimController,
              decoration: InputDecoration(
                labelText: 'NIM',
                hintText: 'Masukkan NIM Anda',
                labelStyle:
                    TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            // Ganti TextField dengan DropdownButtonFormField untuk pilihan ruangan
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Ruangan',
                labelStyle:
                    TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
              ),
              value: _selectedRuangan,
              onChanged: (newValue) {
                setState(() {
                  _selectedRuangan = newValue;
                });
              },
              items: ruanganOptions.map((ruangan) {
                return DropdownMenuItem(
                  value: ruangan,
                  child: Text(ruangan),
                );
              }).toList(),
            ),
            TextField(
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
              controller: _lokasiController,
              decoration: InputDecoration(
                labelText: 'Tanggal',
                hintText: 'Masukkan Tanggal',
                labelStyle:
                    TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Simpan data laporan
                String laporan =
                    'Nama: ${_namaController.text}\nNIM: ${_nimController.text}\nRuangan: $_selectedRuangan\nTanggal: ${_lokasiController.text}';
                Navigator.pop(context, laporan);
                _showDialog();
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
