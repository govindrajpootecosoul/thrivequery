/*


import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../services/queryservice.dart';

class QueryListScreen extends StatefulWidget {
  @override
  _QueryListScreenState createState() => _QueryListScreenState();
}

class _QueryListScreenState extends State<QueryListScreen> {
  final queryService = QueryService();
  List<dynamic> queryList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var res = await queryService.getQueryList();
    if (res != null) {
      setState(() {
        queryList = jsonDecode(res);
        isLoading = false;
      });
    } else {
      setState(() {
        queryList = [];
        isLoading = false;
      });
    }
  }

  void onEdit(Map<String, dynamic> query) {
    print("Edit clicked for ID: ${query['id']}");
  }

  void onDelete(Map<String, dynamic> query) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this query?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Delete")),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        var headers = {'Content-Type': 'application/json'};
        var data = jsonEncode({
          "id": query['id'],
          "userType": query['userType'],
          "registrationId": query['registrationId']
        });

        var dio = Dio();
        var response = await dio.request(
          'http://localhost:5100/api/delete',
          options: Options(
            method: 'DELETE',
            headers: headers,
          ),
          data: data,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted successfully")));
          loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delete failed")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loginbg.png"), // Make sure this exists
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // 🟢 Header Bar
            Container(
              padding: EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("LOGGED USER NAME | Department: Admin > All Queries",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text("LOGOUT"),
                  )
                ],
              ),
            ),

            // 🔳 Tabs
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                children: [
                  _navButton("Dashboard"),
                  _navButton("All Queries"),
                  _navButton("Add Queries"),
                  _navButton("Reports", color: Colors.red),
                  _navButton("Admin Panel"),
                ],
              ),
            ),

            // 🔲 Buttons & Filters
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text("Select Department"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text("Export Reports"),
                  ),
                ],
              ),
            ),

            // 🔳 Filter Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Wrap(
                spacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _filterButton("📊 All Queries"),
                  _filterButton("✅ Open Queries"),
                  _filterButton("🏁 Closed Queries"),
                ],
              ),
            ),

            // 🔲 Main Table
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : queryList.isEmpty
                  ? Center(child: Text("No queries found"))
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue.shade100),
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Contact')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Company')),
                      DataColumn(label: Text('Location')),
                      DataColumn(label: Text('Date Received')),
                      DataColumn(label: Text('Calling Date')),
                      DataColumn(label: Text('Query')),
                      DataColumn(label: Text('Remark')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: queryList.map((query) {
                      return DataRow(
                        cells: [
                          DataCell(Text(query['name'] ?? '')),
                          DataCell(Text(query['contact'] ?? '')),
                          DataCell(Text(query['email'] ?? '')),
                          DataCell(Text(query['company'] ?? '')),
                          DataCell(Text(query['location'] ?? '')),
                          DataCell(Text(query['dateReceived'] ?? '')),
                          DataCell(Text(query['callingDate'] ?? '')),
                          DataCell(Text(query['query'] ?? '')),
                          DataCell(Text(query['remark'] ?? '')),
                          DataCell(Text(query['status'] ?? '')),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => onEdit(query),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => onDelete(query),
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(String label, {Color color = Colors.black}) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label),
    );
  }

  Widget _filterButton(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}
*/






import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecosoulquerytracker/screens/query_form_screen.dart';
import 'package:flutter/material.dart';
import '../services/queryservice.dart';

class QueryListScreen extends StatefulWidget {
  @override
  _QueryListScreenState createState() => _QueryListScreenState();
}

class _QueryListScreenState extends State<QueryListScreen> {
  final queryService = QueryService();
  List<dynamic> queryList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var res = await queryService.getQueryList();
    if (res != null) {
      setState(() {
        queryList = jsonDecode(res);
        isLoading = false;
      });
    } else {
      setState(() {
        queryList = [];
        isLoading = false;
      });
    }
  }

  void onEdit(Map<String, dynamic> query) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationForm(existingData: query),
      ),
    );

    // Refresh list if update was made
    if (result == true) {
      loadData();
    }
  }


// At the top

  void onDelete(Map<String, dynamic> query) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this query?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Delete")),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        var headers = {'Content-Type': 'application/json'};
        var data = jsonEncode({
          "id": query['id'],
          "userType": query['userType'],
          "registrationId": query['registrationId']
        });

        var dio = Dio();
        var response = await dio.request(
          'http://localhost:5100/api/delete', // Replace with your live IP/domain if needed
          options: Options(
            method: 'DELETE',
            headers: headers,
          ),
          data: data,
        );

        if (response.statusCode == 200) {
          print('Deleted successfully: ${response.data}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted successfully")));
          loadData(); // Refresh the list
        } else {
          print("Failed: ${response.statusMessage}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delete failed")));
        }
      } catch (e) {
        print("Error deleting: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Query List")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : queryList.isEmpty
          ? Center(child: Text("No queries found"))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: EdgeInsets.all(12),
          child: DataTable(
            headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.blue.shade100),
            columnSpacing: 20,
            columns: [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Contact')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Company')),
              DataColumn(label: Text('Location')),
              DataColumn(label: Text('Date Received')),
              DataColumn(label: Text('Calling Date')),
              DataColumn(label: Text('Query')),
              DataColumn(label: Text('Remark')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: queryList.map((query) {
              return DataRow(
                cells: [
                  DataCell(Text(query['name'] ?? '')),
                  DataCell(Text(query['contact'] ?? '')),
                  DataCell(Text(query['email'] ?? '')),
                  DataCell(Text(query['company'] ?? '')),
                  DataCell(Text(query['location'] ?? '')),
                  DataCell(Text(query['dateReceived'] ?? '')),
                  DataCell(Text(query['callingDate'] ?? '')),
                  DataCell(Text(query['query'] ?? '')),
                  DataCell(Text(query['remark'] ?? '')),
                  DataCell(Text(query['status'] ?? '')),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => onEdit(query),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onDelete(query),
                      ),
                    ],
                  )),
                ],
                onSelectChanged: (selected) {
                  if (selected == true) {
                    print(
                        'User ID: ${query['id']}, User Type: ${query['userType']}, RegistrationId: ${query['registrationId']}');
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}



