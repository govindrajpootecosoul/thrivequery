import 'dart:convert';

import 'package:ecosoulquerytracker/api_config.dart';
import 'package:ecosoulquerytracker/dio_client.dart';
import 'package:ecosoulquerytracker/screens/query_form_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/queryservice.dart';



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RegistrationFormUpdated extends StatefulWidget {
//   final Map<String, dynamic>? existingData;

//   RegistrationFormUpdated({this.existingData});

//   @override
//   _RegistrationFormUpdatedState createState() =>
//       _RegistrationFormUpdatedState();
// }

// class _RegistrationFormUpdatedState extends State<RegistrationFormUpdated> {
//   final _formKey = GlobalKey<FormState>();
//   final Dio _dio = Dio();

//   // Form fields
//   String? platform;
//   String? category;
//   String? project;
//   String? task;
//   String? frequency;
//   String? status;
//   String? poc = "";
//   String? projectTags = "";
//   String? sheetDocLink = "";
//   String? taskUpdate = "";
//   String? comment = "";
//   String? createdBy = "";
//   String? alertType = "";
//   String? daysRequired;
//   String? completionPercentage = "";

//   DateTime projectStartDate = DateTime.now();
//   DateTime projectEndDate = DateTime.now().add(Duration(days: 7));

//   // Controllers
//   final TextEditingController _projectController = TextEditingController();
//   final TextEditingController _taskController = TextEditingController();
//   final TextEditingController _frequencyController = TextEditingController();
//   final TextEditingController _daysRequiredController = TextEditingController();
//   final TextEditingController _completionPercentageController =
//       TextEditingController();
//   final TextEditingController _pocController = TextEditingController();
//   final TextEditingController _projectTagsController = TextEditingController();
//   final TextEditingController _sheetDocLinkController = TextEditingController();
//   final TextEditingController _taskUpdateController = TextEditingController();
//   final TextEditingController _commentController = TextEditingController();
//   final TextEditingController _createdByController = TextEditingController();
//   final TextEditingController _alertTypeController = TextEditingController();

//   // Dropdown options
//   final List<String> platformOptions = [
//     'Kinetica Sports',
//     'Brillo',
//     'Vector.Ai',
//   ];
//   final List<String> categoryOptions = [
//     'Kinetica Sports - UK',
//     'Kinetica Sports - UAE',
//     'Kinetica Sports - Germany',
//     'Kinetica Sports - Website',
//     'Brillo-Amazon',
//     'Brillo-Website',
//     'Vector App Task',
//   ];
//   final List<String> statusOptions = [
//     'Not Started',
//     'Ongoing',
//     'In Progress',
//     'Under Client Review',
//     'Delivered',
//     'Recurring',
//     'On Hold',
//     'Yet to Start',
//     'Closed',
//     'Others',
//   ];
//   final List<String> frequencyOptions = [
//     'Daily',
//     'Weekly',
//     'Monthly',
//     'Quarterly',
//     'Yearly',
//   ];
//   final List<String> alertTypeOptions = ['Normal', 'Urgent', 'Critical'];

//   @override
//   void initState() {
//     super.initState();
//     platform = null;
//     category = null;
//     frequency = null;
//     status = null;
//     alertType = null;

//     if (widget.existingData != null) {
//       _loadExistingData();
//     }
//   }

//   void _loadExistingData() {
//     final data = widget.existingData!;
//     setState(() {
//       platform = data['Platform'];
//       if (platform != null && !platformOptions.contains(platform)) {
//         platform = null;
//       }

//       category = data['Category'];
//       if (category != null && !categoryOptions.contains(category)) {
//         category = null;
//       }

//       frequency = data['Frequency'];
//       if (frequency != null && !frequencyOptions.contains(frequency)) {
//         frequency = null;
//       }

//       status = data['Task Status'];
//       if (status != null && !statusOptions.contains(status)) {
//         status = null;
//       }

//       alertType = data['Alert Type'];
//       if (alertType != null && !alertTypeOptions.contains(alertType)) {
//         alertType = null;
//       }

//       project = data['Project'];
//       task = data['Task'];
//       daysRequired = data['No. of Days required']?.toString();
//       completionPercentage = data['Completion %']?.toString() ?? "";
//       poc = data['POC'] ?? "";
//       projectTags = data['Project Tags'] ?? "";
//       sheetDocLink = data['Sheet/Doc Link'] ?? "";
//       taskUpdate = data['Task Update'] ?? "";
//       comment = data['Comment'] ?? "";
//       createdBy = data['Created By'] ?? "";

//       _projectController.text = project ?? '';
//       _taskController.text = task ?? '';
//       _frequencyController.text = frequency ?? '';
//       _daysRequiredController.text = daysRequired ?? '';
//       _completionPercentageController.text = completionPercentage ?? '';
//       _pocController.text = poc ?? '';
//       _projectTagsController.text = projectTags ?? '';
//       _sheetDocLinkController.text = sheetDocLink ?? '';
//       _taskUpdateController.text = taskUpdate ?? '';
//       _commentController.text = comment ?? '';
//       _createdByController.text = createdBy ?? '';
//       _alertTypeController.text = alertType ?? '';

//       try {
//         projectStartDate =
//             data['Project Start date'] != null
//                 ? DateTime.parse(data['Project Start date'])
//                 : DateTime.now();
//       } catch (e) {
//         projectStartDate = DateTime.now();
//       }

//       try {
//         projectEndDate =
//             data['Project Expected End date'] != null
//                 ? DateTime.parse(data['Project Expected End date'])
//                 : DateTime.now().add(Duration(days: 7));
//       } catch (e) {
//         projectEndDate = DateTime.now().add(Duration(days: 7));
//       }
//     });
//   }

//   Future<void> _submitQuery() async {
//     if (!_formKey.currentState!.validate()) return;

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final registrationId = prefs.getString('userId');
//       final userType = prefs.getString('userType');

//       final queryData = {
//         "Platform": platform,
//         "Category": category,
//         "Project": _projectController.text,
//         "Task": _taskController.text,
//         "Frequency":
//             _frequencyController.text.isNotEmpty
//                 ? _frequencyController.text
//                 : "",
//         "No. of Days required": _daysRequiredController.text,
//         "Project Start date": _formatDate(projectStartDate),
//         "Project Expected End date": _formatDate(projectEndDate),
//         "Task Status": status,
//         "Completion %":
//             _completionPercentageController.text.isNotEmpty
//                 ? _completionPercentageController.text
//                 : "",
//         "POC": _pocController.text.isNotEmpty ? _pocController.text : "",
//         "Project Tags":
//             _projectTagsController.text.isNotEmpty
//                 ? _projectTagsController.text
//                 : "",
//         "Sheet/Doc Link":
//             _sheetDocLinkController.text.isNotEmpty
//                 ? _sheetDocLinkController.text
//                 : "",
//         "Task Update":
//             _taskUpdateController.text.isNotEmpty
//                 ? _taskUpdateController.text
//                 : "",
//         "Comment":
//             _commentController.text.isNotEmpty ? _commentController.text : "",
//         "Created By":
//             _createdByController.text.isNotEmpty
//                 ? _createdByController.text
//                 : "",
//         "Alert Type":
//             _alertTypeController.text.isNotEmpty
//                 ? _alertTypeController.text
//                 : "",
//         if (widget.existingData != null) "id": widget.existingData!['id'],
//         if (registrationId != null) "registrationId": registrationId,
//         if (userType != null) "userType": userType,
//       };

//       final response = await _dio.post(
//         'http://localhost:5200/api/add-query',
//         data: jsonEncode(queryData),
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Fluttertoast.showToast(
//           msg:
//               "Query ${widget.existingData == null ? 'added' : 'updated'} successfully",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//         );
//         Navigator.pop(context, true);
//       } else {
//         throw Exception(
//           'Failed to submit query: ${response.statusCode} ${response.data}',
//         );
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Error: ${e.toString()}",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//     }
//   }

//   String _formatDate(DateTime date) {
//     return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//   }

//   Future<void> _selectDate(BuildContext context, bool isStartDate) async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: isStartDate ? projectStartDate : projectEndDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         if (isStartDate) {
//           projectStartDate = pickedDate;
//         } else {
//           projectEndDate = pickedDate;
//         }
//       });
//     }
//   }

//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(),
//       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//     );
//   }

//   Widget _buildDropdownFormField({
//     required String label,
//     required String? value,
//     required List<String> items,
//     required Function(String?) onChanged,
//     bool isRequired = false,
//   }) {
//     return DropdownButtonFormField<String>(
//       decoration: _inputDecoration(label + (isRequired ? ' *' : '')),
//       value: value,
//       items: [
//         DropdownMenuItem<String>(
//           value: null,
//           child: Text('Select $label', style: TextStyle(color: Colors.grey)),
//         ),
//         ...items
//             .map((item) => DropdownMenuItem(value: item, child: Text(item)))
//             .toList(),
//       ],
//       onChanged: onChanged,
//       validator:
//           isRequired
//               ? (value) => value == null ? 'Required field' : null
//               : null,
//     );
//   }

//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String label,
//     bool isRequired = false,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: _inputDecoration(label + (isRequired ? ' *' : '')),
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       validator:
//           isRequired
//               ? (value) => value!.isEmpty ? 'Required field' : null
//               : null,
//     );
//   }

//   Widget _buildDateField(String label, DateTime date, bool isStartDate) {
//     return InkWell(
//       onTap: () => _selectDate(context, isStartDate),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(4),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               '$label: ${_formatDate(date)}',
//               style: TextStyle(fontSize: 16),
//             ),
//             Icon(Icons.calendar_today, size: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         constraints: BoxConstraints(maxWidth: 1200),
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.9),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 10,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // First row with 3 fields
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildDropdownFormField(
//                           label: 'Platform',
//                           value: platform,
//                           items: platformOptions,
//                           onChanged:
//                               (value) => setState(() => platform = value),
//                           isRequired: true,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildDropdownFormField(
//                           label: 'Category',
//                           value: category,
//                           items: categoryOptions,
//                           onChanged:
//                               (value) => setState(() => category = value),
//                           isRequired: true,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildTextFormField(
//                           controller: _projectController,
//                           label: 'Project',
//                           isRequired: true,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Second row with 3 fields
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildTextFormField(
//                           controller: _taskController,
//                           label: 'Task',
//                           isRequired: true,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildDropdownFormField(
//                           label: 'Frequency',
//                           value: frequency,
//                           items: frequencyOptions,
//                           onChanged:
//                               (value) => setState(() => frequency = value),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildTextFormField(
//                           controller: _daysRequiredController,
//                           label: 'No. of Days required',
//                           isRequired: true,
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Third row with date fields
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildDateField(
//                           'Project Start Date',
//                           projectStartDate,
//                           true,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildDateField(
//                           'Project Expected End Date',
//                           projectEndDate,
//                           false,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildDropdownFormField(
//                           label: 'Task Status',
//                           value: status,
//                           items: statusOptions,
//                           onChanged: (value) => setState(() => status = value),
//                           isRequired: true,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Fourth row with 3 fields
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildTextFormField(
//                           controller: _completionPercentageController,
//                           label: 'Completion %',
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildTextFormField(
//                           controller: _pocController,
//                           label: 'POC',
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildTextFormField(
//                           controller: _projectTagsController,
//                           label: 'Project Tags',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Fifth row with 3 fields
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildTextFormField(
//                           controller: _sheetDocLinkController,
//                           label: 'Sheet/Doc Link',
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildTextFormField(
//                           controller: _createdByController,
//                           label: 'Created By',
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: _buildDropdownFormField(
//                           label: 'Alert Type',
//                           value: alertType,
//                           items: alertTypeOptions,
//                           onChanged:
//                               (value) => setState(() => alertType = value),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Sixth row with Task Update (single column)
//                 Padding(
//                   padding: EdgeInsets.all(8),
//                   child: _buildTextFormField(
//                     controller: _taskUpdateController,
//                     label: 'Task Update',
//                     maxLines: 3,
//                   ),
//                 ),

//                 // Seventh row with Comment (single column)
//                 Padding(
//                   padding: EdgeInsets.all(8),
//                   child: _buildTextFormField(
//                     controller: _commentController,
//                     label: 'Comment',
//                     maxLines: 3,
//                   ),
//                 ),

//                 // Submit button
//                 Padding(
//                   padding: EdgeInsets.all(16),
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     onPressed: _submitQuery,
//                     child: Text(
//                       widget.existingData == null
//                           ? 'Submit Query'
//                           : 'Update Query',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _projectController.dispose();
//     _taskController.dispose();
//     _frequencyController.dispose();
//     _daysRequiredController.dispose();
//     _completionPercentageController.dispose();
//     _pocController.dispose();
//     _projectTagsController.dispose();
//     _sheetDocLinkController.dispose();
//     _taskUpdateController.dispose();
//     _commentController.dispose();
//     _createdByController.dispose();
//     _alertTypeController.dispose();
//     super.dispose();
//   }
// }







import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationFormUpdated extends StatefulWidget {
  final Map<String, dynamic>? existingData;

  const RegistrationFormUpdated({Key? key, this.existingData}) : super(key: key);

  @override
  _RegistrationFormUpdatedState createState() => _RegistrationFormUpdatedState();
}

class _RegistrationFormUpdatedState extends State<RegistrationFormUpdated> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  // Form fields
  String? platform;
  String? category;
  String? project;
  String? task;
  String? frequency;
  String? status;
  String? poc = "";
  String? projectTags = "";
  String? sheetDocLink = "";
  String? taskUpdate = "";
  String? comment = "";
  String? createdBy = "";
  String? alertType = "";
  String? daysRequired;
  String? completionPercentage = "";

  DateTime projectStartDate = DateTime.now();
  DateTime projectEndDate = DateTime.now().add(const Duration(days: 7));

  // Controllers
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _daysRequiredController = TextEditingController();
  final TextEditingController _completionPercentageController = TextEditingController();
  final TextEditingController _pocController = TextEditingController();
  final TextEditingController _projectTagsController = TextEditingController();
  final TextEditingController _sheetDocLinkController = TextEditingController();
  final TextEditingController _taskUpdateController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _createdByController = TextEditingController();
  final TextEditingController _alertTypeController = TextEditingController();

  // Dropdown options
  final List<String> platformOptions = [
    'Kinetica Sports',
    'Brillo',
    'Vector.Ai',
  ];

  final List<String> categoryOptions = [
    'Kinetica Sports - UK',
    'Kinetica Sports - UAE',
    'Kinetica Sports - Germany',
    'Kinetica Sports - Website',
    'Brillo-Amazon',
    'Brillo-Website',
    'Vector App Task',
  ];

  final List<String> statusOptions = [
    'Not Started',
    'Ongoing',
    'In Progress',
    'Under Client Review',
    'Delivered',
    'Recurring',
    'On Hold',
    'Yet to Start',
    'Closed',
    'Others',
  ];

  final List<String> frequencyOptions = [
    'Daily',
    'Weekly',
    'Monthly',
    'Quarterly',
    'Yearly',
  ];

  final List<String> alertTypeOptions = ['Normal', 'Urgent', 'Critical'];

  @override
  void initState() {
    super.initState();
    platform = null;
    category = null;
    frequency = null;
    status = null;
    alertType = null;

    if (widget.existingData != null) {
      _loadExistingData();
    }
  }

  void _loadExistingData() {
    final data = widget.existingData!;
    setState(() {
      platform = data['Platform'];
      if (platform != null && !platformOptions.contains(platform)) {
        platform = null;
      }

      category = data['Category'];
      if (category != null && !categoryOptions.contains(category)) {
        category = null;
      }

      frequency = data['Frequency'];
      if (frequency != null && !frequencyOptions.contains(frequency)) {
        frequency = null;
      }

      status = data['Task Status'];
      if (status != null && !statusOptions.contains(status)) {
        status = null;
      }

      alertType = data['Alert Type'];
      if (alertType != null && !alertTypeOptions.contains(alertType)) {
        alertType = null;
      }

      project = data['Project'];
      task = data['Task'];
      daysRequired = data['No. of Days required']?.toString();
      completionPercentage = data['Completion %']?.toString() ?? "";
      poc = data['POC'] ?? "";
      projectTags = data['Project Tags'] ?? "";
      sheetDocLink = data['Sheet/Doc Link'] ?? "";
      taskUpdate = data['Task Update'] ?? "";
      comment = data['Comment'] ?? "";
      createdBy = data['Created By'] ?? "";

      _projectController.text = project ?? '';
      _taskController.text = task ?? '';
      _frequencyController.text = frequency ?? '';
      _daysRequiredController.text = daysRequired ?? '';
      _completionPercentageController.text = completionPercentage ?? '';
      _pocController.text = poc ?? '';
      _projectTagsController.text = projectTags ?? '';
      _sheetDocLinkController.text = sheetDocLink ?? '';
      _taskUpdateController.text = taskUpdate ?? '';
      _commentController.text = comment ?? '';
      _createdByController.text = createdBy ?? '';
      _alertTypeController.text = alertType ?? '';

      try {
        projectStartDate = data['Project Start date'] != null
            ? DateTime.parse(data['Project Start date'])
            : DateTime.now();
      } catch (e) {
        projectStartDate = DateTime.now();
      }

      try {
        projectEndDate = data['Project Expected End date'] != null
            ? DateTime.parse(data['Project Expected End date'])
            : DateTime.now().add(const Duration(days: 7));
      } catch (e) {
        projectEndDate = DateTime.now().add(const Duration(days: 7));
      }
    });
  }

  // Future<void> _submitQuery() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final registrationId = prefs.getString('userId');
  //     final userType = prefs.getString('userType');

  //     final queryData = {
  //       "Platform": platform,
  //       "Category": category,
  //       "Project": _projectController.text,
  //       "Task": _taskController.text,
  //       "Frequency": _frequencyController.text.isNotEmpty ? _frequencyController.text : "",
  //       "No. of Days required": _daysRequiredController.text,
  //       "Project Start date": _formatDate(projectStartDate),
  //       "Project Expected End date": _formatDate(projectEndDate),
  //       "Task Status": status,
  //       "Completion %": _completionPercentageController.text.isNotEmpty
  //           ? _completionPercentageController.text : "",
  //       "POC": _pocController.text.isNotEmpty ? _pocController.text : "",
  //       "Project Tags": _projectTagsController.text.isNotEmpty
  //           ? _projectTagsController.text : "",
  //       "Sheet/Doc Link": _sheetDocLinkController.text.isNotEmpty
  //           ? _sheetDocLinkController.text : "",
  //       "Task Update": _taskUpdateController.text.isNotEmpty
  //           ? _taskUpdateController.text : "",
  //       "Comment": _commentController.text.isNotEmpty ? _commentController.text : "",
  //       "Created By": _createdByController.text.isNotEmpty
  //           ? _createdByController.text : "",
  //       "Alert Type": _alertTypeController.text.isNotEmpty
  //           ? _alertTypeController.text : "",
  //       if (widget.existingData != null) "id": widget.existingData!['id'],
  //       if (registrationId != null) "registrationId": registrationId,
  //       if (userType != null) "userType": userType,
  //     };
  //     String url = widget.existingData == null ?'http://localhost:5200/api/add-query' : "http://localhost:5200/api/update-query";
  //     final response = await _dio.post(
  //       url,
  //       data: jsonEncode(queryData),
  //       options: Options(headers: {'Content-Type': 'application/json'}),
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       Fluttertoast.showToast(
  //         msg: "Query ${widget.existingData == null ? 'added' : 'updated'} successfully",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //       );
  //       Navigator.pop(context, true);
  //     } else {
  //       throw Exception('Failed to submit query: ${response.statusCode} ${response.data}');
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: "Error: ${e.toString()}",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //     );
  //   }
  // }


  Future<void> _submitQuery() async {
  if (!_formKey.currentState!.validate()) return;

  try {
    final prefs = await SharedPreferences.getInstance();
    // final registrationId = prefs.getString('userId');
    final registrationId = widget.existingData != null ? widget.existingData!['registrationId'] : null;
    final userType = prefs.getString('userType');

    final queryData = {
      "Platform": platform,
      "Category": category,
      "Project": _projectController.text,
      "Task": _taskController.text,
      "Frequency": _frequencyController.text.isNotEmpty ? _frequencyController.text : "",
      "No. of Days required": _daysRequiredController.text,
      "Project Start date": _formatDate(projectStartDate),
      "Project Expected End date": _formatDate(projectEndDate),
      "Task Status": status,
      "Completion %": _completionPercentageController.text.isNotEmpty
          ? _completionPercentageController.text
          : "",
      "POC": _pocController.text.isNotEmpty ? _pocController.text : "",
      "Project Tags": _projectTagsController.text.isNotEmpty
          ? _projectTagsController.text
          : "",
      "Sheet/Doc Link": _sheetDocLinkController.text.isNotEmpty
          ? _sheetDocLinkController.text
          : "",
      "Task Update": _taskUpdateController.text.isNotEmpty
          ? _taskUpdateController.text
          : "",
      "Comment": _commentController.text.isNotEmpty ? _commentController.text : "",
      "Created By": _createdByController.text.isNotEmpty
          ? _createdByController.text
          : "",
      "Alert Type": alertType,
      if (registrationId != null) "registrationId": registrationId,
      if (userType != null) "userType": userType,
    };

    final isUpdate = widget.existingData != null;

    final url = isUpdate
        ? "https://thriveworklytics.thrivebrands.ai/api/update-query"
        : "https://thriveworklytics.thrivebrands.ai/api/add-query";

    final response = await _dio.request(
      url,
      data: jsonEncode(queryData),
      options: Options(
        method: isUpdate ? 'PUT' : 'POST',
        headers: {'Content-Type': 'application/json'},
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(
        msg: "Query ${isUpdate ? 'updated' : 'added'} successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.pop(context, true);
    } else {
      throw Exception('Failed to submit query: ${response.statusCode} ${response.data}');
    }
  } catch (e) {
    print("Error: ${e.toString()}");
    Fluttertoast.showToast(
      msg: "Error: ${e.toString()}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}


  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? projectStartDate : projectEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          projectStartDate = pickedDate;
        } else {
          projectEndDate = pickedDate;
        }
      });
    }
  }

  InputDecoration _inputDecoration(String label, {bool isRequired = false}) {
    return InputDecoration(
      labelText: label + (isRequired ? ' *' : ''),
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildDropdownFormField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    bool isRequired = false,
  }) {
    return DropdownButtonFormField<String>(
      decoration: _inputDecoration(label, isRequired: isRequired),
      value: value,
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text(
            'Select $label',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        ...items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        )).toList(),
      ],
      onChanged: onChanged,
      validator: isRequired ? (value) => value == null ? 'Required field' : null : null,
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, isRequired: isRequired),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: isRequired ? (value) => value!.isEmpty ? 'Required field' : null : null,
    );
  }

  Widget _buildDateField(String label, DateTime date, bool isStartDate) {
    return InkWell(
      onTap: () => _selectDate(context, isStartDate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label: ${_formatDate(date)}',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_today, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // First row with 3 fields
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildDropdownFormField(
                          label: 'Platform',
                          value: platform,
                          items: platformOptions,
                          onChanged: (value) => setState(() => platform = value),
                          isRequired: true,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildDropdownFormField(
                          label: 'Category',
                          value: category,
                          items: categoryOptions,
                          onChanged: (value) => setState(() => category = value),
                          isRequired: true,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildTextFormField(
                          controller: _projectController,
                          label: 'Project',
                          isRequired: true,
                        ),
                      ),
                    ),
                  ],
                ),

                // Second row with 3 fields
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildTextFormField(
                          controller: _taskController,
                          label: 'Task',
                          isRequired: true,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildDropdownFormField(
                          label: 'Frequency',
                          value: frequency,
                          items: frequencyOptions,
                          onChanged: (value) => setState(() => frequency = value),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildTextFormField(
                          controller: _daysRequiredController,
                          label: 'No. of Days required',
                          isRequired: true,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),

                // Third row with date fields
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildDateField('Project Start Date', projectStartDate, true),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildDateField('Project Expected End Date', projectEndDate, false),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildDropdownFormField(
                          label: 'Task Status',
                          value: status,
                          items: statusOptions,
                          onChanged: (value) => setState(() => status = value),
                          isRequired: true,
                        ),
                      ),
                    ),
                  ],
                ),

                // Fourth row with 3 fields
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildTextFormField(
                          controller: _completionPercentageController,
                          label: 'Completion %',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildTextFormField(
                          controller: _pocController,
                          label: 'POC',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildTextFormField(
                          controller: _projectTagsController,
                          label: 'Project Tags',
                        ),
                      ),
                    ),
                  ],
                ),

                // Fifth row with 3 fields
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildTextFormField(
                          controller: _sheetDocLinkController,
                          label: 'Sheet/Doc Link',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildTextFormField(
                          controller: _createdByController,
                          label: 'Created By',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildDropdownFormField(
                          label: 'Alert Type',
                          value: alertType,
                          items: alertTypeOptions,
                          onChanged: (value) => setState(() => alertType = value),
                        ),
                      ),
                    ),
                  ],
                ),

                // Sixth row with Task Update and Comment in same row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildTextFormField(
                          controller: _taskUpdateController,
                          label: 'Task Update',
                          maxLines: 3,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildTextFormField(
                          controller: _commentController,
                          label: 'Comment',
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ],
                ),

                // Submit button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _submitQuery,
                    child: Text(
                      widget.existingData == null ? 'Submit Query' : 'Update Query',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _projectController.dispose();
    _taskController.dispose();
    _frequencyController.dispose();
    _daysRequiredController.dispose();
    _completionPercentageController.dispose();
    _pocController.dispose();
    _projectTagsController.dispose();
    _sheetDocLinkController.dispose();
    _taskUpdateController.dispose();
    _commentController.dispose();
    _createdByController.dispose();
    _alertTypeController.dispose();
    super.dispose();
  }
}


