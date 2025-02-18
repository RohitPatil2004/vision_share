import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'home_screen.dart';

class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Options Screen')),
      body: Center(child: Text('Welcome to the Options Screen!')),
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
                    backgroundColor: Colors.amberAccent[100],
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.featured_play_list),
                    label: 'Features',
                  ),
                ],
                onTap: (index) {
                  // Handle navigation based on the selected index
                  // You can use Navigator.push or any other navigation method
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
              : null, // No bottom navigation for desktop
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
                      tileColor: Colors.amberAccent[100],
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
                      onTap: () {
                        // Handle navigation to Features
                      },
                    ),
                  ],
                ),
              )
              : null, // No drawer for mobile
    );
  }
}
