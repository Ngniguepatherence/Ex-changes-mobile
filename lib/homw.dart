import 'package:flutter/material.dart';
import 'package:start/screen/ads.dart';
import 'package:start/screen/verification.dart';
import 'pages/settings.dart';
import 'pages/homescreen.dart';
import 'screen/service.dart';
import 'screen/ads.dart';
import './chat/homepage.dart';
import 'pages/Annonces.dart';
import 'Todo/todo.dart';
import 'EdithProfiles/page/edit_profile_page.dart';
import 'EdithProfiles/page/profile_page.dart';

class BottomNavigationExample extends StatefulWidget {
  const BottomNavigationExample({Key? key}) : super(key: key);

  @override
  _BottomNavigationExampleState createState() =>
      _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State {
  int _selectedTab = 0;

  List _pages = [
    Center(
      child: HomeScreen(),
    ),
    Center(
      child: ToDoApp(),
    ),
    Center(
      child: ChatScreen(),
    ),
    Center(
      child: ProfilePage(),
    ),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => _changeTab(index),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Services"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
