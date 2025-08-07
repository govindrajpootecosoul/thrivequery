import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService authService = AuthService();

  Map<String, dynamic>? dashboardData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  void loadDashboardData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    var data = await authService.fetchDashboardData();

    if (data != null) {
      setState(() {
        dashboardData = data;
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = "Failed to load dashboard data.";
        isLoading = false;
      });
    }
  }

  Widget buildStatCard(String title, int value, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          value.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Dashboard'),
      // ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : dashboardData == null
          ? Center(child: Text("No data available"))
          : ListView(
        padding: EdgeInsets.all(16),
        children: [
          buildStatCard("Total", dashboardData!['total'] ?? 0, Colors.blue),
          buildStatCard("Open", dashboardData!['open'] ?? 0, Colors.orange),
          buildStatCard("Close", dashboardData!['close'] ?? 0, Colors.green),
          buildStatCard("In-Progress", dashboardData!['inprogress'] ?? 0, Colors.yellow),
          buildStatCard("Others", dashboardData!['others'] ?? 0, Colors.red),
        ],
      ),
    );
  }
}
