/*
import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:flutter/foundation.dart' hide Border;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ReportsDashboard(),
  ));
}

class ReportsDashboard extends StatefulWidget {
  @override
  _ReportsDashboardState createState() => _ReportsDashboardState();
}

class _ReportsDashboardState extends State<ReportsDashboard> {
  List<Map<String, dynamic>> summaryCards = [];
  //List<String> quickFilters = ['Assets', 'Employee', 'Broken', 'Category'];
  String activeQuickFilter = 'All Categories';
  List<Map<String, dynamic>> reportCards = [];
  List<Map<String, dynamic>> allData = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var dio = Dio();
      var response = await dio.get(
          'https://thrive-assetsmanagements.onrender.com/api/assetmanagements');
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(response.data['data']);
        setState(() {
          allData = data;
          applyFilter(activeQuickFilter);
          loading = false;
        });
      } else {
        print(response.statusMessage);
      }
    } catch (e) {
      print(e);
    }
  }

  void applyFilter(String filterValue) {
    List<Map<String, dynamic>> filtered = allData;
    if (filterValue != 'All Categories') {
      filtered =
          allData.where((e) => e['Category'] == filterValue).toList();
    }

    Map<String, Map<String, dynamic>> statusInfo = {
      'Checked out': {"color": Colors.green[100], "icon": Icons.person},
      'Available': {"color": Colors.purple[100], "icon": Icons.calendar_today},
      'Broken': {"color": Colors.orange[100], "icon": Icons.group_add},
      'Under Audit': {"color": Colors.red[100], "icon": Icons.policy},
      'Default': {"color": Colors.blue[100], "icon": Icons.insert_drive_file},
    };

    int total = filtered.length;
    int assigned =
        filtered.where((e) => e['Status'] == 'Checked out').length;
    int available =
        filtered.where((e) => e['Status'] == 'Available').length;
    int broken = filtered.where((e) => e['Status'] == 'Broken').length;
    int underAudit = filtered.where((e) => e['Status'] == 'Under Audit').length;

    setState(() {
      activeQuickFilter = filterValue;
      summaryCards = [
        {
          "title": "Total Assets",
          "count": total,
          "color": statusInfo['Default']!['color'],
          "icon": statusInfo['Default']!['icon']
        },
        {
          "title": "Assigned Assets",
          "count": assigned,
          "color": statusInfo['Checked out']!['color'],
          "icon": statusInfo['Checked out']!['icon']
        },
        {
          "title": "Available Assets",
          "count": available,
          "color": statusInfo['Available']!['color'],
          "icon": statusInfo['Available']!['icon']
        },
        {
          "title": "Broken Assets",
          "count": broken,
          "color": statusInfo['Broken']!['color'],
          "icon": statusInfo['Broken']!['icon']
        },
        {
          "title": "Under Audit Assets",
          "count": underAudit,
          "color": statusInfo['Under Audit']!['color'],
          "icon": statusInfo['Under Audit']!['icon']
        },
      ];

      reportCards = [
        {
          "title": "Overall Assets Report",
          "category": "Assets",
          "records": total,
          "lastGenerated": DateTime.now().toString().split(' ')[0],
          "description": "List of all assets with details",
          "status": "Default"
        },
        {
          "title": "Assigned Assets Reports",
          "category": "Assets",
          "records": assigned,
          "lastGenerated": DateTime.now().toString().split(' ')[0],
          "description": "Complete assigned asset list",
          "status": "Checked out"
        },
        {
          "title": "Available Assets Reports",
          "category": "Assets",
          "records": available,
          "lastGenerated": DateTime.now().toString().split(' ')[0],
          "description": "Complete unassigned asset list",
          "status": "Available"
        },
        {
          "title": "Broken Assets Reports",
          "category": "Assets",
          "records": broken,
          "lastGenerated": DateTime.now().toString().split(' ')[0],
          "description": "Broken asset list with details",
          "status": "Broken"
        },
      ];
    });
  }

  void downloadExcelCSV(String type) {
    var excel = excel_pkg.Excel.createExcel();
    var sheet = excel['Report'];
    sheet.appendRow(reportCards.first.keys.toList());
    for (var report in reportCards) {
      sheet.appendRow(report.values.toList());
    }
    var fileBytes = excel.save();
    final blob = Blob([fileBytes!]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute('download', 'report.${type.toLowerCase()}')
      ..click();
    Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Map<String, Map<String, dynamic>> statusInfo = {
      'Checked out': {"color": Colors.green[50], "icon": Icons.person},
      'Available': {"color": Colors.purple[50], "icon": Icons.calendar_today},
      'Broken': {"color": Colors.orange[50], "icon": Icons.group_add},
      'Under Audit': {"color": Colors.red[50], "icon": Icons.policy},
      'Default': {"color": Colors.blue[50], "icon": Icons.insert_drive_file},
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Reports & Analytics"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Generate and download comprehensive reports for your organization",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: summaryCards.map((card) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(
                      width: 160,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: card['color'],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(card['icon'], size: 30, color: Colors.black54),
                          SizedBox(height: 10),
                          Text(card['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text("${card['count']}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              // Filters
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search reports...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: activeQuickFilter,
                    items: <String>['All Categories','Computer Assets','External Equipment','Supplies','Office Equipment']
                        .map((e) => DropdownMenuItem(child: Text(e), value: e))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) applyFilter(value);
                    },
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => downloadExcelCSV('Excel'),
                    icon: Icon(Icons.download),
                    label: Text("Excel"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => downloadExcelCSV('CSV'),
                    icon: Icon(Icons.download),
                    label: Text("CSV"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Wrap(
              //   spacing: 8,
              //   children: quickFilters.map((filter) {
              //     final isSelected = activeQuickFilter == filter;
              //     return ChoiceChip(
              //       label: Text(filter),
              //       selected: isSelected,
              //       onSelected: (selected) {
              //         applyFilter(filter);
              //       },
              //     );
              //   }).toList(),
              // ),
              SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: reportCards.map((report) {
                  final status = report['status'] ?? 'Default';
                  return ReportCard(
                      report: report,
                      color: statusInfo[status]!['color'],
                      icon: statusInfo[status]!['icon']);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  final Color color;
  final IconData icon;

  const ReportCard(
      {required this.report, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black54),
              SizedBox(width: 8),
              Text(report['title'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(report['category'], style: TextStyle(fontSize: 12)),
          ),
          SizedBox(height: 10),
          Text(report['description'], style: TextStyle(color: Colors.grey[700], fontSize: 13)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("${report['records']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text("Records", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(report['lastGenerated'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text("Last Generated", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/


import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:flutter/foundation.dart' hide Border;

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: ReportsDashboard(),
//   ));
// }

class ReportsDashboard extends StatefulWidget {
  @override
  _ReportsDashboardState createState() => _ReportsDashboardState();
}

class _ReportsDashboardState extends State<ReportsDashboard> {
  List<Map<String, dynamic>> summaryCards = [];
  String activeQuickFilter = 'All Categories';
  List<Map<String, dynamic>> reportCards = [];
  List<Map<String, dynamic>> allData = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var dio = Dio();
      var response = await dio.get(
          'https://thrive-assetsmanagements.onrender.com/api/assetmanagements');
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(response.data['data']);
        setState(() {
          allData = data;
          applyFilter(activeQuickFilter);
          loading = false;
        });
      } else {
        print(response.statusMessage);
      }
    } catch (e) {
      print(e);
    }
  }

  void applyFilter(String filterValue) {
    List<Map<String, dynamic>> filtered = allData;
    if (filterValue != 'All Categories') {
      filtered =
          allData.where((e) => e['Category'] == filterValue).toList();
    }

    Map<String, Map<String, dynamic>> statusInfo = {
      'Checked out': {"color": Colors.green[100], "icon": Icons.person},
      'Available': {"color": Colors.purple[100], "icon": Icons.calendar_today},
      'Broken': {"color": Colors.orange[100], "icon": Icons.group_add},
      'Under Audit': {"color": Colors.red[100], "icon": Icons.policy},
      'Default': {"color": Colors.blue[100], "icon": Icons.insert_drive_file},
    };

    int total = filtered.length;
    int assigned =
        filtered.where((e) => e['Status'] == 'Checked out').length;
    int available =
        filtered.where((e) => e['Status'] == 'Available').length;
    int broken = filtered.where((e) => e['Status'] == 'Broken').length;
    int underAudit = filtered.where((e) => e['Status'] == 'Under Audit').length;

    setState(() {
      activeQuickFilter = filterValue;
      summaryCards = [
        {
          "title": "Total Assets",
          "count": total,
          "color": statusInfo['Default']!['color'],
          "icon": statusInfo['Default']!['icon']
        },
        {
          "title": "Assigned Assets",
          "count": assigned,
          "color": statusInfo['Checked out']!['color'],
          "icon": statusInfo['Checked out']!['icon']
        },
        {
          "title": "Available Assets",
          "count": available,
          "color": statusInfo['Available']!['color'],
          "icon": statusInfo['Available']!['icon']
        },
        {
          "title": "Broken Assets",
          "count": broken,
          "color": statusInfo['Broken']!['color'],
          "icon": statusInfo['Broken']!['icon']
        },
        {
          "title": "Under Audit Assets",
          "count": underAudit,
          "color": statusInfo['Under Audit']!['color'],
          "icon": statusInfo['Under Audit']!['icon']
        },
      ];

      reportCards = [
        {
          "title": "Overall Assets Report",
          "category": "Assets",
          "records": total,
          "lastGenerated": DateTime.now().toString().split(' ')[0],
          "description": "List of all assets with details",
          "status": "Default"
        },
        {
          "title": "Assigned Assets Reports",
          "category": "Assets",
          "records": assigned,
          "lastGenerated": DateTime.now().toString().split(' ')[0],
          "description": "Complete assigned asset list",
          "status": "Checked out"
        },
        {
          "title": "Available Assets Reports",
          "category": "Assets",
          "records": available,
          "lastGenerated": DateTime.now().toString().split(' ')[0],
          "description": "Complete unassigned asset list",
          "status": "Available"
        },
        {
          "title": "Broken Assets Reports",
          "category": "Assets",
          "records": broken,
          "lastGenerated": DateTime.now().toString().split(' ')[0],
          "description": "Broken asset list with details",
          "status": "Broken"
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Map<String, Map<String, dynamic>> statusInfo = {
      'Checked out': {"color": Colors.green[50], "icon": Icons.person},
      'Available': {"color": Colors.purple[50], "icon": Icons.calendar_today},
      'Broken': {"color": Colors.orange[50], "icon": Icons.group_add},
      'Under Audit': {"color": Colors.red[50], "icon": Icons.policy},
      'Default': {"color": Colors.blue[50], "icon": Icons.insert_drive_file},
    };

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Reports & Analytics"),
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black,
      //   elevation: 0,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Generate and download comprehensive reports for your organization",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: summaryCards.map((card) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(
                      width: 160,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: card['color'],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(card['icon'], size: 30, color: Colors.black54),
                          SizedBox(height: 10),
                          Text(card['title'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text("${card['count']}",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              // Filters
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search reports...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: activeQuickFilter,
                    items: <String>[
                      'All Categories',
                      'Computer Assets',
                      'External Equipment',
                      'Supplies',
                      'Office Equipment'
                    ]
                        .map((e) => DropdownMenuItem(
                        child: Text(e), value: e))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) applyFilter(value);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: reportCards.map((report) {
                  final status = report['status'] ?? 'Default';
                  return ReportCard(
                      report: report,
                      color: statusInfo[status]!['color'],
                      icon: statusInfo[status]!['icon']);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  final Color color;
  final IconData icon;

  const ReportCard(
      {required this.report, required this.color, required this.icon});

  void downloadExcelCSV(Map<String, dynamic> report, String type) {
    var excel = excel_pkg.Excel.createExcel();
    var sheet = excel['Report'];
    sheet.appendRow(report.keys.toList());
    sheet.appendRow(report.values.toList());
    var fileBytes = excel.save();
    final blob = Blob([fileBytes!]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute('download', '${report['title']}.${type.toLowerCase()}')
      ..click();
    Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black54),
              SizedBox(width: 8),
              Expanded(
                  child: Text(report['title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
            ],
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(report['category'], style: TextStyle(fontSize: 12)),
          ),
          SizedBox(height: 10),
          Text(report['description'],
              style: TextStyle(color: Colors.grey[700], fontSize: 13)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("${report['records']}",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text("Records",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(report['lastGenerated'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text("Last Generated",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => downloadExcelCSV(report, 'Excel'),
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Excel"),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => downloadExcelCSV(report, 'CSV'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text("CSV"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
