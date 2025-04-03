import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RDP/RDP_connection_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _createRoom() async {
    String? uniqueId = await _fetchUniqueId();
    if (uniqueId != null) {
      _idController.text = uniqueId; // Set the unique ID in the text field
      _idController.selection = TextSelection.fromPosition(TextPosition(offset: uniqueId.length)); // Move cursor to the end
      setState(() {
        // Disable the text field
      });
    }
  }

  Future<void> _joinRoom() async {
    String inputId = _idController.text.trim();
    if (inputId.isEmpty) {
      _showAlert(context, 'Please enter a valid Connection ID');
      return;
    }

    // Check if the unique ID exists in Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('IDS')
        .where('uniqueId', isEqualTo: inputId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Navigate to RDPConnectionScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RDPConnectionScreen(uniqueId: inputId)),
      );
    } else {
      _showAlert(context, 'No matching ID found.');
    }
  }

  Future<String?> _fetchUniqueId() async {
    User? user = FirebaseAuth.instance.currentUser ;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('IDS')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        return snapshot['uniqueId'];
      }
    }
    return null;
  }

  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('RESULT'),
          content: Text(message),
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
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _idController,
              readOnly: false, // Disable text field
              decoration: InputDecoration(
                hintText: 'Unique ID will appear here',
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
 SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createRoom,
              child: Text("Create Room"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.amberAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _joinRoom,
              child: Text("Join Room"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.amberAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Hang up logic (if needed)
              },
              child: Text("Hang Up"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.amberAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}