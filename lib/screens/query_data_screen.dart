//
// import 'package:ecosoulquerytracker/screens/query_form_new_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class QueryDataScreen extends StatefulWidget {
//   final String selectedCategory;
//
//   const QueryDataScreen({Key? key, required this.selectedCategory})
//     : super(key: key);
//
//   @override
//   _QueryDataScreenState createState() => _QueryDataScreenState();
// }
//
// class _QueryDataScreenState extends State<QueryDataScreen> {
//   final Dio _dio = Dio();
//   List<Map<String, dynamic>> _queries = [];
//   bool _isLoading = true;
//   String _errorMessage = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }
//
//   @override
//   void didUpdateWidget(QueryDataScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.selectedCategory != widget.selectedCategory) {
//       _fetchData();
//     }
//   }
//
//   Future<void> _fetchData() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//
//     try {
//       final response = await _dio.get('https://thriveworklytics.thrivebrands.ai/api/data');
//
//       if (response.statusCode == 200) {
//         List<dynamic> data = response.data;
//         List<Map<String, dynamic>> allQueries = List<Map<String, dynamic>>.from(
//           data,
//         );
//
//         String filterCategory = '';
//         switch (widget.selectedCategory) {
//           case 'Kinetica UK':
//             filterCategory = 'Kinetica Sports - UK';
//             break;
//           case 'Kinetica Germany':
//             filterCategory = 'Kinetica Sports - Germany';
//             break;
//           case 'Kinetica UAE':
//             filterCategory = 'Kinetica Sports - UAE';
//             break;
//           case 'Kinetica Website':
//             filterCategory = 'Kinetica Sports - Website';
//             break;
//           case 'Overview':
//             filterCategory = '';
//             break;
//           default:
//             filterCategory = '';
//         }
//
//         setState(() {
//           _queries =
//               filterCategory.isEmpty
//                   ? allQueries
//                   : allQueries
//                       .where((query) => query['Category'] == filterCategory)
//                       .toList();
//           _isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error loading data: ${e.toString()}';
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _deleteQuery(String registrationId) async {
//     try {
//       final response = await Dio().delete(
//         'https://thriveworklytics.thrivebrands.ai/api/delete-query/$registrationId',
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );
//
//       if (response.statusCode == 200) {
//         Fluttertoast.showToast(
//           msg: "Query deleted successfully",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//         );
//         _fetchData(); // Refresh data after delete
//       } else {
//         throw Exception('Failed to delete query: ${response.statusCode}');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Delete error: ${e.toString()}",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : _errorMessage.isNotEmpty
//               ? Center(child: Text(_errorMessage))
//               : Padding(
//                 padding: const EdgeInsets.all(25.0),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minWidth: MediaQuery.of(context).size.width,
//                     ),
//                     child: DataTable(
//                       columnSpacing: 12,
//                       horizontalMargin: 12,
//                       columns: const [
//                         DataColumn(label: Text('Platform')),
//                         DataColumn(label: Text('Category')),
//                         DataColumn(label: Text('Project')),
//                         DataColumn(label: Text('Task')),
//                         DataColumn(label: Text('Status')),
//                         DataColumn(label: Text('Start Date')),
//                         DataColumn(label: Text('End Date')),
//                         DataColumn(label: Text('Days')),
//                         DataColumn(label: Text('Actions')),
//                       ],
//                       rows:
//                           _queries.isEmpty
//                               ? [
//                                 DataRow(
//                                   cells: List.generate(
//                                     9,
//                                     (index) => DataCell(
//                                       index == 0
//                                           ? Text(
//                                             'No data available',
//                                             style: TextStyle(
//                                               fontStyle: FontStyle.italic,
//                                             ),
//                                           )
//                                           : const SizedBox.shrink(),
//                                     ),
//                                   ),
//                                 ),
//                               ]
//                               : _queries.map((query) {
//                                 return DataRow(
//                                   cells: [
//                                     DataCell(Text(query['Platform'] ?? '')),
//                                     DataCell(Text(query['Category'] ?? '')),
//                                     DataCell(Text(query['Project'] ?? '')),
//                                     DataCell(Text(query['Task'] ?? '')),
//                                     DataCell(
//                                       Container(
//                                         padding: const EdgeInsets.all(6),
//                                         decoration: BoxDecoration(
//                                           color: _getStatusColor(
//                                             query['Task Status'],
//                                           ),
//                                           borderRadius: BorderRadius.circular(4),
//                                         ),
//                                         child: Text(
//                                           query['Task Status'] ?? '',
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     DataCell(
//                                       Text(query['Project Start date'] ?? ''),
//                                     ),
//                                     DataCell(
//                                       Text(
//                                         query['Project Expected End date'] ?? '',
//                                       ),
//                                     ),
//                                     DataCell(
//                                       Text(query['No. of Days required'] ?? ''),
//                                     ),
//                                     DataCell(
//                                       Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           IconButton(
//                                             icon: const Icon(
//                                               Icons.edit,
//                                               color: Colors.blue,
//                                             ),
//                                             onPressed: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder:
//                                                       (context) =>
//                                                           RegistrationFormUpdated(
//                                                             existingData: query,
//                                                           ),
//                                                 ),
//                                               ).then((_) => _fetchData());
//                                             },
//                                           ),
//                                           IconButton(
//                                             icon: const Icon(
//                                               Icons.delete,
//                                               color: Colors.red,
//                                             ),
//                                             onPressed: () {
//                                               showDialog(
//                                                 context: context,
//                                                 builder:
//                                                     (context) => AlertDialog(
//                                                       title: const Text(
//                                                         'Confirm Delete',
//                                                       ),
//                                                       content: const Text(
//                                                         'Are you sure you want to delete this query?',
//                                                       ),
//                                                       actions: [
//                                                         TextButton(
//                                                           onPressed:
//                                                               () => Navigator.pop(
//                                                                 context,
//                                                               ), // Cancel
//                                                           child: const Text(
//                                                             'Cancel',
//                                                           ),
//                                                         ),
//                                                         TextButton(
//                                                           onPressed: () {
//                                                             Navigator.pop(
//                                                               context,
//                                                             ); // Close dialog
//                                                             _deleteQuery(
//                                                               query['registrationId'],
//                                                             ); // 👈 Call delete
//                                                           },
//                                                           child: const Text(
//                                                             'Delete',
//                                                             style: TextStyle(
//                                                               color: Colors.red,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                               );
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//     );
//   }
//
//   Color _getStatusColor(String? status) {
//     switch (status) {
//       case 'Not Started':
//         return Colors.grey;
//       case 'Ongoing':
//         return Colors.orange;
//       case 'In Progress':
//         return Colors.blue;
//       case 'Delivered':
//         return Colors.green;
//       case 'On Hold':
//         return Colors.red;
//       case 'Closed':
//         return Colors.purple;
//       default:
//         return Colors.grey;
//     }
//   }
// }


import 'dart:convert';

import 'package:ecosoulquerytracker/screens/query_form_new_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QueryDataScreen extends StatefulWidget {
  final String selectedCategory;

  const QueryDataScreen({super.key, required this.selectedCategory});

  @override
  _QueryDataScreenState createState() => _QueryDataScreenState();
}

