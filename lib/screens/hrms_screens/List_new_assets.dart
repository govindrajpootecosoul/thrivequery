

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'add_new_assets.dart';
import 'action_screen.dart';
import 'checkIn.dart';
import 'checkIn.dart' as checkin_dialog;
import 'checkoutdialog.dart';
String? gassetId;
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


  String? employeid;


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
    const String baseUrl = 'https://thrive-assetsmanagements.onrender.com/api/assetmanagements';

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

          // Search
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
                        if (selectedAssetIds.isNotEmpty) {
                          final selectedAsset = assets.firstWhere(
                                (asset) => asset['id'].toString() == selectedAssetIds.first,
                            orElse: () => <String, dynamic>{},
                          );

                          print("✅ Selected Asset Data:");
                          selectedAsset.forEach((key, value) {
                            print("$key: $value");
                          });

                          showDialog(
                            context: context,
                            builder: (_) => checkin_dialog.CheckInDialog(assetData: selectedAsset),
                          );
                        }
                        break;



                    /*     case 'Check in':
                        showDialog(context: context, builder: (_) => const CheckInDialog());
                        break;
*/
                      // case 'Check in':
                      //   if (selectedAssetIds.isNotEmpty) {
                      //     final selectedAsset = assets.firstWhere(
                      //           (asset) => asset['id'].toString() == selectedAssetIds.first,
                      //       orElse: () => {},
                      //     );
                      //     showDialog(
                      //       context: context,
                      //       builder: (_) => CheckInDialog(assetData: selectedAsset),
                      //     );
                      //   }
                      //   break;



                      case 'Check out':
                        showDialog(context: context, builder: (_) => const CheckOutDialog());
                        break;
                      case 'Broken':
                        showDialog(context: context, builder: (_) => const BrokenDialog());
                        break;
                      case 'Maintenance':
                        showDialog(context: context, builder: (_) => const RepairDialog());
                        break;
                      case 'Delete':
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text('Are you sure you want to delete this item?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text('Delete', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                        break;
                    }
                  },
                  itemBuilder: (context) {
                    final Map<String, IconData> actions = {
                      'Broken': Icons.build,
                      'Check out': Icons.logout,
                      'Check in': Icons.login,
                      'Maintenance': Icons.settings,
                      'Delete': Icons.delete,
                    };
                    return actions.entries.map((entry) {
                      return PopupMenuItem<String>(
                        value: entry.key,
                        child: Row(
                          children: [Icon(entry.value), const SizedBox(width: 10), Text(entry.key)],
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.playlist_add_check),
                        SizedBox(width: 8),
                        Text("Perform Action"),
                        Icon(Icons.arrow_drop_down),
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

          // Table with vertical and horizontal scroll
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
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    headingRowHeight: 50,
                    dataRowHeight: 48,
                    headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    columns: _buildColumns(),
                    rows: _buildRows(),
                  ),
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
            items: options.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
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
                      print(assetId);
                      //print(isSelected);
                      checked == true ? selectedAssetIds.add(assetId) : selectedAssetIds.remove(assetId);
                    });
                  },
                ),
                // IconButton(
                //   icon: const Icon(Icons.edit, color: Colors.blue),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => AddNewAssetScreen(
                //           isEdit: true,
                //           assetData: rowMap,
                //         ),
                //       ),
                //     );
                //   },
                // ),

                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    print(assetId);
                    print("""object""");
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => AddNewAssetScreen(
                    //       isEdit: true,
                    //       assetData: rowMap,
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          ),
/*          ...visibleKeys.map((key) {
            final value = rowMap[key];
            if (key == "Asset Tag ID") {
              return DataCell(
                InkWell(
                  onTap: () => {


                    _showAssetDetailsDialog(context, rowMap)
                  },
                  child: Text(
                    value?.toString() ?? "",
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
            return DataCell(Text(value?.toString() ?? ""));
          }).toList(),*/


          ...visibleKeys.map((key) {
            final value = rowMap[key];
            if (key == "Asset Tag ID") {
              return DataCell(
                InkWell(
                  onTap: () {
                    gassetId = rowMap["id"]; // 👈 Assign to class-level variable
                    print("assetsid: $gassetId"); // 👈 Print for debugging


                    _showAssetDetailsDialog(context, rowMap);
                  },
                  child: Text(
                    value?.toString() ?? "",
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
            return DataCell(Text(value?.toString() ?? ""));
          }).toList(),



        ],
      );
    }).toList();
  }
}

void _showAssetDetailsDialog(BuildContext context, Map<String, dynamic> asset) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
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
              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
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
                  const Padding(padding: EdgeInsets.all(8.0), child: Text("Status", style: TextStyle(color: Colors.white70))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(asset["Status"] ?? "", style: const TextStyle(color: Colors.green)),
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
                    // 👉 First close current dialog
                    Navigator.pop(context);
                    // 👉 Then show the new dialog after a slight delay
                    Future.delayed(Duration(milliseconds: 100), () {
                      showDialog(
                        context: context,
                        builder: (_) => const CheckOutDialog(),
                      );
                    });
                  },
                  child: const Text("Assign To"),
                ),
              ],
            )



            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
            //     const SizedBox(width: 10),
            //     ElevatedButton(
            //       style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            //       onPressed: () => showDialog(context: context, builder: (_) => const CheckOutDialog()),
            //       child: const Text("Assign To"),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    ),
  );
}

TableRow _tableRow(String title, dynamic value) {
  return TableRow(
    children: [
      Padding(padding: const EdgeInsets.all(8.0), child: Text(title, style: const TextStyle(color: Colors.white70))),
      Padding(padding: const EdgeInsets.all(8.0), child: Text(value?.toString() ?? "", style: const TextStyle(color: Colors.white))),
    ],
  );
}
