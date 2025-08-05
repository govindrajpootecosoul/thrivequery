// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
//
// import 'action_screen.dart';
//
// class AllAssetsListScreen extends StatefulWidget {
//   const AllAssetsListScreen({super.key});
//
//   @override
//   State<AllAssetsListScreen> createState() => _AllAssetsListScreenState();
// }
//
// class _AllAssetsListScreenState extends State<AllAssetsListScreen> {
//   List<dynamic> assets = [];
//   final searchController = TextEditingController();
//
//   String? selectedAssetTag;
//   String? selectedCategory;
//   String? selectedSubCategory;
//   String? selectedLocation;
//
//   final List<String> selectedAssetIds = [];
//
//   final assetTagOptions = ['CA-DESK', 'EE-KBD'];
//   final categoryOptions = ['Computer Assets', 'External Equipment'];
//   final subCategoryOptions = ['Desktop', 'Keyboard'];
//   final locationOptions = ['Corporate', 'Jammu and Kashmir'];
//
//   final List<String> visibleKeys = [
//     "Category",
//     "Sub Category",
//     "Asset Tag ID",
//     "Site",
//     "Location",
//     "Status",
//     "Desktop Screen Brand",
//     "LCD Monitor Brand",
//     "LCD Serial Number",
//     "Bag Given",
//     "Keyboard Given",
//     "New Charger Serial No",
//     "Mouse Given",
//     "Serial No",
//     "Asset Brand",
//     "Model",
//     "Description",
//     "System Processor",
//     "Processor Generation",
//     "Device ID",
//     "Product ID",
//     "Total RAM",
//     "RAM1",
//     "RAM2",
//     "Charger Serial No",
//     "Warranty Start Date",
//     "Warranty Month",
//     "Warranty Expiration Date",
//     "Warranty Notes",
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAssets();
//   }
//
//   Future<void> fetchAssets() async {
//     final dio = Dio();
//     const String baseUrl = 'http://localhost:5300/api/assetmanagements';
//
//     try {
//       final response = await dio.get(baseUrl, queryParameters: {
//         'assetTagId': selectedAssetTag,
//         'category': selectedCategory,
//         'subCategory': selectedSubCategory,
//         'location': selectedLocation,
//         'search': searchController.text,
//       });
//
//       if (response.statusCode == 200) {
//         setState(() {
//           assets = response.data;
//           selectedAssetIds.clear();
//         });
//       }
//     } catch (e) {
//       print('Error fetching assets: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFDFDBD2),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(children: [
//           const Text(
//             "Asset Management Table",
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//
//           // Header + Search
//           Row(
//             children: [
//               const Text(
//                 "All Assets List",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: TextField(
//                   controller: searchController,
//                   onSubmitted: (_) => fetchAssets(),
//                   decoration: InputDecoration(
//                     hintText: 'Search for anything...',
//                     filled: true,
//                     fillColor: Colors.white,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.search),
//                 onPressed: fetchAssets,
//               )
//             ],
//           ),
//
//           const SizedBox(height: 10),
//
//
//
//           const SizedBox(height: 10),
//
//           // Filters
//           Wrap(
//             spacing: 10,
//             runSpacing: 8,
//             children: [
//
//               if (selectedAssetIds.isNotEmpty)
//                 PopupMenuButton<String>(
//                   onSelected: (action) {
//                     switch (action) {
//                       case 'Check in':
//                         showDialog(
//                           context: context,
//                           builder: (context) => const CheckInDialog(),
//                         );
//                         break;
//                       case 'Check out':
//                         showDialog(
//                           context: context,
//                           builder: (context) => const CheckOutDialog(),
//                         );
//                         break;
//
//                       case 'Broken':
//                         showDialog(
//                           context: context,
//                           builder: (context) => const BrokenDialog(),
//                         );
//                         break;
//
//                       case 'Audit':
//                         showDialog(
//                           context: context,
//                           builder: (context) => const BrokenDialog(),
//                         );
//                         break;
//
//                       case 'Warranty Expiring':
//                         showDialog(
//                           context: context,
//                           builder: (context) => const BrokenDialog(),
//                         );
//                         break;
//
//                       case 'Delete':
//                         showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: const Text('Confirm Deletion'),
//                             content: const Text('Are you sure you want to delete this item?'),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop(); // Close the dialog
//                                 },
//                                 child: const Text('Cancel'),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop(); // Close the dialog
//                                   // TODO: Add your deletion logic here
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red,
//                                 ),
//                                 child: const Text('Delete',style: TextStyle(color: Colors.white),),
//                               ),
//                             ],
//                           ),
//                         );
//                         break;
//
//
//                       case 'Maintenance':
//                         showDialog(
//                           context: context,
//                           builder: (context) => const RepairDialog(),
//                         );
//                         break;
//
//
//
//                       default:
//                         print('Action "$action" selected for IDs: $selectedAssetIds');
//                     }
//                   },
//
//                   itemBuilder: (BuildContext context) {
//                     final Map<String, IconData> actionItems = {
//                       'Broken': Icons.build,
//                       'Check out': Icons.logout,
//                       'Check in': Icons.login,
//                       'Audit': Icons.delete_forever,
//                       'Warranty Expiring': Icons.warning_amber_rounded,
//                       'Maintenance': Icons.settings,
//                       //'Lost / Missing': Icons.help_outline,
//                       //'Found': Icons.check_circle_outline,
//                       //'Lease': Icons.assignment,
//                       //'Lease return': Icons.assignment_return,
//                       //'Repair': Icons.settings,
//                       //'Sell': Icons.attach_money,
//                       'Delete': Icons.delete,
//                     };
//
//                     return actionItems.entries.map((entry) {
//                       return PopupMenuItem<String>(
//                         value: entry.key,
//                         child: Row(
//                           children: [
//                             Icon(entry.value, size: 20),
//                             const SizedBox(width: 10),
//                             Text(entry.key),
//                           ],
//                         ),
//                       );
//                     }).toList();
//                   },
//                   child:
//
//
//                   Container(
//                     height: 48,
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black),
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.playlist_add_check, color: Colors.black87),
//                         SizedBox(width: 8),
//                         Text("Perform Action", style: TextStyle(color: Colors.black)),
//                         Icon(Icons.arrow_drop_down, color: Colors.green),
//                       ],
//                     ),
//                   ),
//
//                 ),
//
//
//
//               _buildDropdown('Asset Tag', assetTagOptions, selectedAssetTag,
//                       (val) {
//                     setState(() => selectedAssetTag = val);
//                     fetchAssets();
//                   }),
//               _buildDropdown('Category', categoryOptions, selectedCategory,
//                       (val) {
//                     setState(() => selectedCategory = val);
//                     fetchAssets();
//                   }),
//               _buildDropdown(
//                   'Sub Category', subCategoryOptions, selectedSubCategory,
//                       (val) {
//                     setState(() => selectedSubCategory = val);
//                     fetchAssets();
//                   }),
//               _buildDropdown('Location', locationOptions, selectedLocation,
//                       (val) {
//                     setState(() => selectedLocation = val);
//                     fetchAssets();
//                   }),
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           // Table
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//               ),
//               child: assets.isEmpty
//                   ? const Center(child: Text("No assets found"))
//                   : SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   columnSpacing: 20,
//                   headingRowHeight: 50,
//                   dataRowHeight: 48,
//                   headingTextStyle: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   columns: _buildColumns(),
//                   rows: _buildRows(),
//                 ),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
//
//   Widget _buildDropdown(String label, List<String> options,
//       String? selectedValue, Function(String?) onChanged) {
//     return Stack(
//       alignment: Alignment.centerRight,
//       children: [
//         SizedBox(
//           width: 180,
//           child: DropdownButtonFormField<String>(
//             value: selectedValue,
//             isExpanded: true,
//             decoration: InputDecoration(
//               labelText: label,
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding:
//               const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               border:
//               OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             items: options
//                 .map((item) => DropdownMenuItem<String>(
//               value: item,
//               child: Text(item),
//             ))
//                 .toList(),
//             onChanged: onChanged,
//           ),
//         ),
//         if (selectedValue != null)
//           Positioned(
//             right: 4,
//             top: 4,
//             child: IconButton(
//               icon: const Icon(Icons.close, size: 18),
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//               splashRadius: 18,
//               onPressed: () => onChanged(null),
//             ),
//           ),
//       ],
//     );
//   }
//
//   List<DataColumn> _buildColumns() {
//     return [
//       const DataColumn(label: Text("Select")),
//       ...visibleKeys.map((key) => DataColumn(label: Text(key))),
//     ];
//   }
//
//   List<DataRow> _buildRows() {
//     return assets.map((asset) {
//       final rowMap = Map<String, dynamic>.from(asset);
//       final assetId = asset['id']?.toString() ?? '';
//       final isSelected = selectedAssetIds.contains(assetId);
//
//       return DataRow(
//         cells: [
//           DataCell(Checkbox(
//             value: isSelected,
//             onChanged: (checked) {
//               setState(() {
//                 if (checked == true) {
//                   selectedAssetIds.add(assetId);
//                 } else {
//                   selectedAssetIds.remove(assetId);
//                 }
//               });
//             },
//           )),
//           ...visibleKeys.map((key) {
//             final value = rowMap[key];
//             return DataCell(Text(value?.toString() ?? ""));
//           }).toList(),
//         ],
//       );
//     }).toList();
//   }
// }




