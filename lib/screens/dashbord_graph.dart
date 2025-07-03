/*
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardGraphScreen extends StatelessWidget {
  final List<Map<String, dynamic>> openQueries = List.generate(20, (index) => {
    'No': index + 1,
    'Data1': 'Open $index',
    'Data2': 'Val A',
    'Data3': 'Val B',
    'Data4': 'Val C',
    'Data5': 'Val D',
  });

  final List<Map<String, dynamic>> closedQueries = List.generate(20, (index) => {
    'No': index + 1,
    'Data1': 'Closed $index',
    'Data2': 'Val E',
    'Data3': 'Val F',
    'Data4': 'Val G',
    'Data5': 'Val H',
  });

  final List<Map<String, dynamic>> userQueries = [
    {'country': 'USA', 'count': 454},
    {'country': 'India', 'count': 207},
    {'country': 'Canada', 'count': 47},
    {'country': 'UAE', 'count': 14},
    {'country': 'UK', 'count': 36},
    {'country': 'Germany', 'count': 36},
  ];

  final List<PieChartSectionData> pieSections = [
    PieChartSectionData(value: 89.2, color: Colors.blue, title: 'Total'),
    PieChartSectionData(value: 10.8, color: Colors.orange, title: 'Open'),
    PieChartSectionData(value: 30, color: Colors.green, title: 'Closed'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFF7),
      appBar: AppBar(title: const Text("Dashboard Graph")),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                // Pie Chart Section
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text('Queries by Count', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Expanded(
                          child: PieChart(PieChartData(
                            sections: pieSections,
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            borderData: FlBorderData(show: false),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
                // Open Queries Table Section
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("OPEN QUERIES THIS MONTH", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 12,
                                columns: const [
                                  DataColumn(label: Text('No')),
                                  DataColumn(label: Text('Data1')),
                                  DataColumn(label: Text('Data2')),
                                  DataColumn(label: Text('Data3')),
                                  DataColumn(label: Text('Data4')),
                                  DataColumn(label: Text('Data5')),
                                  DataColumn(label: Text('Action')),
                                ],
                                rows: openQueries.map((query) {
                                  return DataRow(cells: [
                                    DataCell(Text(query['No'].toString())),
                                    DataCell(Text(query['Data1'])),
                                    DataCell(Text(query['Data2'])),
                                    DataCell(Text(query['Data3'])),
                                    DataCell(Text(query['Data4'])),
                                    DataCell(Text(query['Data5'])),
                                    DataCell(Icon(Icons.search)),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                // Bar Chart Section
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text('Queries by Users', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(BarChartData(
                              barGroups: userQueries.asMap().entries.map((entry) {
                                int index = entry.key;
                                var data = entry.value;
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: data['count'].toDouble(),
                                      width: 20,
                                      color: Colors.primaries[index % Colors.primaries.length],
                                    )
                                  ],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final country = userQueries[value.toInt()]['country'];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text(country, style: const TextStyle(fontSize: 10)),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Closed Queries Table Section
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("CLOSED QUERIES THIS MONTH", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 12,
                                columns: const [
                                  DataColumn(label: Text('No')),
                                  DataColumn(label: Text('Data1')),
                                  DataColumn(label: Text('Data2')),
                                  DataColumn(label: Text('Data3')),
                                  DataColumn(label: Text('Data4')),
                                  DataColumn(label: Text('Data5')),
                                  DataColumn(label: Text('Action')),
                                ],
                                rows: closedQueries.map((query) {
                                  return DataRow(cells: [
                                    DataCell(Text(query['No'].toString())),
                                    DataCell(Text(query['Data1'])),
                                    DataCell(Text(query['Data2'])),
                                    DataCell(Text(query['Data3'])),
                                    DataCell(Text(query['Data4'])),
                                    DataCell(Text(query['Data5'])),
                                    DataCell(Icon(Icons.search)),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/



import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecosoulquerytracker/api_config.dart';
import 'package:ecosoulquerytracker/dio_client.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardGraphScreen extends StatefulWidget {
  const DashboardGraphScreen({Key? key}) : super(key: key);

  @override
  State<DashboardGraphScreen> createState() => _DashboardGraphScreenState();
}

class _DashboardGraphScreenState extends State<DashboardGraphScreen> {
  List<Map<String, dynamic>> openQueries = [];
  List<Map<String, dynamic>> closedQueries = [];

  final List<Map<String, dynamic>> userQueries = [
    {'country': 'USA', 'count': 454},
    {'country': 'India', 'count': 207},
    {'country': 'Canada', 'count': 47},
    {'country': 'UAE', 'count': 14},
    {'country': 'UK', 'count': 36},
    {'country': 'Germany', 'count': 36},
  ];

  final List<PieChartSectionData> pieSections = [
    PieChartSectionData(value: 89.2, color: Colors.blue, title: 'Total'),
    PieChartSectionData(value: 10.8, color: Colors.orange, title: 'Open'),
    PieChartSectionData(value: 30, color: Colors.green, title: 'Closed'),
  ];

  @override
  void initState() {
    super.initState();
    fetchQueries();
  }

  Future<void> fetchQueries() async {
  //  const baseUrl = 'http://192.168.50.92:5100/api/registration';
    const baseUrl = ApiConfig.all_query_list;
    const id = 'dfcb77c2-be20-44b6-a51a-4cccae18585b';
    const userType = 'admin';

    try {
     final dio = Dio();

      final openRes = await dio.get(baseUrl, queryParameters: {
        'id': id,
        'userType': userType,
        'status': 'open',
      });

      final closeRes = await dio.get(baseUrl, queryParameters: {
        'id': id,
        'userType': userType,
        'status': 'close',
      });

      if (openRes.statusCode == 200 && closeRes.statusCode == 200) {
        setState(() {
          openQueries = List<Map<String, dynamic>>.from(openRes.data);
          closedQueries = List<Map<String, dynamic>>.from(closeRes.data);
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  DataTable buildQueryTable(List<Map<String, dynamic>> queries) {
    return DataTable(
      columnSpacing: 12,
      columns: const [
        DataColumn(label: Text('No')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Contact')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Company')),
        DataColumn(label: Text('Query')),
        DataColumn(label: Text('Action')),
      ],
      rows: queries.asMap().entries.map((entry) {
        final index = entry.key;
        final query = entry.value;
        return DataRow(cells: [
          DataCell(Text((index + 1).toString())),
          DataCell(Text(query['name'] ?? '')),
          DataCell(Text(query['contact'] ?? '')),
          DataCell(Text(query['email'] ?? '')),
          DataCell(Text(query['company'] ?? '')),
          DataCell(Text(query['query'] ?? '')),
          DataCell(const Icon(Icons.search)),
        ]);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFF7),
      appBar: AppBar(title: const Text("Dashboard Graph")),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                /// Pie Chart Section
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text('Queries by Count', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Expanded(
                          child: PieChart(PieChartData(
                            sections: pieSections,
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            borderData: FlBorderData(show: false),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Open Queries Table
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("OPEN QUERIES THIS MONTH", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: buildQueryTable(openQueries),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Second Row
          Expanded(
            flex: 1,
            child: Row(
              children: [
                /// Bar Chart
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text('Queries by Users', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(BarChartData(
                              barGroups: userQueries.asMap().entries.map((entry) {
                                int index = entry.key;
                                var data = entry.value;
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: data['count'].toDouble(),
                                      width: 20,
                                      color: Colors.primaries[index % Colors.primaries.length],
                                    )
                                  ],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final country = userQueries[value.toInt()]['country'];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text(country, style: const TextStyle(fontSize: 10)),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Closed Queries Table
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("CLOSED QUERIES THIS MONTH", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: buildQueryTable(closedQueries),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
