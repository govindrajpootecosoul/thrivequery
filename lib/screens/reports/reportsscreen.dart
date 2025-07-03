import 'package:ecosoulquerytracker/screens/query_list_screen.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  String? selectedCustomer;
  List<String> customerNames = ['John Doe', 'Jane Smith', 'Alex Johnson'];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xF3FDF9F6),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sidebar
           /* Container(
              width: size.width * 0.15,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )
                ],
              ),
            ),*/

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

                    const SizedBox(height: 10),
                    _buildDropdown('Select Users', customerNames, selectedCustomer, (value) {
                      setState(() => selectedCustomer = value);
                    }),

                  ],
                ),
              ),

            ),

            // Main Panel with Tabs
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    // Export Button
                    Align(
                      alignment: Alignment.center,
                      child:

                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xD88E5A29),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Export Reports',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Tabs as Buttons
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.brown,
                      labelColor: Colors.brown,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(text: '📊 All Queries'),
                        Tab(text: '✅ Open Queries'),
                        Tab(text: '🏁 Closed Queries'),
                      ],
                    ),

                     SizedBox(height: 20),

                    // Tab View Content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                         // Center(child: QueryListScreen()), // <-- updated here
                          Center(child: Text('All Queries Report Screen')),
                          Center(child: Text('Open Queries Report Screen')),
                          Center(child: Text('Closed Queries Report Screen')),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
