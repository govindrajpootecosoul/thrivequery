import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'List_new_assets.dart';

class CheckOutDialog extends StatefulWidget {
  //final String assetId; // ✅ Pass assetId when opening the dialog

  const CheckOutDialog({super.key,});

  @override
  State<CheckOutDialog> createState() => _CheckOutDialogState();
}

class _CheckOutDialogState extends State<CheckOutDialog> {
  DateTime checkOutDate = DateTime.now();
  DateTime dueDate = DateTime.now();
  String? assignedTo;
  bool sendEmail = false;

  final noteController = TextEditingController();
  final emailController = TextEditingController();

  List<Map<String, dynamic>> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      var dio = Dio();
      var response = await dio.get('http://localhost:5300/api/hrms/employees');

      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        setState(() {
          employees = data
              .map((e) => {
            "id": e["Employee Number"],
            "name": e["Full Name"],
          })
              .toList();
        });
      } else {
        print("Error: ${response.statusMessage}");
      }
    } catch (e) {
      print("API Error: $e");
    }
  }

  Future<void> _pickDate(bool isCheckOutDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckOutDate ? checkOutDate : dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isCheckOutDate) {
          checkOutDate = picked;
        } else {
          dueDate = picked;
        }
      });
    }
  }

  Widget _buildDateField(String label, DateTime value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${value.day.toString().padLeft(2, '0')}/"
                  "${value.month.toString().padLeft(2, '0')}/"
                  "${value.year}",
              style: const TextStyle(color: Colors.white),
            ),
            const Icon(Icons.calendar_today, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Future<void> _assignAssetToEmployee() async {
    if (assignedTo == null) return;

    try {
      var headers = {'Content-Type': 'application/json'};
      var data = json.encode({
        "assetId": gassetId,
        "employeeId": assignedTo,
      });

      var dio = Dio();
      var response = await dio.request(
        'http://localhost:5300/api/assetmanagements/assign',
        options: Options(method: 'POST', headers: headers),
        data: data,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Asset assigned successfully!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.statusMessage}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: const Text("Check out", style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateField("Check-out Date", checkOutDate, () => _pickDate(true)),

            const SizedBox(height: 16),

            employees.isEmpty
                ? const CircularProgressIndicator()
                : DropdownSearch<String>(
              items: employees.map((e) => e["name"].toString()).toList(),
              selectedItem: assignedTo != null
                  ? employees.firstWhere((e) => e["id"] == assignedTo)["name"]
                  : null,
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Search employee...",
                  ),
                ),
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(item, style: const TextStyle(color: Colors.black)),
                ),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Assign to *",
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              dropdownButtonProps: const DropdownButtonProps(),
              dropdownBuilder: (context, selectedItem) => Text(
                selectedItem ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              onChanged: (String? name) {
                final emp = employees.firstWhere((e) => e["name"] == name);
                setState(() => assignedTo = emp["id"]);
                print("Selected Employee ID: ${emp["id"]}");
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: assignedTo == null ? null : _assignAssetToEmployee,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          child: const Text("Check-out"),
        ),
      ],
    );
  }
}