import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../../Platforms_screen/hrmp.dart';
import 'action_screen.dart';
import 'add_new_assets.dart'; // <-- Import this screen

class AllAssetsListScreen extends StatefulWidget {
  const AllAssetsListScreen({super.key});

  @override
  State<AllAssetsListScreen> createState() => _AllAssetsListScreenState();
}

class _AllAssetsListScreenState extends State<AllAssetsListScreen> {
  List<dynamic> assets = [];
  final searchController = TextEditingController();

  String? selectedAssetTag;
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedLocation;

  final List<String> selectedAssetIds = [];

  final assetTagOptions = ['CA-DESK', 'EE-KBD'];
  final categoryOptions = ['Computer Assets', 'External Equipment'];
  final subCategoryOptions = ['Desktop', 'Keyboard'];
  final locationOptions = ['Corporate', 'Jammu and Kashmir'];

  final List<String> visibleKeys = [
    "Category",
    "Sub Category",
    "Asset Tag ID",
    "Site",
    "Location",
    "Status",
    "Desktop Screen Brand",
    "LCD Monitor Brand",
    "LCD Serial Number",
    "Bag Given",
    "Keyboard Given",
    "New Charger Serial No",
    "Mouse Given",
    "Serial No",
    "Asset Brand",
    "Model",
    "Description",
    "System Processor",
    "Processor Generation",
    "Device ID",
    "Product ID",
    "Total RAM",
    "RAM1",
    "RAM2",
    "Charger Serial No",
    "Warranty Start Date",
    "Warranty Month",
    "Warranty Expiration Date",
    "Warranty Notes",
  ];

