import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
