/*
import 'package:ecosoulquerytracker/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewDashScreen extends StatefulWidget {
  const NewDashScreen({super.key});

  @override
  State<NewDashScreen> createState() => _NewDashScreenState();
}

class _NewDashScreenState extends State<NewDashScreen> {
  int selectedIndex = 1; // All Queries selected by default

  final List<String> menuItems = [
    'Dashboard',
    'All Queries',
    'Add Queries',
    'Reports',
    'Admin Pannel',
  ];

  void onMenuTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    // You can implement screen navigation here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Web.png'),

            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 11.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'LOGGED USER NAME  |  Department: ',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: 'Admin > ${menuItems[selectedIndex]}',
                          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 52.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Select Department'),
                  ),





                  const SizedBox(width: 16),
                  Container(
                    width: 150,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8540D), Color(0xFFE8540DFF)], // dark to bright red
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "LOGOUT",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
            const SizedBox(height: 43),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(menuItems.length, (index) {
                final isSelected = selectedIndex == index;
                return ElevatedButton(
                  onPressed: () => onMenuTap(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.red : Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text(menuItems[index]),
                );
              }),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [

                  // Text(
                  Text(
                    menuItems[selectedIndex],
                    style: const TextStyle(
                      color: Colors.brown,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/


import 'package:ecosoulquerytracker/screens/login_screen.dart';
import 'package:ecosoulquerytracker/screens/query_form_screen.dart';
import 'package:ecosoulquerytracker/screens/query_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewDashScreen extends StatefulWidget {
  const NewDashScreen({super.key});

  @override
  State<NewDashScreen> createState() => _NewDashScreenState();
}

class _NewDashScreenState extends State<NewDashScreen> {
  int selectedIndex = 1; // All Queries selected by default

  final List<String> menuItems = [
    'Dashboard',
    'All Queries',
    'Add Queries',
    'Reports',
    'Admin Pannel',
  ];

  void onMenuTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget getSelectedScreen() {
    switch (selectedIndex) {
      case 1:
        return QueryListScreen();
      case 0:
        return const Center(child: Text("Dashboard Content"));
      case 2:
        return  RegistrationForm();
      case 3:
        return const Center(child: Text("Reports Content"));
      case 4:
        return const Center(child: Text("Admin Panel Content"));
      default:
        return const Center(child: Text("No Content"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Web.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 11.0),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'LOGGED USER NAME  |  Department: ',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: 'Admin > ${menuItems[selectedIndex]}',
                          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 52.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Select Department'),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 150,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8540D), Color(0xFFE8540DFF)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "LOGOUT",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 43),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(menuItems.length, (index) {
                final isSelected = selectedIndex == index;
                return ElevatedButton(
                  onPressed: () => onMenuTap(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.red : Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text(menuItems[index]),
                );
              }),
            ),
            const SizedBox(height: 20),
            Expanded(child: getSelectedScreen()),
          ],
        ),
      ),
    );
  }
}
