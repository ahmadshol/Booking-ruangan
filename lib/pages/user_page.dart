import 'package:Pemesanan_Ruang/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List rooms = [];
  List filteredRooms = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterRooms);
    _initializeNotifications();
    _checkRoomStatusPeriodically();
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _filterRooms() {
    setState(() {
      filteredRooms = rooms
          .where((room) => room['name']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _bookRoom(String key) {
    String nama = _namaController.text;
    String nim = _nimController.text;
    String tanggal = _tanggalController.text;
    String startTime = _startTimeController.text;
    String endTime = _endTimeController.text;

    if (nama.isNotEmpty &&
        nim.isNotEmpty &&
        tanggal.isNotEmpty &&
        startTime.isNotEmpty &&
        endTime.isNotEmpty) {
      _roomsReference.child(key).update({
        'booked': true,
        'nama': nama,
        'nim': nim,
        'tanggal': tanggal,
        'start_time': startTime,
        'end_time': endTime,
      });
      _clearControllers();
      _scheduleRoomReset(key, tanggal, endTime);
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
    _startTimeController.clear();
    _endTimeController.clear();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _scheduleRoomReset(String key, String tanggal, String endTime) {
    DateTime now = DateTime.now();
    DateTime endDateTime = DateTime.parse('$tanggal $endTime:00');
    Duration duration = endDateTime.difference(now);

    if (duration > Duration.zero) {
      Future.delayed(duration, () {
        _roomsReference.child(key).update({'booked': false});
      });
    }
  }

  void _checkRoomStatusPeriodically() {
    Future.delayed(Duration(minutes: 1), () {
      _roomsReference.once().then((DatabaseEvent event) {
        Map data = event.snapshot.value as Map;
        data.forEach((key, value) {
          if (value['booked'] == true) {
            DateTime now = DateTime.now();
            DateTime endDateTime =
                DateTime.parse('${value['tanggal']} ${value['end_time']}:00');
            if (now.isAfter(endDateTime)) {
              _roomsReference.child(key).update({'booked': false});
            }
          }
        });
      });
      _checkRoomStatusPeriodically();
    });
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Ruangan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _roomsReference.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data!.snapshot.value != null) {
                  Map data = snapshot.data!.snapshot.value as Map;
                  rooms = [];
                  data.forEach(
                      (index, data) => rooms.add({"key": index, ...data}));
                  filteredRooms = rooms
                      .where((room) => room['name']
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();
                  return ListView.builder(
                    itemCount: filteredRooms.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            filteredRooms[index]['name'],
                            style: TextStyle(
                              color: Color(0xFF154360),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: filteredRooms[index]['booked']
                              ? Text('Sudah Dipesan',
                                  style: TextStyle(color: Colors.redAccent))
                              : Text('Tersedia',
                                  style: TextStyle(color: Colors.green)),
                          trailing: filteredRooms[index]['booked']
                              ? null
                              : ElevatedButton(
                                  onPressed: () {
                                    _showBookingDialog(
                                        filteredRooms[index]['key']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: Text('Pesan'),
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
        title: Text('Formulir Pemesanan'),
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
              SizedBox(height: 10),
              TextField(
                controller: _startTimeController,
                decoration: InputDecoration(
                  labelText: 'Waktu Mulai',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _startTimeController.text =
                          "${pickedTime.hour}:${pickedTime.minute}";
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _endTimeController,
                decoration: InputDecoration(
                  labelText: 'Waktu Selesai',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _endTimeController.text =
                          "${pickedTime.hour}:${pickedTime.minute}";
                    });
                  }
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Batal'),
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
              backgroundColor: Colors.orange,
            ),
            child: Text('Pesan'),
          ),
        ],
      ),
    );
  }
}
