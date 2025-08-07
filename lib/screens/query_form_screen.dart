
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

class RegistrationForm extends StatefulWidget {
  final Map<String, dynamic>? existingData;

  const RegistrationForm({super.key, this.existingData});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  String? platform;
  String? status;
  String countryCode = '+91';

  DateTime dateReceived = DateTime.now();
  DateTime? callingDate;

  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final locationController = TextEditingController();
  final queryController = TextEditingController();
  final remarkController = TextEditingController();

  List<Map<String, String>> _users = [];
  String? _selectedUserId;

 final dio = Dio();
  final queryService = QueryService();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      final data = widget.existingData!;
      platform = data['platform'];
      status = data['status'];
      nameController.text = data['name'] ?? '';
      contactController.text = data['contact']?.replaceAll('+91 ', '') ?? '';
      emailController.text = data['email'] ?? '';
      companyController.text = data['company'] ?? '';
      locationController.text = data['location'] ?? '';
      queryController.text = data['query'] ?? '';
      remarkController.text = data['remark'] ?? '';
      _selectedUserId = data['assignedTo'];
      dateReceived = DateTime.tryParse(data['dateReceived'] ?? '') ?? DateTime.now();
      callingDate = data['callingDate'] != null && data['callingDate'] != 'Not Set'
          ? DateTime.tryParse(data['callingDate'])
          : null;
    }
    fetchUsers();
  }


  Future<void> fetchUsers() async {
    try {
      var response = await dio.get('http://localhost:5100/api/users');
      if (response.statusCode == 200) {
        final List<dynamic> userList = response.data['users'];
        setState(() {
          _users = userList.map<Map<String, String>>((user) {
            return {
              'id': user['id'].toString(),
              'name': user['name'].toString(),
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Dio Error: $e');
    }
  }

  Future<String?> updateQuery(Map<String, dynamic> data) async {
    try {
      var response = await Dio().put(
       // 'http://192.168.50.92:5100/api/update',
        ApiConfig.update_query,
        data: jsonEncode(data),


        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print("print update response $data");
      if (response.statusCode == 200) {
        return "Query updated successfully";
      } else {
        print("Update erroeeeeer: $response.statusMessage");
        return response.statusMessage ?? "Failed to update";
      }
    } catch (e) {

      print("Update error: $e");
      return "Error occurred";
    }
  }

  void _selectDate(BuildContext context, bool isCallingDate) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: Text('Done'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: isCallingDate
                    ? callingDate ?? DateTime.now()
                    : dateReceived,
                onDateTimeChanged: (val) {
                  setState(() {
                    if (isCallingDate) {
                      callingDate = val;
                    } else {
                      dateReceived = val;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {



    final spacing = SizedBox(height: 12);

    final platformOptions = ['Kinetica Sports', 'Brillo', 'Vector.Ai'];
    final statusOptions = ['Open', 'In Progress', 'close'];

    return Scaffold(

      //appBar: AppBar(title: Text('Registration Form')),

      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(

              image: DecorationImage(
                image: AssetImage('assets/loginbg.png'),
                fit: BoxFit.fill,
              ),


            color: Colors.white.withOpacity(0.9), // Slightly transparent white background
            borderRadius: BorderRadius.circular(16), // Optional rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: ListView(

              children: [
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Platform'),
                  items: platformOptions
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) => setState(() => platform = val),
                  validator: (val) => val == null ? 'Select Platform' : null,
                  value: platformOptions.contains(platform) ? platform : null,
                ),
                spacing,
                TextFormField(
                  controller: nameController,
                  decoration: _inputDecoration('Name'),
                  validator: (val) => val!.isEmpty ? 'Enter Name' : null,
                ),
                spacing,
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    contactController.text = phone.number;
                    countryCode = phone.countryCode;
                  },
                  onSaved: (phone) {
                    contactController.text = phone!.number;
                    countryCode = phone.countryCode;
                  },
                ),
                spacing,
                TextFormField(
                  controller: emailController,
                  decoration: _inputDecoration('Email ID'),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter Email';
                    final emailRegex =
                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    return emailRegex.hasMatch(val) ? null : 'Invalid Email';
                  },
                ),
                spacing,
                TextFormField(
                  controller: companyController,
                  decoration: _inputDecoration('Company Name'),
                ),
                spacing,
                TextFormField(
                  controller: locationController,
                  decoration: _inputDecoration('Location'),
                ),
                spacing,
                TextFormField(
                  controller: queryController,
                  decoration: _inputDecoration('Query'),
                  maxLines: 5,
                ),
                spacing,
                TextFormField(
                  controller: remarkController,
                  decoration: _inputDecoration('Remark'),
                  maxLines: 5,
                ),
                spacing,
                ListTile(
                  title: Text("Date Received: ${dateReceived.toLocal().toString().split(' ')[0]}"),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, false),
                ),
                spacing,
                ListTile(
                  title: Text("Calling Date: ${callingDate != null ? callingDate!.toLocal().toString().split(' ')[0] : 'Not Set'}"),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, true),
                ),
                spacing,


                _users.isEmpty

                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Assigned To'),
                  items: _users.map((user) {
                    return DropdownMenuItem<String>(
                      value: user['id'],

                      child: Text(user['name'] ?? 'No Name'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedUserId = val),
                  validator: (val) => val == null ? 'Select User' : null,
                  value: _users.any((user) => user['id'] == _selectedUserId)
                      ? _selectedUserId
                      : null,
                ),


                spacing,
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Status'),
                  items: statusOptions
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => status = val),
                  validator: (val) => val == null ? 'Select Status' : null,
                  value: statusOptions.contains(status) ? status : null,
                ),
                spacing,

                // ElevatedButton(onPressed: () async {
                //   SharedPreferences prefs = await SharedPreferences.getInstance();
                //   String? registrationId = prefs.getString('userId');
                //   String? userType = prefs.getString('userType');
                //
                //   print("aaaa registrationId,,,,  ${registrationId}");
                //   print("aaaa userType,,,,  ${userType}");
                // }, child:Text("dataeeeeeeeeeee")),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String? registrationId = prefs.getString('userId');
                      String? userType = prefs.getString('userType');


                    print("aaaa registrationId,,,,  $registrationId");
                    print("aaaa id,,,,  ${widget.existingData?['id']}");
                    print("aaaa userType,,,,  $userType");
                    print("aaaa existingData,,,,  ${widget.existingData}");

                      Map<String, dynamic> data = {
                       if( widget.existingData == null)
                        "registrationId": registrationId,
                        if( widget.existingData != null)
                          "registrationId": widget.existingData?['registrationId'],
                        "id": widget.existingData?['id'],
                        "userType": userType,
                        "platform": platform,
                        "name": nameController.text,
                        "contact": '$countryCode ${contactController.text}',
                        "email": emailController.text,
                        "company": companyController.text,
                        "location": locationController.text,
                        "dateReceived": dateReceived.toIso8601String(),
                        "callingDate": callingDate?.toIso8601String() ?? 'Not Set',
                        "query": queryController.text,
                        "remark": remarkController.text,
                        "assignedTo": _selectedUserId,
                        "status": status,
                      };

                      String? response;
                      if (widget.existingData == null) {
                        response = await queryService.submitQuery(data);
                      } else {
                        response = await updateQuery(data);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response ?? "Error")),
                      );

                      Fluttertoast.showToast(
                        msg: widget.existingData == null
                            ? "Successfully Registered"
                            : "Successfully Updated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );

                      Navigator.pop(context, true);

                      if (widget.existingData == null) {
                        setState(() {
                          platform = null;
                          status = null;
                          dateReceived = DateTime.now();
                          callingDate = null;
                          _selectedUserId = null;
                          countryCode = '+91';
                        });
                        nameController.clear();
                        contactController.clear();
                        emailController.clear();
                        companyController.clear();
                        locationController.clear();
                        queryController.clear();
                        remarkController.clear();
                      }
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
















/*
import 'dart:convert';

import 'package:ecosoulquerytracker/screens/query_form_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/queryservice.dart';

class RegistrationForm extends StatefulWidget {
  final Map<String, dynamic>? existingData; // For editing

  RegistrationForm({this.existingData});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  String? platform;
  String? status;
  String countryCode = '+91';

  DateTime dateReceived = DateTime.now();
  DateTime? callingDate;

  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final locationController = TextEditingController();
  final queryController = TextEditingController();
  final remarkController = TextEditingController();

  List<Map<String, String>> _users = [];
  String? _selectedUserId;

 final dio = Dio();
  final queryService = QueryService();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      final data = widget.existingData!;
      platform = data['platform'];
      status = data['status'];
      nameController.text = data['name'] ?? '';
      contactController.text = data['contact'] ?? '';
      emailController.text = data['email'] ?? '';
      companyController.text = data['company'] ?? '';
      locationController.text = data['location'] ?? '';
      queryController.text = data['query'] ?? '';
      remarkController.text = data['remark'] ?? '';
      _selectedUserId = data['assignedTo'];
      dateReceived = DateTime.tryParse(data['dateReceived'] ?? '') ?? DateTime.now();
      callingDate = data['callingDate'] != null && data['callingDate'] != 'Not Set'
          ? DateTime.tryParse(data['callingDate'])
          : null;
    }
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      var response = await dio.request(
        'http://localhost:5100/api/users',
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> userList = data['users'];

        setState(() {
          _users = userList.map<Map<String, String>>((user) {
            return {
              'id': user['id'].toString(),
              'name': user['name'].toString(),
            };
          }).toList();
        });
      } else {
        print("Failed: ${response.statusMessage}");
      }
    } catch (e) {
      print('Dio Error: $e');
    }
  }


  Future<String?> updateQuery(Map<String, dynamic> data) async {
    try {
      var response = await Dio().put(
        'http://localhost:5100/api/update',
        data: jsonEncode(data),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return "Query updated successfully";
      } else {
        return response.statusMessage ?? "Failed to update";
      }
    } catch (e) {
      print("Update error: $e");
      return "Error occurred";
    }
  }

  void _selectDate(BuildContext context, bool isCallingDate) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: Text('Done'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: isCallingDate
                    ? callingDate ?? DateTime.now()
                    : dateReceived,
                onDateTimeChanged: (val) {
                  setState(() {
                    if (isCallingDate) {
                      callingDate = val;
                    } else {
                      dateReceived = val;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = SizedBox(height: 12);

    return Scaffold(
      appBar: AppBar(title: Text('Registration Form')),
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Platform'),
                  items: ['Website', 'Email', 'Phone', 'WhatsApp']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) => setState(() => platform = val),
                  validator: (val) => val == null ? 'Select Platform' : null,
                  value: platform,
                ),
                spacing,
                TextFormField(
                  controller: nameController,
                  decoration: _inputDecoration('Name'),
                  validator: (val) => val!.isEmpty ? 'Enter Name' : null,
                ),
                spacing,
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    print('Changed: ${phone.completeNumber}');
                    contactController.text = phone.completeNumber;
                  },
                  onSaved: (phone) {
                    contactController.text = phone!.completeNumber;
                  },
                ),


                spacing,
                TextFormField(
                  controller: emailController,
                  decoration: _inputDecoration('Email ID'),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter Email';
                    final emailRegex =
                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    return emailRegex.hasMatch(val)
                        ? null
                        : 'Invalid Email';
                  },
                ),
                spacing,
                TextFormField(
                  controller: companyController,
                  decoration: _inputDecoration('Company Name'),
                ),
                spacing,
                TextFormField(
                  controller: locationController,
                  decoration: _inputDecoration('Location'),
                ),
                spacing,
                TextFormField(
                  controller: queryController,
                  decoration: _inputDecoration('Query'),
                  maxLines: 5,
                ),
                spacing,
                TextFormField(
                  controller: remarkController,
                  decoration: _inputDecoration('Remark'),
                  maxLines: 5,
                ),
                spacing,
                ListTile(
                  title: Text(
                      "Date Received: ${dateReceived.toLocal().toString().split(' ')[0]}"),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, false),
                ),
                spacing,
                ListTile(
                  title: Text(
                      "Calling Date: ${callingDate != null ? callingDate!.toLocal().toString().split(' ')[0] : 'Not Set'}"),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, true),
                ),
                spacing,

                _users.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Assigned To'),
                  items: _users.map((user) {
                    return DropdownMenuItem<String>(
                      value: user['id'],
                      child: Text(user['name'] ?? 'No Name'),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => _selectedUserId = val),
                  validator: (val) =>
                  val == null ? 'Select User' : null,
                  value: _selectedUserId,
                ),
                spacing,
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Status'),
                  items: ['Open', 'In Progress', 'Closed']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => status = val),
                  validator: (val) => val == null ? 'Select Status' : null,
                  value: status,
                ),
                spacing,

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String? registrationId = prefs.getString('userId');
                      String? userType = prefs.getString('userType');

                      Map<String, dynamic> data = {
                        "registrationId": registrationId,
                        "id": widget.existingData?['id'], // needed for update
                        "userType": userType,
                        "platform": platform,
                        "name": nameController.text,
                        "contact": '$countryCode ${contactController.text}',
                        "email": emailController.text,
                        "company": companyController.text,
                        "location": locationController.text,
                        "dateReceived": dateReceived.toIso8601String(),
                        "callingDate": callingDate?.toIso8601String() ?? 'Not Set',
                        "query": queryController.text,
                        "remark": remarkController.text,
                        "assignedTo": _selectedUserId,
                        "status": status,
                      };

                      String? response;
                      if (widget.existingData == null) {
                        response = await queryService.submitQuery(data);
                      } else {
                        response = await updateQuery(data);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response ?? "Error")),
                      );

                      Fluttertoast.showToast(
                        msg: widget.existingData == null
                            ? "Successfully Registered"
                            : "Successfully Updated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );

                      // Return to previous screen after update
                      Navigator.pop(context, true);

                      if (widget.existingData == null) {
                        // Reset form if new
                        setState(() {
                          platform = null;
                          status = null;
                          dateReceived = DateTime.now();
                          callingDate = null;
                          _selectedUserId = null;
                          countryCode = '+91';
                        });
                        nameController.clear();
                        contactController.clear();
                        emailController.clear();
                        companyController.clear();
                        locationController.clear();
                        queryController.clear();
                        remarkController.clear();
                      }
                    }
                  },
                  child: Text('Submit'),
                ),


                */
/*     ElevatedButton(

                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String? registrationId = prefs.getString('userId');
                        String? userType = prefs.getString('userType');

                        Map<String, dynamic> data = {
                          "registrationId": registrationId,
                          "id": widget.existingData?['id'], // needed for update
                          "userType": userType,
                          "platform": platform,
                          "name": nameController.text,
                          "contact": '$countryCode ${contactController.text}',
                          "email": emailController.text,
                          "company": companyController.text,
                          "location": locationController.text,
                          "dateReceived": dateReceived.toIso8601String(),
                          "callingDate": callingDate?.toIso8601String() ?? 'Not Set',
                          "query": queryController.text,
                          "remark": remarkController.text,
                          "assignedTo": _selectedUserId,
                          "status": status,
                        };

                        String? response;
                        if (widget.existingData == null) {
                          response = await queryService.submitQuery(data);
                        } else {
                          response = await updateQuery(data); // call update
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response ?? "Error")),
                        );

                        Fluttertoast.showToast(
                          msg: widget.existingData == null ? "Successfully Registered" : "Successfully Updated",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );

                        if (widget.existingData == null) {
                          setState(() {
                            platform = null;
                            status = null;
                            dateReceived = DateTime.now();
                            callingDate = null;
                            _selectedUserId = null;
                            countryCode = '+91';
                          });
                          nameController.clear();
                          contactController.clear();
                          emailController.clear();
                          companyController.clear();
                          locationController.clear();
                          queryController.clear();
                          remarkController.clear();
                        }
                      }
                    },


                    // onPressed: () async {
                  //   if (_formKey.currentState!.validate()) {
                  //     SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  //     String? id = prefs.getString('userId');
                  //     String? userType = prefs.getString('userType');
                  //
                  //     Map<String, dynamic> data = {
                  //       "id": id,
                  //       "userType": userType,
                  //       "platform": platform,
                  //       "name": nameController.text,
                  //       "contact": '$countryCode ${contactController.text}',
                  //       "email": emailController.text,
                  //       "company": companyController.text,
                  //       "location": locationController.text,
                  //       "dateReceived": dateReceived.toIso8601String(),
                  //       "callingDate":
                  //       callingDate?.toIso8601String() ?? 'Not Set',
                  //       "query": queryController.text,
                  //       "remark": remarkController.text,
                  //       "assignedTo": _selectedUserId,
                  //       "status": status,
                  //     };
                  //
                  //     var result = await queryService.submitQuery(data);
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //         SnackBar(content: Text(result ?? "Error")));
                  //
                  //     Fluttertoast.showToast(
                  //       msg: "Successfully Registered",
                  //       toastLength: Toast.LENGTH_SHORT,
                  //       gravity: ToastGravity.BOTTOM,
                  //     );
                  //
                  //     // Reset form
                  //     setState(() {
                  //       platform = null;
                  //       status = null;
                  //       dateReceived = DateTime.now();
                  //       callingDate = null;
                  //       _selectedUserId = null;
                  //       countryCode = '+91';
                  //     });
                  //     nameController.clear();
                  //     contactController.clear();
                  //     emailController.clear();
                  //     companyController.clear();
                  //     locationController.clear();
                  //     queryController.clear();
                  //     remarkController.clear();
                  //   }
                  // },
                  child: Text('Submit'),
                ),*//*

              ],
            ),
          ),
        ),
      ),
    );
  }
}



*/
/*

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/queryservice.dart';

class RegistrationForm extends StatefulWidget {
  final Map<String, dynamic>? existingData;

  RegistrationForm({this.existingData});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _queryService = QueryService();

  // Controllers
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final locationController = TextEditingController();
  final dateReceivedController = TextEditingController();
  final callingDateController = TextEditingController();
  final queryController = TextEditingController();
  final remarkController = TextEditingController();

  String selectedStatus = "Pending";

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      final data = widget.existingData!;
      nameController.text = data['name'] ?? '';
      contactController.text = data['contact'] ?? '';
      emailController.text = data['email'] ?? '';
      companyController.text = data['company'] ?? '';
      locationController.text = data['location'] ?? '';
      dateReceivedController.text = data['dateReceived'] ?? '';
      callingDateController.text = data['callingDate'] ?? '';
      queryController.text = data['query'] ?? '';
      remarkController.text = data['remark'] ?? '';
      selectedStatus = data['status'] ?? 'Pending';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    emailController.dispose();
    companyController.dispose();
    locationController.dispose();
    dateReceivedController.dispose();
    callingDateController.dispose();
    queryController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        "name": nameController.text.trim(),
        "contact": contactController.text.trim(),
        "email": emailController.text.trim(),
        "company": companyController.text.trim(),
        "location": locationController.text.trim(),
        "dateReceived": dateReceivedController.text.trim(),
        "callingDate": callingDateController.text.trim(),
        "query": queryController.text.trim(),
        "remark": remarkController.text.trim(),
        "status": selectedStatus,
      };

      String? result;
      if (widget.existingData != null) {
        // Update
        data["id"] = widget.existingData!['id'];
        data["userType"] = widget.existingData!['userType'];
        data["registrationId"] = widget.existingData!['registrationId'];
        // result = await _queryService.updateQuery(data);
      } else {
        // Create
        //   result = await _queryService.sendQuery(data);
      }

      if (result != null && result.contains("success")) {
        Fluttertoast.showToast(msg: result);
        Navigator.pop(context, true); // return true to refresh
      } else {
        Fluttertoast.showToast(msg: result ?? "Operation failed");
      }
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (val) => val == null || val.isEmpty ? "Required" : null,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingData != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Query' : 'New Query')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Name", nameController),
              SizedBox(height: 12),
              _buildTextField("Contact", contactController, keyboardType: TextInputType.phone),
              SizedBox(height: 12),
              _buildTextField("Email", emailController, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 12),
              _buildTextField("Company", companyController),
              SizedBox(height: 12),
              _buildTextField("Location", locationController),
              SizedBox(height: 12),
              _buildTextField("Date Received", dateReceivedController),
              SizedBox(height: 12),
              _buildTextField("Calling Date", callingDateController),
              SizedBox(height: 12),
              _buildTextField("Query", queryController),
              SizedBox(height: 12),
              _buildTextField("Remark", remarkController),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                onChanged: (val) => setState(() => selectedStatus = val!),
                items: ["Pending", "In Progress", "Completed", "Rejected"]
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                decoration: InputDecoration(labelText: "Status", border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleSubmit,
                child: Text(isEdit ? "Update" : "Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/



