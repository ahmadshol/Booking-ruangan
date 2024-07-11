import 'package:Pemesanan_Ruang/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final DatabaseReference _roomsReference =
      FirebaseDatabase.instance.ref().child('rooms');
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  void _bookRoom(String key) {
    String nama = _namaController.text;
    String nim = _nimController.text;
    String tanggal = _tanggalController.text;

    if (nama.isNotEmpty && nim.isNotEmpty && tanggal.isNotEmpty) {
      _roomsReference.child(key).update({
        'booked': true,
        'nama': nama,
        'nim': nim,
        'tanggal': tanggal,
      });
      _clearControllers();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Mohon lengkapi semua kolom'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  void _clearControllers() {
    _namaController.clear();
    _nimController.clear();
    _tanggalController.clear();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan Ruangan'),
        backgroundColor: Color.fromRGBO(220, 247, 250, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _roomsReference.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data!.snapshot.value != null) {
                  Map data = snapshot.data!.snapshot.value as Map;
                  List rooms = [];
                  data.forEach(
                      (index, data) => rooms.add({"key": index, ...data}));
                  return ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            rooms[index]['name'],
                            style: TextStyle(
                              color: Color(0xFF154360),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: rooms[index]['booked']
                              ? Text('Booked',
                                  style: TextStyle(color: Colors.redAccent))
                              : Text('Available',
                                  style: TextStyle(color: Colors.green)),
                          trailing: rooms[index]['booked']
                              ? null
                              : ElevatedButton(
                                  onPressed: () {
                                    _showBookingDialog(rooms[index]['key']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: Text('Book'),
                                ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(String key) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Form'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _nimController,
                decoration: InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _tanggalController,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _tanggalController.text =
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    });
                  }
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            onPressed: () {
              _bookRoom(key);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text('Book'),
          ),
        ],
      ),
    );
  }
}

class MainMenuPage extends StatelessWidget {
  final DatabaseReference _roomsReference =
      FirebaseDatabase.instance.ref().child('rooms');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
        backgroundColor: Color.fromRGBO(220, 247, 250, 1),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Halaman Utama'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Akun Saya'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              icon: Icon(Icons.meeting_room, color: Colors.white),
              label: Text('Pesan Ruang',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookedRoomsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              icon: Icon(Icons.info, color: Colors.white),
              label: Text('Informasi Ruangan',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class BookedRoomsPage extends StatelessWidget {
  final DatabaseReference _roomsReference =
      FirebaseDatabase.instance.ref().child('rooms');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Ruangan'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: _roomsReference.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            Map data = snapshot.data!.snapshot.value as Map;
            List rooms = [];
            data.forEach((index, data) => rooms.add({"key": index, ...data}));
            List bookedRooms = rooms.where((room) => room['booked']).toList();
            return ListView.builder(
              itemCount: bookedRooms.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      bookedRooms[index]['name'],
                      style: TextStyle(
                        color: Color(0xFF154360),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nama: ${bookedRooms[index]['nama']}'),
                        Text('NIM: ${bookedRooms[index]['nim']}'),
                        Text('Tanggal: ${bookedRooms[index]['tanggal']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Akun Saya'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: ${user?.email ?? 'Tidak ada email'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'UID: ${user?.uid ?? 'Tidak ada UID'}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
