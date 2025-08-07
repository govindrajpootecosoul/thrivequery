import 'package:flutter/material.dart';
//
// class CheckInDialog extends StatefulWidget {
//   const CheckInDialog({super.key});
//
//   @override
//   State<CheckInDialog> createState() => _CheckInDialogState();
// }
//
// class _CheckInDialogState extends State<CheckInDialog> {
//   bool checkInFromPerson = true;
//   DateTime selectedDate = DateTime.now();
//   String? selectedSite;
//   String? selectedLocation;
//   String? selectedDepartment;
//   bool sendEmail = false;
//   final noteController = TextEditingController();
//
//   final email = "charu.anand@ecosoulhome.com"; // You can make this dynamic
//
//   Future<void> _selectDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: const Color(0xFF1A1A2E),
//       title: const Text("Check in", style: TextStyle(color: Colors.white)),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Toggle buttons
//             Row(
//               children: [
//                 _radioButton("Person", true),
//                 const SizedBox(width: 20),
//                 _radioButton("Site / Location", false),
//               ],
//             ),
//
//             const SizedBox(height: 16),
//             // Return date picker
//             Text("Return Date *", style: TextStyle(color: Colors.white)),
//             const SizedBox(height: 8),
//             GestureDetector(
//               onTap: _selectDate,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF2E2E42),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "${selectedDate.day.toString().padLeft(2, '0')}/"
//                           "${selectedDate.month.toString().padLeft(2, '0')}/"
//                           "${selectedDate.year}",
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     const Icon(Icons.calendar_today, color: Colors.white),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//             const Text(
//               "Optionally change site, location and department of assets to:",
//               style: TextStyle(color: Colors.white70),
//             ),
//             const SizedBox(height: 12),
//
//             _dropdown("Site", ["Site A", "Site B"], selectedSite, (val) {
//               setState(() => selectedSite = val);
//             }),
//             const SizedBox(height: 12),
//             _dropdown("Location", ["Delhi", "Mumbai"], selectedLocation, (val) {
//               setState(() => selectedLocation = val);
//             }),
//             const SizedBox(height: 12),
//             _dropdown("Department", ["IT", "HR", "Admin"], selectedDepartment,
//                     (val) {
//                   setState(() => selectedDepartment = val);
//                 }),
//
//             const SizedBox(height: 16),
//             const Text("Check-in Notes", style: TextStyle(color: Colors.white)),
//             const SizedBox(height: 6),
//             Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFF2E2E42),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               padding: const EdgeInsets.all(10),
//               child: TextField(
//                 controller: noteController,
//                 maxLines: 3,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: const InputDecoration.collapsed(
//                   hintText: "Enter notes...",
//                   hintStyle: TextStyle(color: Colors.white60),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Checkbox(
//                   value: sendEmail,
//                   onChanged: (val) {
//                     setState(() => sendEmail = val ?? false);
//                   },
//                 ),
//                 const Text("Send Email", style: TextStyle(color: Colors.white)),
//               ],
//             ),
//             const SizedBox(height: 6),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF2E2E42),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Text(
//                 email,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             )
//           ],
//         ),
//       ),
//       actions: [
//         ElevatedButton(
//           onPressed: () {
//             // Implement check-in logic
//             Navigator.pop(context);
//           },
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
//           child: const Text("Check-in"),
//         ),
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
//         ),
//       ],
//     );
//   }
//
//   Widget _radioButton(String label, bool value) {
//     return Row(
//       children: [
//         Radio<bool>(
//           value: value,
//           groupValue: checkInFromPerson,
//           activeColor: Colors.amber,
//           onChanged: (val) => setState(() => checkInFromPerson = val!),
//         ),
//         Text(label, style: const TextStyle(color: Colors.white)),
//       ],
//     );
//   }
//
//   Widget _dropdown(String label, List<String> items, String? selected,
//       void Function(String?) onChanged) {
//     return DropdownButtonFormField<String>(
//       value: selected,
//       dropdownColor: const Color(0xFF2E2E42),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white),
//         filled: true,
//         fillColor: const Color(0xFF2E2E42),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
//       ),
//       style: const TextStyle(color: Colors.white),
//       items: items
//           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//           .toList(),
//       onChanged: onChanged,
//     );
//   }
// }
//







