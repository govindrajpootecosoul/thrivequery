

import 'package:ecosoulquerytracker/screens/Tabscreen/DashboardScreen.dart';
import 'package:ecosoulquerytracker/screens/Tabscreen/ProfileScreen.dart';
import 'package:ecosoulquerytracker/screens/adminpanel.dart';
import 'package:ecosoulquerytracker/screens/dashbord_graph.dart';
import 'package:ecosoulquerytracker/screens/login_screen.dart';
import 'package:ecosoulquerytracker/screens/query_form_screen.dart';
import 'package:ecosoulquerytracker/screens/query_list_screen.dart';
import 'package:ecosoulquerytracker/screens/reports/reportsscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../addnew_screen/select_department.dart';



class Brillo_screen extends StatefulWidget {
  const Brillo_screen({super.key});

  @override
  State<Brillo_screen> createState() => _Brillo_screenState();
}

class _Brillo_screenState extends State<Brillo_screen> {



  int selectedIndex = 1; // All Queries selected by default

  final List<String> menuItems = [
    'Overview',
    'Brillo Amazon',
    'Brillo Website',
    'Add Queries',

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
        return DashboardGraphScreen();
    // return DashboardScreen();
      case 2:
        return  RegistrationForm();
      case 3:
        return RegistrationForm();
    // case 3:
    //   return ReportsScreen();
    //   case 3:
    //     return AdminPanel();
    //   case 4:
    //     return ProfileScreen();

    //    Brillo_screen(),
    //     DashboardScreen(),
    //     QueryListScreen(),
    //     RegistrationForm(),
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
            image: AssetImage('assets/tWeb.png'),
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
                      text: 'LOGGED USER NAME  |  Platform: ',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: platformname.toString(),
                          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.normal),
                        ),
                        // TextSpan(
                        //   text: 'Admin > ${menuItems[selectedIndex]}',
                        //   style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.normal),
                        // ),
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const DepartmentSelectionScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Select Platform',style: TextStyle(color: Colors.white),),
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
            const SizedBox(height: 70),
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
                  child: Text(menuItems[index],style: TextStyle(color: Colors.white),),
                );
              }),
            ),
            const SizedBox(height: 40),
            Expanded(child: getSelectedScreen()),
            //const SizedBox(height: 190),
          ],
        ),
      ),
    );


  }
}
