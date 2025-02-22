import 'package:flutter/material.dart';
import 'package:vision_share/widgets/custom_button.dart';
import 'dart:io' show Platform;
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class OptionsScreen extends StatelessWidget {
  int _selectedIndex = 1;

  Future<void> logoutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Options Screen')),
      body: Center(
        child: CustomButton(
          text: "LOGOUT →",
          onPressed: () => logoutUser(context),
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
                      tileColor: Colors.amberAccent[100],
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
                      onTap: () {
                        // Handle navigation to Features
                      },
                    ),
                  ],
                ),
              )
              : null,
    );
  }
}
