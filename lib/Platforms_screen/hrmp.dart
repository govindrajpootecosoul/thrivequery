import 'package:flutter/material.dart';
import '../screens/hrms_screens/List_new_assets.dart';
import '../screens/hrms_screens/Recruitments.dart';
import '../screens/hrms_screens/add_new_assets.dart';
import '../screens/hrms_screens/hrms_Dashboard_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;
  bool isDrawerCollapsed = false;

  final List<Widget> screens = [
    HrmsDashboardScreen(),
    AllAssetsListScreen(),
    //AllAssetsListScreenImproved(),
    AddNewAssetScreen(),
    SalesDashboardChart(),
    // Text("Administration"),
    Text("Reports"),
    Text("Back To Select Dept."),
  ];

  final List<String> menuTitles = [
    'Dashboard',
    'List of Assets',
    'Add New Assets',
    'Administration',
    'Reports',
    'Back To Select Dept.'
  ];

  final List<IconData> menuIcons = [
    Icons.bar_chart,
    Icons.apps,
    Icons.add,
    Icons.notifications,
    //Icons.person,
    Icons.layers,
    Icons.settings,
  ];

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget buildDrawer() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isDrawerCollapsed ? 70 : 250,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1C2D32), Color(0xFF0B1315)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                isDrawerCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isDrawerCollapsed = !isDrawerCollapsed;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: menuTitles.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: GestureDetector(
                    onTap: () => onItemTap(index),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      child: Row(
                        children: [
                          Icon(
                            menuIcons[index % menuIcons.length],
                            color: isSelected ? Colors.amber.shade800 : Colors.white,
                          ),
                          if (!isDrawerCollapsed) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                menuTitles[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          buildDrawer(),
          Expanded(child: screens[selectedIndex]),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../screens/hrms_screens/List_new_assets.dart';
// import '../screens/hrms_screens/Recruitments.dart';
// import '../screens/hrms_screens/add_new_assets.dart';
// import '../screens/hrms_screens/hrms_Dashboard_screen.dart';
//
// // class EditAssetNotifier extends ChangeNotifier {
// //   Map<String, dynamic>? assetData;
// //   bool isEdit = false;
// //
// //   void setEditData({required Map<String, dynamic> data}) {
// //     assetData = data;
// //     isEdit = true;
// //     notifyListeners();
// //   }
// //
// //   void reset() {
// //     assetData = null;
// //     isEdit = false;
// //     notifyListeners();
// //   }
// // }
//
// class MainLayout extends StatefulWidget {
//   final int initialIndex;
//
//   const MainLayout({Key? key, this.initialIndex = 0}) : super(key: key);
//
//   @override
//   _MainLayoutState createState() => _MainLayoutState();
// }
//
// class _MainLayoutState extends State<MainLayout> {
//   late int selectedIndex;
//   bool isDrawerCollapsed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedIndex = widget.initialIndex;
//   }
//
//   Widget buildDrawer() {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: isDrawerCollapsed ? 70 : 250,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF1C2D32), Color(0xFF0B1315)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 20),
//           Align(
//             alignment: Alignment.topRight,
//             child: IconButton(
//               icon: Icon(
//                 isDrawerCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 setState(() {
//                   isDrawerCollapsed = !isDrawerCollapsed;
//                 });
//               },
//             ),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: ListView.builder(
//               itemCount: menuTitles.length,
//               itemBuilder: (context, index) {
//                 final isSelected = selectedIndex == index;
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                   child: GestureDetector(
//                     onTap: () => onItemTap(index),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       decoration: BoxDecoration(
//                         color: isSelected ? Colors.white : Colors.transparent,
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//                       child: Row(
//                         children: [
//                           Icon(
//                             menuIcons[index % menuIcons.length],
//                             color: isSelected ? Colors.amber.shade800 : Colors.white,
//                           ),
//                           if (!isDrawerCollapsed) ...[
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Text(
//                                 menuTitles[index],
//                                 style: TextStyle(
//                                   color: isSelected ? Colors.black : Colors.white,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   void onItemTap(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//   }
//
//   final List<String> menuTitles = [
//     'Dashboard',
//     'List of Assets',
//     'Add New Assets',
//     'Administration',
//     'Reports',
//     'Back To Select Dept.'
//   ];
//
//   final List<IconData> menuIcons = [
//     Icons.bar_chart,
//     Icons.apps,
//     Icons.add,
//     Icons.notifications,
//     Icons.layers,
//     Icons.settings,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final editNotifier = Provider.of<EditAssetNotifier>(context);
//
//     final List<Widget> screens = [
//       HrmsDashboardScreen(),
//       AllAssetsListScreen(),
//       AddNewAssetScreen(
//         isEdit: editNotifier.isEdit,
//         assetData: editNotifier.assetData,
//       ),
//       SalesDashboardChart(),
//       const Text("Reports"),
//       const Text("Back To Select Dept."),
//     ];
//
//     return Scaffold(
//       body: Row(
//         children: [
//           buildDrawer(),
//           Expanded(child: screens[selectedIndex]),
//         ],
//       ),
//     );
//   }
// }
//
// class MainLayoutWithIndex extends StatelessWidget {
//   final int index;
//   const MainLayoutWithIndex({Key? key, required this.index}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider.value(
//       value: Provider.of<EditAssetNotifier>(context),
//       child: MainLayout(initialIndex: index),
//     );
//   }
// }
