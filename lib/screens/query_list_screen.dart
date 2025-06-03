// import 'dart:convert';
// import 'package:flutter/material.dart';
// import '../services/queryservice.dart';
//
// class QueryListScreen extends StatefulWidget {
//   @override
//   _QueryListScreenState createState() => _QueryListScreenState();
// }
//
// class _QueryListScreenState extends State<QueryListScreen> {
//   final queryService = QueryService();
//   List<dynamic> queryList = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }
//
//   void loadData() async {
//     var res = await queryService.getQueryList();
//     if (res != null) {
//       setState(() {
//         queryList = jsonDecode(res);
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         queryList = [];
//         isLoading = false;
//       });
//     }
//   }
//
//   void onEdit(Map<String, dynamic> query) {
//     // Navigate to edit screen or show dialog
//     print("Edit clicked for ID: ${query['id']}");
//   }
//
//   void onDelete(String id) async {
//     final confirmed = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Confirm Delete"),
//         content: Text("Are you sure you want to delete this query?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
//           TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Delete")),
//         ],
//       ),
//     );
//
//     if (confirmed == true) {
//       // Call your delete API here using the ID
//       print("Deleted ID: $id");
//       // Reload the list
//       loadData();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Query List")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : queryList.isEmpty
//           ? Center(child: Text("No queries found"))
//           : SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Container(
//           margin: EdgeInsets.all(12),
//           child: DataTable(
//             headingRowColor:
//             MaterialStateColor.resolveWith((states) => Colors.blue.shade100),
//             columnSpacing: 20,
//             columns: [
//               DataColumn(label: Text('Name')),
//               DataColumn(label: Text('Contact')),
//               DataColumn(label: Text('Email')),
//               DataColumn(label: Text('Company')),
//               DataColumn(label: Text('Location')),
//               DataColumn(label: Text('Date Received')),
//               DataColumn(label: Text('Calling Date')),
//               DataColumn(label: Text('Query')),
//               DataColumn(label: Text('Remark')),
//               DataColumn(label: Text('Status')),
//               DataColumn(label: Text('Actions')),
//             ],
//             rows: queryList.map((query) {
//               return DataRow(
//                 cells: [
//                   DataCell(Text(query['name'] ?? '')),
//                   DataCell(Text(query['contact'] ?? '')),
//                   DataCell(Text(query['email'] ?? '')),
//                   DataCell(Text(query['company'] ?? '')),
//                   DataCell(Text(query['location'] ?? '')),
//                   DataCell(Text(query['dateReceived'] ?? '')),
//                   DataCell(Text(query['callingDate'] ?? '')),
//                   DataCell(Text(query['query'] ?? '')),
//                   DataCell(Text(query['remark'] ?? '')),
//                   DataCell(Text(query['status'] ?? '')),
//                   DataCell(Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.edit, color: Colors.blue),
//                         onPressed: () => onEdit(query),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.delete, color: Colors.red),
//                         onPressed: () => onDelete(query['id']),
//                       ),
//                     ],
//                   )),
//                 ],
//                 onSelectChanged: (selected) {
//                   if (selected == true) {
//                     print(
//                         'User ID: ${query['id']}, User Type: ${query['userType']}, RegistrationId: ${query['registrationId']}');
//                   }
//                 },
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }


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
    // Navigate to edit screen or show dialog
    print("Edit clicked for ID: ${query['id']}");
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
