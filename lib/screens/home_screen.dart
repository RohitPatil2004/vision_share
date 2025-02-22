import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;

import 'options_screen.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  int _selectedIndex = 0;

  Future<String?> _fetchUniqueId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('IDS')
              .doc(user.uid)
              .get();
      if (snapshot.exists) {
        return snapshot['uniqueId'];
      }
    }
    return null;
  }

  void _connect() {
    print('Connecting...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<String?>(
              future: _fetchUniqueId(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('No unique ID Found.'),
                  );
                } else {
                  String uniqueId = snapshot.data!;
                  String part1 =
                      uniqueId.length > 4 ? uniqueId.substring(0, 4) : uniqueId;
                  String part2 =
                      uniqueId.length > 8
                          ? uniqueId.substring(4, 8)
                          : uniqueId.substring(4);
                  String part3 =
                      uniqueId.length > 12
                          ? uniqueId.substring(8, 12)
                          : uniqueId.substring(8);

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          part1,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(width: 8), // Space between parts
                        Text(
                          part2,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(width: 8), // Space between parts
                        Text(
                          part3,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _idController,
                keyboardType: TextInputType.number,
                maxLength: 12,
                decoration: InputDecoration(
                  hintText: 'Enter ID of the system you want to connect.',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: _connect,
              child: Text(
                'Connect →',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
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
      bottomNavigationBar:
          Platform.isAndroid || Platform.isIOS
              ? BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Options',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.featured_play_list),
                    label: 'Features',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
                onTap: (index) {
                  if (index == 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }
                  if (index == 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => OptionsScreen()),
                    );
                  }
                },
              )
              : null,
      drawer:
          Platform.isMacOS || Platform.isWindows || Platform.isLinux
              ? Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      child: Text('Menu'),
                      decoration: BoxDecoration(color: Colors.blue),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      tileColor: Colors.amberAccent[100],
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Options'),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OptionsScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.featured_play_list),
                      title: Text('Features'),
                      onTap: () {},
                    ),
                  ],
                ),
              )
              : null,
    );
  }
}
