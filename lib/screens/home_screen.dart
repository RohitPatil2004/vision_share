import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;

import 'options_screen.dart';

class HomeScreen extends StatelessWidget {
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
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      snapshot.data!,
                      style: TextStyle(color: Colors.redAccent, fontSize: 24),
                    ),
                  );
                }
              },
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
                    backgroundColor: Colors.amberAccent[100],
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
                onTap: (index) {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }
                  if (index == 1) {
                    Navigator.push(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Options'),
                      onTap: () {
                        Navigator.push(
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
