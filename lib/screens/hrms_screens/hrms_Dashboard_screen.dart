import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HrmsDashboardScreen extends StatelessWidget {
  const HrmsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xDDE5E1DC),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sidebar

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        const Text(
                          'Overview',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),

                        ElevatedButton(
                          onPressed: () => _showAddTaskDialog(context),
                          child: Text("Add Task"),
                        ),


                        // const SizedBox(
                        //   width: 250,
                        //   child: TextField(
                        //     decoration: InputDecoration(
                        //       prefixIcon: Icon(Icons.search),
                        //       hintText: 'Search for anything...',
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(
                        //           Radius.circular(50),
                        //         ),
                        //       ),
                        //       filled: true,
                        //       fillColor: Colors.white,
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(width: 16),
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage:
                          AssetImage('assets/user_avatar.png'),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Alex meian"),
                            Text("Product manager",
                                style: TextStyle(fontSize: 12))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
Divider(),

                    // Stats cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard('Available Assets', '20 /120', Icons.bar_chart, Colors.black87),
                        _buildStatCard('Active Assets', '90 /120', Icons.backpack, Colors.green.shade900),
                        _buildStatCard('Broken Assets', '5 /120', Icons.broken_image, Colors.grey),
                        _buildStatCard('Under Repair', '5', Icons.build, Colors.brown.shade700),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Maintenance & Calendar Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Assets Under Maintenance
                        Expanded(
                          flex: 1,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(3, (index) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    title: const Text('Title'),
                                    subtitle: const Text('Description'),
                                    trailing: const Text('9:41 AM'),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Calendar Alert Box
                        Expanded(
                            flex: 1,
                            child: _buildCalendarCard()),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Today Task
                    _buildTaskCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color iconColor) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(count, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade400, blurRadius: 5, offset: const Offset(2, 2))
        ],
      ),
      child: Column(
        children: [
          const Text("Alert", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
           CalendarDatePicker(
            initialDate: DateTime(2025, 7, 26),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            onDateChanged: (date) {},
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Today task", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ...[
              ["Create a user flow of social application design", "Approved"],
              ["Create a user flow of social application design", "In review"],
              ["Landing page design for Fintech project of singapore", "In review"],
              ["Interactive prototype for app screens of deltamime project", "On going"],
              ["Interactive prototype for app screens of deltamime project", "Approved"],
            ].map((task) => ListTile(
              leading: const Icon(Icons.circle, size: 10, color: Colors.black87),
              title: Text(task[0]),
              trailing: Text(task[1], style: TextStyle(color: task[1] == "Approved" ? Colors.green : task[1] == "On going" ? Colors.orange : Colors.red)),
            )),
          ],
        ),
      ),
    );
  }
}


void _showAddTaskDialog(BuildContext context) {
  final dateController = TextEditingController();
  final taskController = TextEditingController();
  String? selectedStatus;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add Task'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Date with auto dash
                  TextField(
                    controller: dateController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, _DateFormatterWithValidation()],
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'Task Date (dd-mm-yyyy)',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                  ),
                  SizedBox(height: 12),

                  // Task
                  TextField(
                    controller: taskController,
                    minLines: 6,
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: 'Task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Status
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: ['Pending', 'In Progress', 'Completed']
                        .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedStatus = val),
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // You can validate and handle submission here
                  print('Date: ${dateController.text}');
                  print('Task: ${taskController.text}');
                  print('Status: $selectedStatus');

                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
            ],
          );
        },
      );
    },
  );
}


class _DateFormatterWithValidation extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length && i < 8; i++) {
      buffer.write(digits[i]);
      if (i == 1 || i == 3) buffer.write('-');
    }

    String formatted = buffer.toString();
    if (formatted.length == 10) {
      final parts = formatted.split('-');
      final day = int.tryParse(parts[0]) ?? 0;
      final month = int.tryParse(parts[1]) ?? 0;
      final year = int.tryParse(parts[2]) ?? 0;

      if (day > 31 || month > 12 || year < 1900 || year > 2100) {
        return oldValue; // Reject input
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