class _QueryDataScreenState extends State<QueryDataScreen> {
  final Dio _dio = Dio();
  List<Map<String, dynamic>> _queries = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(QueryDataScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      var dio = Dio();
      var response = await dio.request(
        'https://thriveworklytics.thrivebrands.ai/api/data',
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        print("Fetched Data: ${json.encode(response.data)}");

        List<dynamic> data = response.data;
        List<Map<String, dynamic>> allQueries =
        List<Map<String, dynamic>>.from(data);

        String filterCategory = '';
        switch (widget.selectedCategory) {
          case 'Kinetica UK':
            filterCategory = 'Kinetica Sports - UK';
            break;
          case 'Kinetica Germany':
            filterCategory = 'Kinetica Sports - Germany';
            break;
          case 'Kinetica UAE':
            filterCategory = 'Kinetica Sports - UAE';
            break;
          case 'Kinetica Website':
            filterCategory = 'Kinetica Sports - Website';
            break;
          case 'Overview':
            filterCategory = '';
            break;
          default:
            filterCategory = '';
        }

        setState(() {
          _queries = filterCategory.isEmpty
              ? allQueries
              : allQueries
              .where((query) =>
          query['Category']?.toString().trim() == filterCategory)
              .toList();
          _isLoading = false;
        });
      } else {
        print("Fetch failed: ${response.statusMessage}");
        throw Exception('Failed to load data: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      print('Fetch Error: $e');
      print('StackTrace: $stackTrace');
      setState(() {
        _errorMessage = 'Error loading data: ${e.toString()}';
        _isLoading = false;
      });
    }
  }


  Future<void> _deleteQuery(String registrationId) async {
    try {
      final response = await Dio().delete(
        'https://thriveworklytics.thrivebrands.ai/api/delete-query/$registrationId',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        print("Delete Success: ${response.data}");
        Fluttertoast.showToast(
          msg: "Query deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        _fetchData(); // Refresh data after delete
      } else {
        throw Exception('Failed to delete query: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Delete Error: $e');
      print('StackTrace: $stackTrace');
      Fluttertoast.showToast(
        msg: "Delete error: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: DataTable(
              columnSpacing: 12,
              horizontalMargin: 12,
              columns: const [
                DataColumn(label: Text('Platform')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Project')),
                DataColumn(label: Text('Task')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Start Date')),
                DataColumn(label: Text('End Date')),
                DataColumn(label: Text('Days')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _queries.isEmpty
                  ? [
                DataRow(
                  cells: List.generate(
                    9,
                        (index) => DataCell(
                      index == 0
                          ? Text(
                        'No data available',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ]
                  : _queries.map((query) {
                return DataRow(
                  cells: [
                    DataCell(Text(query['Platform'] ?? '')),
                    DataCell(Text(query['Category'] ?? '')),
                    DataCell(Text(query['Project'] ?? '')),
                    DataCell(Text(query['Task'] ?? '')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                          _getStatusColor(query['Task Status']),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          query['Task Status'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(query['Project Start date'] ?? '')),
                    DataCell(
                        Text(query['Project Expected End date'] ?? '')),
                    DataCell(Text(query['No. of Days required'] ?? '')),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RegistrationFormUpdated(
                                        existingData: query,
                                      ),
                                ),
                              ).then((_) => _fetchData());
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                      'Are you sure you want to delete this query?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteQuery(query[
                                        'registrationId']);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Not Started':
        return Colors.grey;
      case 'Ongoing':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      case 'On Hold':
        return Colors.red;
      case 'Closed':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

