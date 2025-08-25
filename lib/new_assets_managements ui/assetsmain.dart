
import 'package:ecosoulquerytracker/new_assets_managements%20ui/screens/assets_list.dart';
import 'package:ecosoulquerytracker/new_assets_managements%20ui/screens/dash.dart';
import 'package:ecosoulquerytracker/new_assets_managements%20ui/screens/report.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/login_screen.dart';



class AssetManagementMain extends StatefulWidget {
  const AssetManagementMain({super.key});

  @override
  State<AssetManagementMain> createState() => _AssetManagementMainState();
}

class _AssetManagementMainState extends State<AssetManagementMain> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardPage(),
    AssetListPage(),
    SettingsPage(),
    ReportsPage(),
  ];

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔹 Fixed Top Bar
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side Logo + Title
                Row(
                  children: const [
                    Icon(Icons.security, color: Colors.blue, size: 28),
                    SizedBox(width: 8),
                    Text(
                      "Asset Management",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Right Side Menu
                Row(
                  children: [
                    menuButton(Icons.dashboard, "Dashboard", 0),
                    menuButton(Icons.list_alt, "Asset List", 1),
                    menuButton(Icons.settings, "Settings", 2),
                    menuButton(Icons.description, "Reports", 3),
                    const VerticalDivider(width: 20, thickness: 1),
                    menuButton(Icons.arrow_back, "Back to Portal", -1,onPressed: () => Navigator.of(context).pop()),
                    menuButton(Icons.logout, "Logout", -2,onPressed:() async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                            (route) => false,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),

          // 🔹 Page Content
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: pages,
            ),
          ),
        ],
      ),
    );
  }

  Widget menuButton(IconData icon, String label, int index,
      {Function? onPressed}) {
    bool isActive = index == selectedIndex;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: isActive ? Colors.blue.shade50 : Colors.transparent,
          foregroundColor: isActive ? Colors.blue : Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onPressed: () {
          if(onPressed!= null){
            onPressed();
          }
          if (index >= 0) {
            changePage(index);
          } else {
            // TODO: handle back or logout
          }
        },
        icon: Icon(icon, size: 18),
        label: Text(label),
      ),
    );
  }
}

// 🔹 Different Pages
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child:
    // Text("📊 Dashboard Page")

    Assets_DashboardScreen(),
    );
  }
}

class AssetListPage extends StatelessWidget {
  const AssetListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child:

    AssetListScreen(),

      //Text("📋 Asset List Page")

    );


  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child:
   // ReportsDashboard(),
      Text("⚙️ Settings Page Coming Soon")
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return  Center(child:
    ReportsDashboard(),
    //Text("📑 Reports Page")

    );
  }
}
