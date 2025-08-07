import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:ecosoulquerytracker/api_config.dart';
import 'package:ecosoulquerytracker/screens/query_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../services/queryservice.dart';

class QueryListScreen extends StatefulWidget {
  const QueryListScreen({super.key});

  @override
  _QueryListScreenState createState() => _QueryListScreenState();
}

class _QueryListScreenState extends State<QueryListScreen> {
  final queryService = QueryService();
  List<dynamic> queryList = [];
  bool isLoading = true;

  String? selectedSearch;
  String? selectedStatus;
  String? selectedCustomer;
  String? selectedAssignedTo;

  TextEditingController searchController = TextEditingController();

  List<String> statusOptions = ['open', 'close', 'inprogress'];
  List<String> customerNames = [];
  List<Map<String, String>> _users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchCustomerNames();
    loadData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchUsers() async {
    try {
      var response = await Dio().get(ApiConfig.users_list);
      if (response.statusCode == 200) {
        final List<dynamic> userList = response.data['users'];
        setState(() {
          _users = userList.map<Map<String, String>>((user) {
            return {
              'id': user['id'].toString(),
              'name': user['name'].toString(),
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Dio Error: $e');
    }
  }

  Future<void> fetchCustomerNames() async {
    try {
      var response = await Dio().get(ApiConfig.users_name_list);
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> names = response.data;
        setState(() {
          customerNames = names.map((name) => name.toString()).toList();
        });
      }
    } catch (e) {
      print("Error fetching customer names: $e");
    }
  }

  void loadData() async {
    setState(() => isLoading = true);

    String baseUrl = ApiConfig.all_query_list;
    String id = 'dfcb77c2-be20-44b6-a51a-4cccae18585b';
    String userType = 'admin';

    Map<String, String> queryParams = {
      'id': id,
      'userType': userType,
    };

    if (selectedSearch?.isNotEmpty == true) queryParams['search'] = selectedSearch!;
    if (selectedStatus?.isNotEmpty == true) queryParams['status'] = selectedStatus!;
    if (selectedCustomer?.isNotEmpty == true) queryParams['name'] = selectedCustomer!;
    if (selectedAssignedTo?.isNotEmpty == true) {
      final user = _users.firstWhere((u) => u['name'] == selectedAssignedTo, orElse: () => {});
      if (user.isNotEmpty) queryParams['assignedTo'] = user['id']!;
    }

    String queryString = Uri(queryParameters: queryParams).query;

    try {
      var response = await Dio().get('$baseUrl?$queryString');
      setState(() {
        queryList = response.statusCode == 200 ? response.data : [];
        isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        queryList = [];
        isLoading = false;
      });
    }
  }

  Future<void> exportToCSV() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) return;

    List<List<dynamic>> rows = [
      ['Name', 'Contact', 'Email', 'Company', 'Location'],
      ...queryList.map((q) => [q['name'], q['contact'], q['email'], q['company'], q['location']]),
    ];

    String csv = const ListToCsvConverter().convert(rows);
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/queries.csv');
    await file.writeAsString(csv);
    OpenFile.open(file.path);
  }

  Future<void> exportToPDF() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) return;

    final pdf = PdfDocument();
    final page = pdf.pages.add();
    final grid = PdfGrid();
    grid.columns.add(count: 5);
    grid.headers.add(1);

    grid.headers[0].cells[0].value = 'Name';
    grid.headers[0].cells[1].value = 'Contact';
    grid.headers[0].cells[2].value = 'Email';
    grid.headers[0].cells[3].value = 'Company';
    grid.headers[0].cells[4].value = 'Location';

    for (var q in queryList) {
      var row = grid.rows.add();
      row.cells[0].value = q['name'] ?? '';
      row.cells[1].value = q['contact'] ?? '';
      row.cells[2].value = q['email'] ?? '';
      row.cells[3].value = q['company'] ?? '';
      row.cells[4].value = q['location'] ?? '';
    }

    grid.draw(page: page);
    final bytes = pdf.save();
    pdf.dispose();

    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/queries.pdf');
    await file.writeAsBytes(await bytes, flush: true);
    OpenFile.open(file.path);
  }

  void onEdit(Map<String, dynamic> query) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationForm(existingData: query),
      ),
    );
    if (result == true) loadData();
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
          ApiConfig.delete_query,
          options: Options(method: 'DELETE', headers: headers),
          data: data,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted successfully")));
          loadData();
        } else {
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
    List<String> assignedTo = _users.map((user) => user['name']!).toList();

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 300,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/tblue.png'),
                  fit: BoxFit.fill,
                ),
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Input
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Search', style: const TextStyle(color: Colors.white, fontSize: 12)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                          height: 30,
                          child: TextField(
                            controller: searchController,
                            onSubmitted: (value) {
                              setState(() {
                                selectedSearch = value;
                              });
                              loadData();
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search...',
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildDropdown('Status', statusOptions, selectedStatus, (value) {
                    setState(() => selectedStatus = value);
                    loadData();
                  }),
                  SizedBox(height: 10),
                  _buildDropdown('Customer Name', customerNames, selectedCustomer, (value) {
                    setState(() => selectedCustomer = value);
                    loadData();
                  }),
                  SizedBox(height: 10),
                  _buildDropdown('Query Assigned To', assignedTo, selectedAssignedTo, (value) {
                    setState(() => selectedAssignedTo = value);
                    loadData();
                  }),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: exportToCSV, child: Text("Export CSV")),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: exportToPDF, child: Text("Export PDF")),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : queryList.isEmpty
                ? Center(child: Text("No queries found"))
                : LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenWidth,
                        minHeight: screenHeight,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/loginbg.png'),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(16),
                        child: DataTable(
                          headingRowColor: WidgetStateColor.resolveWith(
                                  (states) => Colors.blue.shade100),
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
                                DataCell(Text(
                                  (query['query'] ?? '').toString().length > 25
                                      ? '${query['query'].toString().substring(0, 25)}...'
                                      : query['query'] ?? '',
                                )),
                                DataCell(Text(
                                  (query['remark'] ?? '').toString().length > 25
                                      ? '${query['remark'].toString().substring(0, 25)}...'
                                      : query['remark'] ?? '',
                                )),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      String label,
      List<String> items,
      String? selectedValue,
      Function(String?) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 28,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: (selectedValue != null && items.contains(selectedValue)) ? selectedValue : null,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      hint: Text(
                        'Select $label',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onChanged: onChanged,
                      items: items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              if (selectedValue != null && selectedValue.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, size: 18),
                  onPressed: () => onChanged(null),
                ),
            ],
          ),
        ),
      ],
    );
  }
}