/*
class CheckOutDialog extends StatefulWidget {
  const CheckOutDialog({super.key});

  @override
  State<CheckOutDialog> createState() => _CheckOutDialogState();
}

class _CheckOutDialogState extends State<CheckOutDialog> {
  DateTime checkOutDate = DateTime.now();
  DateTime dueDate = DateTime.now();
  String? assignedTo;
  String? site;
  String? location;
  String? department;
  bool sendEmail = false;
  final noteController = TextEditingController();
  final emailController = TextEditingController();

  final assignToList = ['Employee A', 'Employee B', 'Employee C'];
  final siteList = ['Site A', 'Site B'];
  final locationList = ['Delhi', 'Mumbai'];
  final departmentList = ['IT', 'HR', 'Admin'];

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

  Widget _dropdown(String label, String? selected, List<String> options, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selected,
      onChanged: onChanged,
      dropdownColor: Colors.black87,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
      style: const TextStyle(color: Colors.white),
      items: options
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
    );
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

            const SizedBox(height: 8),
            Row(
              children: const [
                Text("Check-out to:", style: TextStyle(color: Colors.white)),
                SizedBox(width: 12),
                Icon(Icons.person, color: Colors.orange, size: 16),
                SizedBox(width: 4),
                Text("Person", style: TextStyle(color: Colors.white)),
                SizedBox(width: 16),
                Icon(Icons.location_on_outlined, color: Colors.grey, size: 16),
                SizedBox(width: 4),
                Text("Site / Location", style: TextStyle(color: Colors.white54)),
              ],
            ),

            const SizedBox(height: 16),
            _dropdown("Assign to *", assignedTo, assignToList, (val) {
              setState(() => assignedTo = val);
            }),

            // const SizedBox(height: 12),
            // _buildDateField("Due Date", dueDate, () => _pickDate(false)),

            const SizedBox(height: 16),
            const Text("Optionally change site, location and department of assets to:", style: TextStyle(color: Colors.white70)),

            const SizedBox(height: 12),
            _dropdown("Site", site, siteList, (val) => setState(() => site = val)),
            const SizedBox(height: 12),
            _dropdown("Location", location, locationList, (val) => setState(() => location = val)),
            const SizedBox(height: 12),
            _dropdown("Department", department, departmentList, (val) => setState(() => department = val)),

            const SizedBox(height: 16),
            const Text("Check-out Notes", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: noteController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration.collapsed(
                  hintText: "Enter notes...",
                  hintStyle: TextStyle(color: Colors.white60),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: sendEmail,
                  onChanged: (val) {
                    setState(() => sendEmail = val ?? false);
                  },
                ),
                const Text("Send Email", style: TextStyle(color: Colors.white)),
              ],
            ),

            if (sendEmail)
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter Email Address',
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                ),
                style: const TextStyle(color: Colors.white),
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
          onPressed: () {
            // Perform checkout logic
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          child: const Text("Check-out"),
        ),
      ],
    );
  }
}


*/





class BrokenDialog extends StatefulWidget {
  const BrokenDialog({super.key});

  @override
  State<BrokenDialog> createState() => _BrokenDialogState();
}

class _BrokenDialogState extends State<BrokenDialog> {
  DateTime dateBroken = DateTime.now();
  final TextEditingController noteController = TextEditingController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateBroken,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(), // Dark theme for date picker
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => dateBroken = picked);
    }
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${dateBroken.day.toString().padLeft(2, '0')}/"
                  "${dateBroken.month.toString().padLeft(2, '0')}/"
                  "${dateBroken.year}",
              style: const TextStyle(color: Colors.white),
            ),
            const Icon(Icons.calendar_today, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: const Text("Broken", style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Date Broken *", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            _buildDateField(),

            const SizedBox(height: 20),
            const Text("Notes", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: noteController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration.collapsed(
                  hintText: "Enter notes...",
                  hintStyle: TextStyle(color: Colors.white60),
                ),
              ),
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
          onPressed: () {
            // Handle submit logic
            print("Date: $dateBroken");
            print("Notes: ${noteController.text}");
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
          ),
          child: const Text("Broken"),
        ),
      ],
    );
  }
}

class RepairDialog extends StatefulWidget {
  const RepairDialog({super.key});

  @override
  State<RepairDialog> createState() => _RepairDialogState();
}

class _RepairDialogState extends State<RepairDialog> {
  DateTime scheduleDate = DateTime.now();
  DateTime? completedDate;
  final assignedToController = TextEditingController();
  final repairCostController = TextEditingController();
  final notesController = TextEditingController();

  Future<void> _pickDate({required bool isSchedule}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isSchedule ? scheduleDate : (completedDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
    if (picked != null) {
      setState(() {
        if (isSchedule) {
          scheduleDate = picked;
        } else {
          completedDate = picked;
        }
      });
    }
  }

  Widget _buildDateField(String label, DateTime? value, VoidCallback onTap, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label${required ? ' *' : ''}",
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value != null
                      ? "${value.day.toString().padLeft(2, '0')}/"
                      "${value.month.toString().padLeft(2, '0')}/"
                      "${value.year}"
                      : "dd/MM/yyyy",
                  style: TextStyle(color: value != null ? Colors.white : Colors.white54),
                ),
                const Icon(Icons.calendar_today, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            hintStyle: const TextStyle(color: Colors.white54),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: const Text("Repair Asset", style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateField("Schedule Date", scheduleDate, () => _pickDate(isSchedule: true), required: true),
            const SizedBox(height: 12),

            _buildTextField("Assigned to", assignedToController),
            const SizedBox(height: 12),

            _buildDateField("Date Completed", completedDate, () => _pickDate(isSchedule: false)),
            const SizedBox(height: 12),

            _buildTextField("Repair Cost", repairCostController, keyboardType: TextInputType.number),
            const SizedBox(height: 12),

            _buildTextField("Notes", notesController),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle repair submission logic here
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          child: const Text("Repair"),
        ),
      ],
    );
  }
}

