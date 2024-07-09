import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final DatabaseReference _roomsReference =
      FirebaseDatabase.instance.ref().child('rooms');
  final TextEditingController _roomController = TextEditingController();

  void _deleteRoom(String key) {
    _roomsReference.child(key).remove();
  }

  void _addRoom() {
    String roomName = _roomController.text;
    if (roomName.isNotEmpty) {
      _roomsReference.push().set({
        'name': roomName,
        'booked': false,
      });
      _roomController.clear();
    }
  }

  void _emptyRoom(String key) {
    _roomsReference.child(key).update({'booked': false});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        backgroundColor: Colors.orange,
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
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      rooms[index]['name'],
                      style: TextStyle(
                        color: Color(0xFF154360),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: rooms[index]['booked']
                        ? Text(
                            'Booked by: ${rooms[index]['nama']} (${rooms[index]['nim']})',
                            style: TextStyle(color: Colors.redAccent),
                          )
                        : Text(
                            'Available',
                            style: TextStyle(color: Colors.green),
                          ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (rooms[index]['booked'])
                          IconButton(
                            icon: Icon(Icons.cancel, color: Colors.redAccent),
                            onPressed: () {
                              _emptyRoom(rooms[index]['key']);
                            },
                          ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteRoom(rooms[index]['key']);
                          },
                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Tambah Ruangan'),
              content: TextField(
                controller: _roomController,
                decoration: InputDecoration(
                  labelText: 'Nama Ruangan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
                    _addRoom();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text('Simpan'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