/*
import 'dart:convert';
import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:ecosoulquerytracker/api_config.dart';
import 'package:ecosoulquerytracker/screens/query_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../services/queryservice.dart';

class QueryListScreen extends StatefulWidget {
  @override
  _QueryListScreenState createState() => _QueryListScreenState();
}

class _QueryListScreenState extends State<QueryListScreen> {
  final queryService = QueryService();
  List<dynamic> queryList = [];
  bool isLoading = true;

  // Filters
  String? selectedSearch;
  String? selectedStatus;
  String? selectedCustomer;
  String? selectedAssignedTo;

  TextEditingController searchController = TextEditingController();

  List<String> statusOptions = ['open', 'close', 'inprogress'];
  List<String> customerNames = []; // Fetched from API
  List<Map<String, String>> _users = []; // AssignedTo User list (name + id)

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchCustomerNames();
    loadData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchUsers() async {
    try {
    //  var response = await Dio().get('http://192.168.50.92:5100/api/users');
      var response = await Dio().get(ApiConfig.users_list);

      if (response.statusCode == 200) {
        final List<dynamic> userList = response.data['users'];
        setState(() {
          _users = userList.map<Map<String, String>>((user) {
            return {
              'id': user['id'].toString(),
              'name': user['name'].toString(),
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Dio Error: $e');
    }
  }

  Future<void> fetchCustomerNames() async {
    try {
      //var response = await Dio().get('http://192.168.50.92:5100/api/registration/usernames');
      var response = await Dio().get(ApiConfig.users_name_list);
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> names = response.data;
        setState(() {
          customerNames = names.map((name) => name.toString()).toList();
        });
      } else {
        print("Failed to fetch customer names: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error fetching customer names: $e");
    }
  }

  void loadData() async {
    setState(() => isLoading = true);

    String baseUrl = ApiConfig.all_query_list;
    String id = 'dfcb77c2-be20-44b6-a51a-4cccae18585b';
    String userType = 'admin';

    Map<String, String> queryParams = {
      'id': id,
      'userType': userType,
    };

    if (selectedSearch != null && selectedSearch!.isNotEmpty) {
      queryParams['search'] = selectedSearch!;
    }

    if (selectedStatus != null && selectedStatus!.isNotEmpty) {
      queryParams['status'] = selectedStatus!;
    }

    if (selectedCustomer != null && selectedCustomer!.isNotEmpty) {
      queryParams['name'] = selectedCustomer!;
    }

    if (selectedAssignedTo != null && selectedAssignedTo!.isNotEmpty) {
      final user = _users.firstWhere((u) => u['name'] == selectedAssignedTo, orElse: () => {});
      if (user.isNotEmpty) {
        queryParams['assignedTo'] = user['id']!;
      }
    }

    String queryString = Uri(queryParameters: queryParams).query;

    try {
      var dio = Dio();
      var response = await dio.get('$baseUrl?$queryString');

      if (response.statusCode == 200) {
        setState(() {
          queryList = response.data;
          isLoading = false;
        });
      } else {
        setState(() {
          queryList = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        queryList = [];
        isLoading = false;
      });
    }
  }

  void exportToCSV() {
    List<List<dynamic>> rows = [
      ['Name', 'Contact', 'Email', 'Company', 'Location'],
      ...queryList.map((q) => [q['name'], q['contact'], q['email'], q['company'], q['location']]),
    ];
    String csv = const ListToCsvConverter().convert(rows);
    final blob = html.Blob([csv]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'queries.csv')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void exportToPDF() {
    final pdf = PdfDocument();
    final page = pdf.pages.add();
    final grid = PdfGrid();
    grid.columns.add(count: 5);
    grid.headers.add(1);
    grid.headers[0].cells[0].value = 'Name';
    grid.headers[0].cells[1].value = 'Contact';
    grid.headers[0].cells[2].value = 'Email';
    grid.headers[0].cells[3].value = 'Company';
    grid.headers[0].cells[4].value = 'Location';
    for (var q in queryList) {
      var row = grid.rows.add();
      row.cells[0].value = q['name'] ?? '';
      row.cells[1].value = q['contact'] ?? '';
      row.cells[2].value = q['email'] ?? '';
      row.cells[3].value = q['company'] ?? '';
      row.cells[4].value = q['location'] ?? '';
    }
    grid.draw(page: page);
    final bytes = pdf.save();
    html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(html.Blob([bytes], 'application/pdf')))
      ..setAttribute('download', 'queries.pdf')
      ..click();
    pdf.dispose();
  }

  void onEdit(Map<String, dynamic> query) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationForm(existingData: query),
      ),
    );
    if (result == true) loadData();
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
         // 'http://192.168.50.92:5100/api/delete',
         ApiConfig.delete_query,
          options: Options(method: 'DELETE', headers: headers),
          data: data,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted successfully")));
          loadData();
        } else {
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
    List<String> assignedTo = _users.map((user) => user['name']!).toList();

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 300,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/dropdownbg.png'),
                  fit: BoxFit.fill,
                ),
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Search Input
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Search', style: const TextStyle(color: Colors.white, fontSize: 12)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                          height: 30,
                          child: TextField(
                            controller: searchController,
                            onSubmitted: (value) {
                              setState(() {
                                selectedSearch = value;
                              });
                              loadData();
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search...',
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildDropdown('Status', statusOptions, selectedStatus, (value) {
                    setState(() => selectedStatus = value);
                    loadData();
                  }),
                  SizedBox(height: 10),
                  _buildDropdown('Customer Name', customerNames, selectedCustomer, (value) {
                    setState(() => selectedCustomer = value);
                    loadData();
                  }),




                  SizedBox(height: 10),
                  _buildDropdown('Query Assigned To', assignedTo, selectedAssignedTo, (value) {
                    setState(() => selectedAssignedTo = value);
                    loadData();
                  }),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: exportToCSV, child: Text("Export CSV")),
                  SizedBox(height: 10),


                  ElevatedButton(onPressed: exportToPDF, child: Text("Export PDF")),


                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : queryList.isEmpty
                ? Center(child: Text("No queries found"))
                : LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenWidth,
                        minHeight: screenHeight,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/loginbg.png'),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(16),
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blue.shade100),
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
                                DataCell(Text(
                                  (query['query'] ?? '').toString().length > 25
                                      ? '${query['query'].toString().substring(0, 25)}...'
                                      : query['query'] ?? '',
                                )),
                                DataCell(Text(
                                  (query['remark'] ?? '').toString().length > 25
                                      ? '${query['remark'].toString().substring(0, 25)}...'
                                      : query['remark'] ?? '',
                                )),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      String label,
      List<String> items,
      String? selectedValue,
      Function(String?) onChanged,
      ) {
    String getHintText(String label) {
      switch (label) {
        case 'Search':
          return 'Search by type';
        case 'Status':
          return 'Choose status';
        case 'Customer Name':
          return 'Select customer';
        case 'Query Assigned To':
          return 'Assigned user';
        default:
          return 'Select option';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 28,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: (selectedValue != null && items.contains(selectedValue)) ? selectedValue : null,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      hint: Text(
                        getHintText(label),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onChanged: onChanged,
                      items: items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              if (selectedValue != null && selectedValue.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, size: 18),
                  onPressed: () {
                    onChanged(null);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
*/





