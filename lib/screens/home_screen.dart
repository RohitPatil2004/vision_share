import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'options_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),
      body: Center(child: Text('Welcome to the Home Screen!')),
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