  @override
  void initState() {
    super.initState();
    fetchAssets();
  }

  Future<void> fetchAssets() async {
    final dio = Dio();
    const String baseUrl = 'http://localhost:5300/api/assetmanagements';

    try {
      final response = await dio.get(baseUrl, queryParameters: {
        'assetTagId': selectedAssetTag,
        'category': selectedCategory,
        'subCategory': selectedSubCategory,
        'location': selectedLocation,
        'search': searchController.text,
      });

      if (response.statusCode == 200) {
        setState(() {
          assets = response.data;
          selectedAssetIds.clear();
        });
      }
    } catch (e) {
      print('Error fetching assets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFDBD2),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const Text(
            "Asset Management Table",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Header + Search
          Row(
            children: [
              const Text(
                "All Assets List",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: searchController,
                  onSubmitted: (_) => fetchAssets(),
                  decoration: InputDecoration(
                    hintText: 'Search for anything...',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: fetchAssets,
              )
            ],
          ),

          const SizedBox(height: 10),

          const SizedBox(height: 10),

          // Filters
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              if (selectedAssetIds.isNotEmpty)
                PopupMenuButton<String>(
                  onSelected: (action) {
                    switch (action) {
                      case 'Check in':
                        showDialog(
                          context: context,
                          builder: (context) => const CheckInDialog(),
                        );
                        break;
                      case 'Check out':
                        showDialog(
                          context: context,
                          builder: (context) => const CheckOutDialog(),
                        );
                        break;
                      case 'Broken':
                        showDialog(
                          context: context,
                          builder: (context) => const BrokenDialog(),
                        );
                        break;
                      case 'Audit':
                      case 'Warranty Expiring':
                        showDialog(
                          context: context,
                          builder: (context) => const BrokenDialog(),
                        );
                        break;
                      case 'Delete':
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text('Are you sure you want to delete this item?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // TODO: Add your deletion logic here
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text('Delete', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                        break;
                      case 'Maintenance':
                        showDialog(
                          context: context,
                          builder: (context) => const RepairDialog(),
                        );
                        break;
                      default:
                        print('Action "$action" selected for IDs: $selectedAssetIds');
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    final Map<String, IconData> actionItems = {
                      'Broken': Icons.build,
                      'Check out': Icons.logout,
                      'Check in': Icons.login,
                      'Audit': Icons.delete_forever,
                      'Warranty Expiring': Icons.warning_amber_rounded,
                      'Maintenance': Icons.settings,
                      'Delete': Icons.delete,
                    };
                    return actionItems.entries.map((entry) {
                      return PopupMenuItem<String>(
                        value: entry.key,
                        child: Row(
                          children: [
                            Icon(entry.value, size: 20),
                            const SizedBox(width: 10),
                            Text(entry.key),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.playlist_add_check, color: Colors.black87),
                        SizedBox(width: 8),
                        Text("Perform Action", style: TextStyle(color: Colors.black)),
                        Icon(Icons.arrow_drop_down, color: Colors.green),
                      ],
                    ),
                  ),
                ),

            _buildDropdown('Asset Tag', assetTagOptions, selectedAssetTag, (val) {
                  setState(() => selectedAssetTag = val);
                  fetchAssets();
                }),
              _buildDropdown('Category', categoryOptions, selectedCategory, (val) {
                setState(() => selectedCategory = val);
                fetchAssets();
              }),
              _buildDropdown('Sub Category', subCategoryOptions, selectedSubCategory, (val) {
                setState(() => selectedSubCategory = val);
                fetchAssets();
              }),
              _buildDropdown('Location', locationOptions, selectedLocation, (val) {
                setState(() => selectedLocation = val);
                fetchAssets();
              }),
            ],
          ),

          const SizedBox(height: 20),

          // Table
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: assets.isEmpty
                  ? const Center(child: Text("No assets found"))
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowHeight: 50,
                  dataRowHeight: 48,
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  columns: _buildColumns(),
                  rows: _buildRows(),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String? selectedValue, Function(String?) onChanged) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        SizedBox(
          width: 180,
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: options.map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            )).toList(),
            onChanged: onChanged,
          ),
        ),
        if (selectedValue != null)
          Positioned(
            right: 4,
            top: 4,
            child: IconButton(
              icon: const Icon(Icons.close, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 18,
              onPressed: () => onChanged(null),
            ),
          ),
      ],
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      const DataColumn(label: Text("Select")),
      ...visibleKeys.map((key) => DataColumn(label: Text(key))),
    ];
  }

  List<DataRow> _buildRows() {
    return assets.map((asset) {
      final rowMap = Map<String, dynamic>.from(asset);
      final assetId = asset['id']?.toString() ?? '';
      final isSelected = selectedAssetIds.contains(assetId);

      return DataRow(
        cells: [
          DataCell(
            Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selectedAssetIds.add(assetId);
                      } else {
                        selectedAssetIds.remove(assetId);
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    print("qwertyu:: ${rowMap}");
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => AddNewAssetScreen(
                    //       isEdit: true,
                    //       assetData: rowMap,
                    //     ),
                    //   ),
                    // );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNewAssetScreen(
                          isEdit: true,
                          assetData: rowMap,
                        ),
                      ),
                    );

                  },
                ),
// U
              ],
            ),
          ),
          // ...visibleKeys.map((key) {
          //   final value = rowMap[key];
          //   return DataCell(Text(value?.toString() ?? ""));
          // }).toList(),


