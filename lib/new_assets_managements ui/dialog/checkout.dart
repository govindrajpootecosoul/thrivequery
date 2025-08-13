import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../screens/assets_list.dart';

class CheckoutDialog extends StatefulWidget {
  final Asset asset;
  const CheckoutDialog({Key? key, required this.asset}) : super(key: key);

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> employees = [];
  Map<String, dynamic>? selectedEmployee;
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    try {
      var dio = Dio();
      var response = await dio.get('https://thrive-assetsmanagements.onrender.com/api/hrms/employees');
      if (response.statusCode == 200) {
        setState(() {
          employees = List<Map<String, dynamic>>.from(response.data['data']);
        });
      } else {
        print(response.statusMessage);
      }
    } catch (e) {
      print("Error fetching employees: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Checkout Asset',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Asset info card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.computer, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.asset.assetTagId,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(widget.asset.model),
                        Text(widget.asset.category,
                            style: const TextStyle(color: Colors.blue)),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Checkout Date
              const Text('Checkout Date *'),
              const SizedBox(height: 4),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Assign to Employee
              const Text('Assign To Employee *'),
              const SizedBox(height: 4),
              DropdownButtonFormField<Map<String, dynamic>>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: employees.map((emp) {
                  return DropdownMenuItem(
                    value: emp,
                    child: Text(emp['Full Name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEmployee = value;
                  });
                  if (value != null) {
                    print("Selected Employee Number: ${value['Employee Number']}");
                  }
                },
              ),

              const SizedBox(height: 16),

              // Notes
              const Text('Notes (Optional)'),
              const SizedBox(height: 4),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add any additional notes...',
                ),
              ),

              const SizedBox(height: 16),

              // Confirmation text
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow.shade700),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.info, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'By submitting this form, you confirm that the asset will be assigned to the selected employee. The employee will be responsible for the care and return of this asset.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    // onPressed: () {
                    //   print("Submit Checkout for Asset: ${widget.asset.id}");
                    //   if (selectedEmployee != null) {
                    //     print("Employee Number: ${selectedEmployee!['Employee Number']}");
                    //   }
                    //   Navigator.pop(context);
                    // },

                    onPressed: () async {
                      if (selectedEmployee == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select an employee')),
                        );
                        return;
                      }

                      try {
                        var headers = {'Content-Type': 'application/json'};
                        var data = json.encode({
                          "assetId": widget.asset.id,
                          "employeeId": selectedEmployee!['Employee Number'],
                        });

                        var dio = Dio();
                        var response = await dio.request(
                          'https://thrive-assetsmanagements.onrender.com/api/assetmanagements/assign',
                          options: Options(
                            method: 'POST',
                            headers: headers,
                          ),
                          data: data,
                        );

                        if (response.statusCode == 200) {
                          print("Assign API Success: ${json.encode(response.data)}");

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Asset assigned successfully!')),
                          );

                          Navigator.pop(context); // Close dialog
                        } else {
                          print(response.statusMessage);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${response.statusMessage}')),
                          );
                        }
                      } catch (e) {
                        print("Error calling assign API: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },


                    child: const Text('Submit Checkout'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