/*


import 'dart:convert';
import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:ecosoulquerytracker/screens/query_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../services/queryservice.dart';

class QueryListScreen extends StatefulWidget {
  @override
  _QueryListScreenState createState() => _QueryListScreenState();
}

class _QueryListScreenState extends State<QueryListScreen> {
  final queryService = QueryService();
  List<dynamic> queryList = [];
  bool isLoading = true;

  // Filters
  String? selectedSearch;
  String? selectedStatus;
  String? selectedCustomer;
  String? selectedAssignedTo;

  List<String> statusOptions = ['open', 'closed', 'inprogress'];
  List<String> customerNames = ['Govind', 'John', 'Alex']; // Placeholder
  List<Map<String, String>> _users = []; // AssignedTo User list (name + id)

  @override
  void initState() {
    super.initState();
    fetchUsers();
    loadData();
  }

  Future<void> fetchUsers() async {
    try {
      var response = await Dio().get('http://192.168.50.92:5100/api/users');
      if (response.statusCode == 200) {
        final List<dynamic> userList = response.data['users'];
        setState(() {
          _users = userList.map<Map<String, String>>((user) {
            return {
              'id': user['id'].toString(),
              'name': user['name'].toString(),
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Dio Error: $e');
    }
  }

  void loadData() async {
    setState(() => isLoading = true);

    String baseUrl = 'http://192.168.50.92:5100/api/registration';
    String id = 'dfcb77c2-be20-44b6-a51a-4cccae18585b';
    String userType = 'admin';

    Map<String, String> queryParams = {
      'id': id,
      'userType': userType,
    };

    if (selectedSearch != null && selectedSearch!.isNotEmpty) {
      queryParams['search'] = selectedSearch!;
    }

    if (selectedStatus != null && selectedStatus!.isNotEmpty) {
      queryParams['status'] = selectedStatus!;
    }

    if (selectedCustomer != null && selectedCustomer!.isNotEmpty) {
      queryParams['name'] = selectedCustomer!;
    }

    if (selectedAssignedTo != null && selectedAssignedTo!.isNotEmpty) {
      final user = _users.firstWhere((u) => u['name'] == selectedAssignedTo, orElse: () => {});
      if (user.isNotEmpty) {
        queryParams['assignedTo'] = user['id']!;
      }
    }

    String queryString = Uri(queryParameters: queryParams).query;

    try {
      var dio = Dio();
      var response = await dio.get('$baseUrl?$queryString');

      if (response.statusCode == 200) {
        setState(() {
          queryList = response.data;
          isLoading = false;
        });
      } else {
        setState(() {
          queryList = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        queryList = [];
        isLoading = false;
      });
    }
  }

  void exportToCSV() {
    List<List<dynamic>> rows = [
      ['Name', 'Contact', 'Email', 'Company', 'Location'],
      ...queryList.map((q) => [q['name'], q['contact'], q['email'], q['company'], q['location']]),
    ];
    String csv = const ListToCsvConverter().convert(rows);
    final blob = html.Blob([csv]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'queries.csv')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void exportToPDF() {
    final pdf = PdfDocument();
    final page = pdf.pages.add();
    final grid = PdfGrid();
    grid.columns.add(count: 5);
    grid.headers.add(1);
    grid.headers[0].cells[0].value = 'Name';
    grid.headers[0].cells[1].value = 'Contact';
    grid.headers[0].cells[2].value = 'Email';
    grid.headers[0].cells[3].value = 'Company';
    grid.headers[0].cells[4].value = 'Location';
    for (var q in queryList) {
      var row = grid.rows.add();
      row.cells[0].value = q['name'] ?? '';
      row.cells[1].value = q['contact'] ?? '';
      row.cells[2].value = q['email'] ?? '';
      row.cells[3].value = q['company'] ?? '';
      row.cells[4].value = q['location'] ?? '';
    }
    grid.draw(page: page);
    final bytes = pdf.save();
    html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(html.Blob([bytes], 'application/pdf')))
      ..setAttribute('download', 'queries.pdf')
      ..click();
    pdf.dispose();
  }

  void onEdit(Map<String, dynamic> query) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationForm(existingData: query),
      ),
    );
    if (result == true) loadData();
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
          'http://192.168.50.92:5100/api/delete',
          options: Options(method: 'DELETE', headers: headers),
          data: data,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted successfully")));
          loadData();
        } else {
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
    List<String> assignedTo = _users.map((user) => user['name']!).toList();

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 300,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/dropdownbg.png'),
                  fit: BoxFit.fill,
                ),
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdown('Search', ['Call', 'Order', 'Payment'], selectedSearch, (value) {
                    setState(() => selectedSearch = value);
                    loadData();
                  }),
                  SizedBox(height: 10),
                  _buildDropdown('Status', statusOptions, selectedStatus, (value) {
                    setState(() => selectedStatus = value);
                    loadData();
                  }),
                  SizedBox(height: 10),
                  _buildDropdown('Customer Name', customerNames, selectedCustomer, (value) {
                    setState(() => selectedCustomer = value);
                    loadData();
                  }),
                  SizedBox(height: 10),
                  _buildDropdown('Query Assigned To', assignedTo, selectedAssignedTo, (value) {
                    setState(() => selectedAssignedTo = value);
                    loadData();
                  }),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: exportToCSV, child: Text("Export CSV")),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: exportToPDF, child: Text("Export PDF")),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : queryList.isEmpty
                ? Center(child: Text("No queries found"))
                : LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenWidth,
                        minHeight: screenHeight,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/loginbg.png'),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(16),
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blue.shade100),
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
                                DataCell(Text(
                                  (query['query'] ?? '').toString().length > 25
                                      ? '${query['query'].toString().substring(0, 25)}...'
                                      : query['query'] ?? '',
                                )),
                                DataCell(Text(
                                  (query['remark'] ?? '').toString().length > 25
                                      ? '${query['remark'].toString().substring(0, 25)}...'
                                      : query['remark'] ?? '',
                                )),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 25,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: onChanged,
                items: items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
*/



