import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CheckInDialog extends StatefulWidget {
  final Map<String, dynamic> assetData;

  const CheckInDialog({Key? key, required this.assetData}) : super(key: key);

  @override
  State<CheckInDialog> createState() => _CheckInDialogState();
}

class _CheckInDialogState extends State<CheckInDialog> {
  final TextEditingController noteController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    noteController.text = widget.assetData['Check-in Notes']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.assetData;

    return AlertDialog(
      title: const Text('Check In Asset'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._buildDynamicInfoRows(data),
            const SizedBox(height: 10),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Check-in Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : _submitCheckIn,
          child: isLoading
              ? const SizedBox(
              width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Check In'),
        ),
      ],
    );
  }

  List<Widget> _buildDynamicInfoRows(Map<String, dynamic> data) {
    final visibleFields = [
      'Asset Name',
      'Asset Tag',
      'Site',
      'Location',
      'Department',
      'Assigned to Email',
      'Assigned to Name',
      'Category',
      'Subcategory',
      'Status',
      'Condition'
    ];

    return visibleFields
        .where((key) => data[key] != null && data[key].toString().trim().isNotEmpty)
        .map((key) => Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: _infoRow(key, data[key].toString()),
    ))
        .toList();
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }

  Future<void> _submitCheckIn() async {
    final assetId = widget.assetData['id'];
    if (assetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Asset ID not found')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      var headers = {'Content-Type': 'application/json'};
      var body = json.encode({
        "assetId": assetId.toString(),
        "notes": noteController.text.trim(), // optional
      });

      var dio = Dio();
      var response = await dio.request(
        'https://thrive-assetsmanagements.onrender.com/api/assetmanagements/checkin',
        options: Options(method: 'POST', headers: headers),
        data: body,
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop(); // Close dialog first

        // ✅ Show success toast message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Asset checked in successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed: ${response.statusMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

}