          ...visibleKeys.map((key) {
            final value = rowMap[key];

            if (key == "Asset Tag ID") {
              return DataCell(
                InkWell(
                  onTap: () {
                    _showAssetDetailsDialog(context, rowMap);
                  },
                  child: Text(
                    value?.toString() ?? "",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                     // decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              );
            } else {
              return DataCell(Text(value?.toString() ?? ""));
            }
          }).toList(),




        ],
      );
    }).toList();
  }
}

void _showAssetDetailsDialog(BuildContext context, Map<String, dynamic> asset) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: const Color(0xFF1C1B29),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                asset['Asset Name'] ?? 'Asset Details',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // const SizedBox(height: 10),
              // const Text(
              //   "NOT REQUIRED",
              //   style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              // ),
              const SizedBox(height: 12),
              // SizedBox(
              //   height: 120,
              //   child: Image.network(
              //     asset['image'] ?? 'https://via.placeholder.com/150', // Replace with actual key if needed
              //     fit: BoxFit.contain,
              //   ),
              // ),
              const SizedBox(height: 20),
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(140),
                  1: FlexColumnWidth(),
                },
                children: [
                  _tableRow("Purchase Date", asset["Purchase Date"]),
                  _tableRow("Purchased from", asset["Purchased from"]),
                  _tableRow("Cost", asset["Cost"]),
                  _tableRow("Site", asset["Site"]),
                  _tableRow("Location", asset["Location"]),
                  _tableRow("Category", asset["Category"]),
                  _tableRow("Sub Category", asset["Sub Category"]),
                  _tableRow("Department", asset["Department"]),
                  _tableRow("Assigned to", asset["Assigned to"]),
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Status", style: TextStyle(color: Colors.white70)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        asset["Status"] ?? "",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ])
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () {
                            showDialog(
                          context: context,
                          builder: (context) => const CheckOutDialog(),
                        );
                    }, // Navigate to more details page if needed
                    child: const Text("Assign To"),
                  ),


                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

TableRow _tableRow(String title, dynamic value) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title, style: const TextStyle(color: Colors.white70)),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value?.toString() ?? "", style: const TextStyle(color: Colors.white)),
      ),
    ],
  );
}
