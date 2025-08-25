// import 'dart:convert';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
//
// class Updatye_AssetForm extends StatefulWidget {
//   const Updatye_AssetForm({Key? key}) : super(key: key);
//
//   @override
//   State<Updatye_AssetForm> createState() => _Updatye_AssetFormState();
// }
//
// class _Updatye_AssetFormState extends State<Updatye_AssetForm> {
//   int currentStep = 1;
//
//   // Step 1 fields
//   String? category;
//   String? subCategory;
//   String? site;
//   String? location;
//   String? status = "Available";
//   String? tagId;
//
//   // Step 2 common fields
//   final brandController = TextEditingController();
//   final modelController = TextEditingController();
//   final serialController = TextEditingController();
//   final descriptionController = TextEditingController();
//
//   // Computer Assets fields
//   final processorController = TextEditingController();
//   final processorGenController = TextEditingController();
//   final totalRamController = TextEditingController();
//   final ram1Controller = TextEditingController();
//   final ram2Controller = TextEditingController();
//   final ram1BrandController = TextEditingController();
//   final ram2BrandController = TextEditingController();
//   final deviceIdController = TextEditingController();
//   final warrantyMonthsController = TextEditingController();
//   DateTime? warrantyStart;
//   DateTime? warrantyExpire;
//
//   // External Equipment fields
//   String? bagOption = "No";
//   String? keyboardOption = "No";
//   String? mouseOption = "No";
//   String? chargerOption = "No";
//
//   @override
//   void initState() {
//     super.initState();
//     ram1Controller.addListener(_updateTotalRam);
//     ram2Controller.addListener(_updateTotalRam);
//   }
//
//   void _updateTotalRam() {
//     int ram1 = _extractNumber(ram1Controller.text);
//     int ram2 = _extractNumber(ram2Controller.text);
//     int total = ram1 + ram2;
//     totalRamController.text = total > 0 ? "${total}GB" : "";
//   }
//
//   int _extractNumber(String text) {
//     String digits = text.replaceAll(RegExp(r'[^0-9]'), '');
//     return digits.isEmpty ? 0 : int.parse(digits);
//   }
//
//   void _generateTagId() {
//     if (category != null && subCategory != null) {
//       final mapping = {
//         "Computer Assets": {
//           "Laptop": "CA-LAP",
//           "Desktop": "CA-DESK",
//         },
//         "External Equipment": {
//           "Bag": "EE-BAG",
//           "Charger": "EE-CHG",
//           "Keyboard": "EE-KBD",
//           "LCD-Monitors": "EE-LCD",
//           "Mouse": "EE-MSE",
//         }
//       };
//       tagId = mapping[category]?[subCategory];
//     }
//   }
//
//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(color: Colors.grey),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(color: Colors.grey),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(color: Colors.blue, width: 1.5),
//       ),
//     );
//   }
//
//   Widget _dropdownWithHeading({
//     required String heading,
//     required String hint,
//     required String? value,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(heading,
//             style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
//         const SizedBox(height: 6),
//         DropdownButtonFormField<String>(
//           value: value,
//           hint: Text(hint),
//           decoration: _inputDecoration(hint),
//           items: items
//               .map((item) => DropdownMenuItem(value: item, child: Text(item)))
//               .toList(),
//           onChanged: onChanged,
//         ),
//       ],
//     );
//   }
//
//   Widget _textFieldWithHeading({
//     required String heading,
//     required TextEditingController controller,
//     required String hint,
//     bool readOnly = false,
//     VoidCallback? onTap,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(heading,
//             style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
//         const SizedBox(height: 6),
//         TextField(
//           controller: controller,
//           readOnly: readOnly,
//           decoration: _inputDecoration(hint),
//           onTap: onTap,
//         ),
//       ],
//     );
//   }
//
//   Widget _stepCircle(int step, bool active) {
//     return Container(
//       width: 28,
//       height: 28,
//       decoration: BoxDecoration(
//         color: active ? Colors.blue : Colors.white,
//         border: Border.all(color: Colors.blue, width: 2),
//         shape: BoxShape.circle,
//       ),
//       alignment: Alignment.center,
//       child: Text(
//         "$step",
//         style: TextStyle(
//           color: active ? Colors.white : Colors.blue,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStepIndicatorWithLabels() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             _stepCircle(1, currentStep >= 1),
//             Expanded(
//               child: Container(
//                 height: 4,
//                 color: currentStep >= 2 ? Colors.blue : Colors.grey[300],
//               ),
//             ),
//             _stepCircle(2, currentStep >= 2),
//           ],
//         ),
//         const SizedBox(height: 6),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: const [
//             Text("Basic Info",
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
//             Text("Details",
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ],
//     );
//   }
//
//   void _printAllValues() {
//     print("Category: $category");
//     print("SubCategory: $subCategory");
//     print("Site: $site");
//     print("Location: $location");
//     print("Status: $status");
//     print("Tag ID: $tagId");
//
//     print("Brand: ${brandController.text}");
//     print("Model: ${modelController.text}");
//     print("Serial: ${serialController.text}");
//     print("Description: ${descriptionController.text}");
//
//     if (category == "Computer Assets") {
//       print("Processor: ${processorController.text}");
//       print("Processor Gen: ${processorGenController.text}");
//       print("RAM1: ${ram1Controller.text} (${ram1BrandController.text})");
//       print("RAM2: ${ram2Controller.text} (${ram2BrandController.text})");
//       print("Total RAM: ${totalRamController.text}");
//       print("Device ID: ${deviceIdController.text}");
//       print("Warranty Start: $warrantyStart");
//       print("Warranty Months: ${warrantyMonthsController.text}");
//       print("Warranty Expire: $warrantyExpire");
//     }
//
//     if (category == "External Equipment") {
//       print("Bag: $bagOption");
//       print("Keyboard: $keyboardOption");
//       print("Mouse: $mouseOption");
//       print("Charger: $chargerOption");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height * 0.85,
//             maxWidth: 750),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("Add New Asset",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 14),
//               _buildStepIndicatorWithLabels(),
//               const SizedBox(height: 20),
//               if (currentStep == 1) _buildBasicInformationStep(),
//               if (currentStep == 2) _buildDetailsStep(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBasicInformationStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Basic Information", style: TextStyle(fontWeight: FontWeight.w500)),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: _dropdownWithHeading(
//                 heading: "Category",
//                 hint: "Select Category",
//                 value: category,
//                 items: ["Computer Assets", "External Equipment"],
//                 onChanged: (val) {
//                   setState(() {
//                     category = val;
//                     subCategory = null;
//                     _generateTagId();
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: _dropdownWithHeading(
//                 heading: "Sub Category",
//                 hint: "Select Sub Category",
//                 value: subCategory,
//                 items: category == "Computer Assets"
//                     ? ["Laptop", "Desktop"]
//                     : category == "External Equipment"
//                     ? ["Bag", "Charger", "Keyboard", "LCD-Monitors", "Mouse"]
//                     : [],
//                 onChanged: (val) {
//                   setState(() {
//                     subCategory = val;
//                     _generateTagId();
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: _dropdownWithHeading(
//                 heading: "Site",
//                 hint: "Select Site",
//                 value: site,
//                 items: ["Head Office",],
//                 onChanged: (val) => setState(() => site = val),
//               ),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: _dropdownWithHeading(
//                 heading: "Location",
//                 hint: "Select Location",
//                 value: location,
//                 items: ["Corporate"],
//                 onChanged: (val) => setState(() => location = val),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         _dropdownWithHeading(
//           heading: "Status",
//           hint: "Status",
//           value: status,
//           items: ["Available"],
//           onChanged: (val) => setState(() => status = val),
//         ),
//         const SizedBox(height: 16),
//         if (tagId != null)
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//                 color: Colors.blue[50], borderRadius: BorderRadius.circular(14)),
//             child: Row(children: [
//               const Icon(Icons.qr_code, color: Colors.blue),
//               const SizedBox(width: 8),
//               Text("Generated Asset Tag ID: $tagId",
//                   style: const TextStyle(
//                       color: Colors.blue, fontWeight: FontWeight.bold)),
//             ]),
//           ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             TextButton(
//                 onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
//             const SizedBox(width: 14),
//             ElevatedButton(
//                 onPressed: () => setState(() => currentStep = 2),
//                 child: const Text("Next Step")),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDetailsStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           category == "Computer Assets"
//               ? "Computer Asset Details"
//               : "External Equipment Details",
//           style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//         ),
//         const SizedBox(height: 16),
//         if (category == "Computer Assets") _buildComputerAssetsForm(),
//         if (category == "External Equipment") _buildExternalEquipmentForm(),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             TextButton(
//                 onPressed: () => setState(() => currentStep = 1),
//                 child: const Text("Previous")),
//             const SizedBox(width: 14),
//             /*   ElevatedButton(
//                 onPressed: () {
//                   _printAllValues();
//                   Navigator.pop(context); // close dialog after printing
//                 },
//                 child: const Text("Add Asset")),*/
//
//             ElevatedButton(
//               onPressed: () async {
//                 _printAllValues();
//
//                 try {
//                   var headers = {
//                     'Content-Type': 'application/json',
//                   };
//
//                   var data = json.encode({
//                     "Category": category,
//                     "Sub Category": subCategory,
//                     "Site": site,
//                     "Location": location,
//                     "Status": status,
//                     "Asset Tag ID": tagId,
//                     "Brand": brandController.text,
//                     "Model": modelController.text,
//                     "Serial Number": serialController.text,
//                     "Description": descriptionController.text,
//                     "Processor": category == "Computer Assets" ? processorController.text : "",
//                     "Processor Generation": category == "Computer Assets" ? processorGenController.text : "",
//                     "RAM Slot 1": category == "Computer Assets" ? ram1Controller.text : "",
//                     "RAM Slot 1 Brand": category == "Computer Assets" ? ram1BrandController.text : "",
//                     "RAM Slot 2": category == "Computer Assets" ? ram2Controller.text : "",
//                     "RAM Slot 2 Brand": category == "Computer Assets" ? ram2BrandController.text : "",
//                     "Total RAM": category == "Computer Assets" ? totalRamController.text : "",
//                     "Device ID": category == "Computer Assets" ? deviceIdController.text : "",
//                     "Warranty Start Date": category == "Computer Assets" ? warrantyStart : "",
//                     "Warranty (Months)": category == "Computer Assets" ? warrantyMonthsController.text : "",
//                     "Warranty Expire Date": category == "Computer Assets" ? warrantyExpire : "",
//                     "Bag": category == "External Equipment" ? bagOption : "",
//                     "Keyboard": category == "External Equipment" ? keyboardOption : "",
//                     "Mouse": category == "External Equipment" ? mouseOption : "",
//                     "Charger": category == "External Equipment" ? chargerOption : "",
//                   });
//
//                   var dio = Dio();
//                   var response = await dio.request(
//                     'https://thrive-assetsmanagements.onrender.com/api/assetmanagements/upload',
//                     options: Options(
//                       method: 'POST',
//                       headers: headers,
//                     ),
//                     data: data,
//                   );
//
//                   if (response.statusCode == 200) {
//                     // Success message
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("✅ Asset Uploaded Successfully"),
//                         backgroundColor: Colors.green,
//                         duration: Duration(seconds: 2),
//                       ),
//                     );
//
//                     // Refresh current screen
//                     setState(() {});
//
//                     // Close dialog
//                     Navigator.pop(context);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("❌ Error: ${response.statusMessage}"),
//                         backgroundColor: Colors.red,
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );
//                   }
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("⚠️ Exception: $e"),
//                       backgroundColor: Colors.orange,
//                       duration: const Duration(seconds: 2),
//                     ),
//                   );
//                 }
//               },
//               child: const Text("Add Asset"),
//             ),
//
//
//
//           ],
//         ),
//       ],
//     );
//   }
//
//   // ---------------- Computer & External Equipment Forms ----------------
//   Widget _buildComputerAssetsForm() {
//     return Column(
//       children: [
//         Row(children: [
//           Expanded(
//               child:
//               _textFieldWithHeading(heading: "Brand", controller: brandController, hint: "e.g. Dell")),
//           const SizedBox(width: 14),
//           Expanded(
//               child:
//               _textFieldWithHeading(heading: "Model", controller: modelController, hint: "e.g. Latitude")),
//         ]),
//         const SizedBox(height: 14),
//         Row(children: [
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "Serial Number", controller: serialController, hint: "Serial Number")),
//           const SizedBox(width: 14),
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "Description", controller: descriptionController, hint: "Description")),
//         ]),
//         const SizedBox(height: 14),
//         Row(children: [
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "Processor", controller: processorController, hint: "e.g. Intel i7")),
//           const SizedBox(width: 14),
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "Processor Generation",
//                   controller: processorGenController,
//                   hint: "e.g. 11th Gen")),
//         ]),
//         const SizedBox(height: 14),
//         Row(children: [
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "Total RAM",
//                   controller: totalRamController,
//                   hint: "e.g. 16GB",
//                   readOnly: true)),
//           const SizedBox(width: 14),
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "RAM Slot 1", controller: ram1Controller, hint: "e.g. 8GB")),
//           const SizedBox(width: 14),
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "RAM Slot 2", controller: ram2Controller, hint: "e.g. 8GB")),
//         ]),
//         const SizedBox(height: 14),
//         Row(children: [
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "RAM1 Brand", controller: ram1BrandController, hint: "e.g. Kingston")),
//           const SizedBox(width: 14),
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "RAM2 Brand", controller: ram2BrandController, hint: "e.g. Corsair")),
//         ]),
//         const SizedBox(height: 14),
//         Row(children: [
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "Device ID", controller: deviceIdController, hint: "Device ID")),
//           const SizedBox(width: 14),
//           Expanded(
//               child: _textFieldWithHeading(
//                 heading: "Warranty Start Date",
//                 controller: TextEditingController(
//                     text: warrantyStart != null
//                         ? "${warrantyStart!.month}/${warrantyStart!.day}/${warrantyStart!.year}"
//                         : ""),
//                 hint: "mm/dd/yyyy",
//                 readOnly: true,
//                 onTap: () async {
//                   final picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2100));
//                   if (picked != null) setState(() => warrantyStart = picked);
//                 },
//               )),
//         ]),
//         const SizedBox(height: 14),
//         Row(children: [
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "Warranty (Months)",
//                   controller: warrantyMonthsController,
//                   hint: "e.g. 12")),
//           const SizedBox(width: 14),
//           Expanded(
//               child: _textFieldWithHeading(
//                 heading: "Warranty Expire Date",
//                 controller: TextEditingController(
//                     text: warrantyExpire != null
//                         ? "${warrantyExpire!.month}/${warrantyExpire!.day}/${warrantyExpire!.year}"
//                         : ""),
//                 hint: "mm/dd/yyyy",
//                 readOnly: true,
//                 onTap: () async {
//                   final picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2100));
//                   if (picked != null) setState(() => warrantyExpire = picked);
//                 },
//               )),
//         ]),
//       ],
//     );
//   }
//
//   Widget _buildExternalEquipmentForm() {
//     return Column(
//       children: [
//         Row(children: [
//           Expanded(
//               child:
//               _textFieldWithHeading(heading: "Brand", controller: brandController, hint: "e.g. Dell")),
//           const SizedBox(width: 14),
//           Expanded(
//               child:
//               _textFieldWithHeading(heading: "Model", controller: modelController, hint: "Model Name")),
//         ]),
//         const SizedBox(height: 14),
//         Row(children: [
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "Serial Number", controller: serialController, hint: "Serial Number")),
//           const SizedBox(width: 14),
//           Expanded(
//               child: _textFieldWithHeading(
//                   heading: "Description", controller: descriptionController, hint: "Description")),
//         ]),
//         const SizedBox(height: 14),
//         Row(
//           children: [
//             if (subCategory == "Bag")
//               Expanded(
//                   child: _dropdownWithHeading(
//                       heading: "Bag",
//                       hint: "Select",
//                       value: bagOption,
//                       items: ["Yes", "No"],
//                       onChanged: (v) => setState(() => bagOption = v))),
//             if (subCategory == "Keyboard")
//               Expanded(
//                   child: _dropdownWithHeading(
//                       heading: "Keyboard",
//                       hint: "Select",
//                       value: keyboardOption,
//                       items: ["Yes", "No"],
//                       onChanged: (v) => setState(() => keyboardOption = v))),
//             if (subCategory == "Mouse")
//               Expanded(
//                   child: _dropdownWithHeading(
//                       heading: "Mouse",
//                       hint: "Select",
//                       value: mouseOption,
//                       items: ["Yes", "No"],
//                       onChanged: (v) => setState(() => mouseOption = v))),
//           ],
//         ),
//       ],
//     );
//   }
// }