/*
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

  // Filters
  String? selectedSearch;
  String? selectedStatus;
  String? selectedCustomer;
  String? selectedAssignedTo;

  List<String> statusOptions = ['open', 'closed', 'inprogress'];
  List<String> customerNames = ['Govind', 'John', 'Alex']; // Placeholder
  List<Map<String, String>> _users = []; // AssignedTo User list (name + id)

  @override
  void initState() {
    super.initState();
    fetchUsers();
    loadData();
  }

  Future<void> fetchUsers() async {
    try {
      var response = await Dio().get('http://192.168.50.92:5100/api/users');
      if (response.statusCode == 200) {
        final List<dynamic> userList = response.data['users'];
        setState(() {
          _users = userList.map<Map<String, String>>((user) {
            return {
              'id': user['id'].toString(),
              'name': user['name'].toString(),
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Dio Error: $e');
    }
  }

  void loadData() async {
    setState(() => isLoading = true);

    String baseUrl = 'http://192.168.50.92:5100/api/registration';
    String id = 'dfcb77c2-be20-44b6-a51a-4cccae18585b';
    String userType = 'admin';

    Map<String, String> queryParams = {
      'id': id,
      'userType': userType,
    };

    if (selectedSearch != null && selectedSearch!.isNotEmpty) {
      queryParams['search'] = selectedSearch!;
    }

    if (selectedStatus != null && selectedStatus!.isNotEmpty) {
      queryParams['status'] = selectedStatus!;
    }

    if (selectedCustomer != null && selectedCustomer!.isNotEmpty) {
      queryParams['name'] = selectedCustomer!;
    }

    if (selectedAssignedTo != null && selectedAssignedTo!.isNotEmpty) {
      final user = _users.firstWhere((u) => u['name'] == selectedAssignedTo, orElse: () => {});
      if (user.isNotEmpty) {
        queryParams['assignedTo'] = user['id']!;
      }
    }

    String queryString = Uri(queryParameters: queryParams).query;

    try {
      var dio = Dio();
      var response = await dio.get('$baseUrl?$queryString');

      if (response.statusCode == 200) {
        setState(() {
          queryList = response.data;
          isLoading = false;
        });
      } else {
        setState(() {
          queryList = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading data: $e");
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
    if (result == true) loadData();
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
          'http://192.168.50.92:5100/api/delete',
          options: Options(method: 'DELETE', headers: headers),
          data: data,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted successfully")));
          loadData();
        } else {
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
    List<String> assignedTo = _users.map((user) => user['name']!).toList();

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 300,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/dropdownbg.png'),
                  fit: BoxFit.fill,
                ),
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdown('Search', ['Call', 'Order', 'Payment'], selectedSearch, (value) {
                    setState(() => selectedSearch = value);
                    loadData();
                  }),
                  SizedBox(height: 10),
                  _buildDropdown('Status', statusOptions, selectedStatus, (value) {
                    setState(() => selectedStatus = value);
                    loadData();
                  }),
                  SizedBox(height: 10),
                  _buildDropdown('Customer Name', customerNames, selectedCustomer, (value) {
                    setState(() => selectedCustomer = value);
                    loadData();
                  }),
                  SizedBox(height: 10),
                  _buildDropdown('Query Assigned To', assignedTo, selectedAssignedTo, (value) {
                    setState(() => selectedAssignedTo = value);
                    loadData();
                  }),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : queryList.isEmpty
                ? Center(child: Text("No queries found"))
                : LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenWidth,
                        minHeight: screenHeight,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/loginbg.png'),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(16),
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blue.shade100),
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
                                DataCell(Text(
                                  (query['query'] ?? '').toString().length > 25
                                      ? '${query['query'].toString().substring(0, 25)}...'
                                      : query['query'] ?? '',
                                )),
                                DataCell(Text(
                                  (query['remark'] ?? '').toString().length > 25
                                      ? '${query['remark'].toString().substring(0, 25)}...'
                                      : query['remark'] ?? '',
                                )),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 25,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: onChanged,
                items: items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
*/






