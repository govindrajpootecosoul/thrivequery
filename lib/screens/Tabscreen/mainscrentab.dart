/*

import 'package:ecosoulquerytracker/screens/Tabscreen/DashboardScreen.dart';
import 'package:ecosoulquerytracker/screens/Tabscreen/HomeScreen.dart';
import 'package:ecosoulquerytracker/screens/Tabscreen/ProfileScreen.dart';
import 'package:ecosoulquerytracker/screens/Tabscreen/QueryScreen.dart';
import 'package:flutter/material.dart';

import '../query_form_screen.dart';
import '../query_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    //HomeScreen(),
    QueryListScreen(),
    RegistrationForm(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _titles = ['Dashboard', 'Home', 'Query', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: 'Query'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
*/



import 'package:ecosoulquerytracker/screens/dash.dart';
import 'package:ecosoulquerytracker/screens/query_form_new_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecosoulquerytracker/screens/Tabscreen/DashboardScreen.dart';
import 'package:ecosoulquerytracker/screens/Tabscreen/ProfileScreen.dart';
import 'package:ecosoulquerytracker/screens/Tabscreen/QueryScreen.dart';

import '../query_form_screen.dart';
import '../query_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    NewDashScreen(),
    DashboardScreen(),
    QueryListScreen(),
    // RegistrationForm(),
    RegistrationFormUpdated()

   // ProfileScreen(),

  ];

  final List<String> _titles = [
    'Dashboard',
    'All Queries',
    'Add Query',
    'Admin Panel',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    // Implement your logout logic here
    print("User logged out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          )
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Queries'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Query'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
        ],
      ),
    );
  }
}