/*

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecosoulquerytracker/screens/query_form_screen.dart';
import 'package:flutter/material.dart';
import '../services/queryservice.dart';

class QueryListScreen extends StatefulWidget {
   //String code;
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
    print("API Responsedash: $res"); // ←
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
          'http://192.168.50.92:5100/api/delete', // Replace with your live IP/domain if needed
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

  // Dummy lists for now (to be replaced with API data)
  List<String> searchOptions = ['Option 1', 'Option 2', 'Option 3'];
  List<String> statusOptions = ['Open', 'Closed', 'Pending'];
  List<String> customerNames = ['John Doe', 'Jane Smith', 'Alex Johnson'];
  List<String> assignedTo = ['Agent A', 'Agent B', 'Agent C'];

  // Selected values
  String? selectedSearch;
  String? selectedStatus;
  String? selectedCustomer;
  String? selectedAssignedTo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(title: Text("Query List")),

  body: Row(
    children: [
      Expanded(
          flex: 1,
          child:Container(
            width: 300,
            padding:  EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/dropdownbg.png'), // Your background image
                fit: BoxFit.fill, // or BoxFit.fitHeight if you prefer
              ),
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdown('Search', searchOptions, selectedSearch, (value) {
                  setState(() => selectedSearch = value);
                }),
                const SizedBox(height: 10),
                _buildDropdown('Status', statusOptions, selectedStatus, (value) {
                  setState(() => selectedStatus = value);
                }),
                const SizedBox(height: 10),
                _buildDropdown('Customer Name', customerNames, selectedCustomer, (value) {
                  setState(() => selectedCustomer = value);
                }),
                const SizedBox(height: 10),
                _buildDropdown('Query Assigned To', assignedTo, selectedAssignedTo, (value) {
                  setState(() => selectedAssignedTo = value);
                }),
              ],
            ),
          ),

      ),

SizedBox(width: 8,),
      Expanded(
        flex: 6,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : queryList.isEmpty
            ? Center(child: Text("No queries found"))
            : LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: screenWidth,
                    minHeight: screenHeight,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/loginbg.png'),
                        fit: BoxFit.fill,
                      ),
                      //color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(16),
                    child:
                    DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue.shade100),
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
                            DataCell(
                              Text(
                                (query['query'] ?? '').toString().length > 25
                                    ? '${query['query'].toString().substring(0, 25)}...'
                                    : query['query'] ?? '',
                              ),
                            ),
                            DataCell(
                              Text(
                                (query['remark'] ?? '').toString().length > 25
                                    ? '${query['remark'].toString().substring(0, 25)}...'
                                    : query['remark'] ?? '',
                              ),
                            ),
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
            );
          },
        ),
      ),

    ],
  ),

    );
  }
}


//drop down filter

Widget _buildDropdown(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 25,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: onChanged,
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    ],
  );
}
*/
