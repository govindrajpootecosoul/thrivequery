

import 'dart:convert';
import 'package:ecosoulquerytracker/api_config.dart';
import 'package:ecosoulquerytracker/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String selectedRole = 'User';
  List<String> selectedDepartments = [];
  String selectedUserForEdit = '';
  String? userTypes = '';
  String? upadtee='';

  List<String> roles = ['User', 'Admin',];
  List<String> departments = ['Kinetica', 'Brillo', 'Vector.AI'];
  List<Map<String, String>> existingUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> createUser() async {
    String name = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String userType = selectedRole.toLowerCase().replaceAll('-', '');

    if (name.isEmpty || email.isEmpty || password.isEmpty || selectedDepartments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill all the fields")),
      );
      return;
    }

    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({
      "name": name,
      "email": email,
      "password": password,
      "userType": userType,
      "departments": selectedDepartments
    });

    try {
      var dio = Dio();
      var response = await dio.request(
        //'http://192.168.50.92:5100/api/signup',
        ApiConfig.signup,
        options: Options(
          method: 'POST',
          headers: headers,
          validateStatus: (status) => status != null && status < 500,
        ),
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ User created successfully")),
        );
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
        setState(() {
          selectedRole = 'User';
          selectedDepartments = [];
        });
        fetchUsers();
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❗User already registered with this email")),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Invalid request. Please check the form data.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("🚫 Unexpected Error: \${response.statusMessage}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🔥 Failed to create user: $e")),
      );
    }
  }

  Future<void> updateUser(String userId) async {
    String name = usernameController.text.trim();
    String password = passwordController.text.trim();
    String userType = selectedRole.toLowerCase().replaceAll('-', '');

    if (name.isEmpty || password.isEmpty || selectedDepartments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill all the fields")),
      );
      return;
    }

    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({
      "name": name,
      "password": password,
      "userType": userType,
      "departments": selectedDepartments
    });

    try {
      var dio = Dio();
      var response = await dio.request(
        //'http://192.168.50.92:5100/api/users/$userId',
        '${ApiConfig.users_list}/$userId',
        options: Options(method: 'PUT', headers: headers),
        data: data,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ User updated successfully")),
        );
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
        setState(() {
          selectedDepartments = [];
          selectedRole = 'User';
          selectedUserForEdit = '';
        });
        fetchUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Update failed: \${response.statusMessage}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🔥 Error updating user: $e")),
      );
    }
  }

  Future<void> fetchUsers() async {
    try {
      var dio = Dio();
      //var response = await dio.get('http://192.168.50.92:5100/api/usersall_details');
      var response = await dio.get(ApiConfig.all_users_auth);

      if (response.statusCode == 200) {
        List<dynamic> users = response.data['users'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userTypes = prefs.getString('userType')!;

        setState(() {
          existingUsers = users.map<Map<String, String>>((user) {
            return {
              'id': user['id'] ?? '',
              'username': user['name'] ?? 'Unknown',
              'email': user['email'] ?? '',
              'password': user['password'] ?? '',
              'role': _formatRole(user['userType'] ?? 'user'),
              'departments': (user['departments'] is List)
                  ? (user['departments'] as List).join(', ')
                  : (user['departments'] ?? ''),
            };
          }).toList();

          if (existingUsers.isNotEmpty) {
            selectedUserForEdit = existingUsers.first['id']!;
          }
        });
      } else {
        print('Error: ${response.statusMessage}');
      }
    } catch (e) {
      print('Failed to fetch users: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
     final dio = Dio();
      final response = await dio.request(
       // 'http://192.168.50.92:5100/api/users/$userId',
        '${ApiConfig.users_list}$userId',
        //'http://localhost:5100/api/users/1dac4d20-eae8-4327-abf2-8f057a7ff816',
        options: Options(method: 'DELETE'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ User deleted")),
        );
        fetchUsers(); // refresh list
      } else {
        print("Print errro ${response.statusMessage}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to delete user: ${response.statusMessage}")),
        );
      }
    } catch (e) {
      print("print ee ,,,,,, ${e}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🔥 Error deleting user: $e")),
      );
    }
  }


  String _formatRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Admin';
      default:
        return 'User';
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Admin Panel"),
        ),

        body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/tbg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(

            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Add New User", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("Existing Users", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Card(
                        color: Colors.black87,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              _buildTextField(usernameController, 'Username'),
                              _buildTextField(emailController, 'Email'),
                              _buildPasswordField(passwordController, 'Password'),

                              /// ✅ Radio Buttons for Role
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text("Role", style: TextStyle(color: Colors.white)),
                                  ),
                                  ...roles.map((role) {
                                    return RadioListTile<String>(
                                      value: role,
                                      groupValue: selectedRole,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedRole = value!;
                                        });
                                      },
                                      title: Text(role, style: const TextStyle(color: Colors.white)),
                                      activeColor: Colors.green,
                                      controlAffinity: ListTileControlAffinity.leading,
                                      tileColor: Colors.black26,
                                    );
                                  }).toList(),
                                ],
                              ),

                              /// ✅ Checkboxes for Departments
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text("Platforms", style: TextStyle(color: Colors.white)),
                                  ),
                                  ...departments.map((dep) {
                                    return CheckboxListTile(
                                      value: selectedDepartments.contains(dep),
                                      title: Text(dep, style: const TextStyle(color: Colors.white)),
                                      activeColor: Colors.green,
                                      checkColor: Colors.black,
                                      controlAffinity: ListTileControlAffinity.leading,
                                      onChanged: (bool? selected) {
                                        setState(() {
                                          if (selected == true) {
                                            selectedDepartments.add(dep);
                                          } else {
                                            selectedDepartments.remove(dep);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),

                              const SizedBox(height: 10),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     createUser();
                              //     print("username ${usernameController.text}");
                              //     print("email ${emailController.text}");
                              //     print("pass ${passwordController.text}");
                              //     print("role $selectedRole");
                              //     print("departments $selectedDepartments");
                              //   },
                              //   child: const Text("Create User"),
                              // ) ,

                              // if (upadtee == '1')
                              //   ElevatedButton(
                              //     onPressed: () {
                              //       updateUser(selectedUserForEdit);
                              //     },
                              //     child: const Text("Update User"),
                              //   )
                              // else
                              //   ElevatedButton(
                              //     onPressed: () {
                              //       createUser();
                              //     },
                              //     child: const Text("Create User"),
                              //   ),



                             if( upadtee=="1")
                              ElevatedButton(
                                onPressed: () {
                                  //createUser();
                                  updateUser(selectedUserForEdit);
                                  upadtee="0";
                                  print("username ${usernameController.text}");
                                  print("email ${emailController.text}");
                                  print("pass ${passwordController.text}");
                                  print("role $selectedRole");
                                  print("departments $selectedDepartments");
                                },
                                child: const Text("Update User"),
                              ),

                              if( upadtee!="1")
                                ElevatedButton(
                          onPressed: () {
                            createUser();
                            print("username ${usernameController.text}");
                            print("email ${emailController.text}");
                            print("pass ${passwordController.text}");
                            print("role $selectedRole");
                            print("departments $selectedDepartments");
                          },
                          child: const Text("Create User"),
                        ) ,

                  ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Card(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Username')),
                              DataColumn(label: Text('Role')),
                              DataColumn(label: Text('Departments')),
                              if (userTypes == "superadmin") DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Password')),
                              DataColumn(label: Text('Edit')),    // ✅ New column
                              DataColumn(label: Text('Delete')),  // ✅ New column
                            ],
                            rows: existingUsers.map((user) {
                              return DataRow(cells: [
                                DataCell(Text(user['username'] ?? '')),
                                DataCell(Text(user['role'] ?? '')),
                                DataCell(Text(user['departments'] ?? '')),
                                if (userTypes == "superadmin") DataCell(Text(user['email'] ?? '')),
                                DataCell(Text(user['password'] ?? '')),

                                /// ✅ Edit Button
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                    //  upadtee;
                                      print("user id>>>>>>>>>>> ${user['id']}");

                                      setState(() {
                                        upadtee='1';
                                        usernameController.text = user['username'] ?? '';
                                        emailController.text = user['email'] ?? '';
                                        passwordController.text = user['password'] ?? '';
                                        selectedRole = user['role'] ?? 'User';
                                        selectedDepartments = (user['departments'] ?? '')
                                            .split(',')
                                            .map((e) => e.trim())
                                            .toList();
                                      });
                                    },
                                  ),
                                ),

                                /// ✅ Delete Button
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      print("user id>>>>>>>>>>> ${user['id']}");
                                      deleteUser("${user['id']}");
                                     // _confirmDelete(user['id']!, user['username']!);
                                    },
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),


                    /*    Expanded(
                      child: Card(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Username')),
                              DataColumn(label: Text('Role')),
                              DataColumn(label: Text('Departments')),
                              if (userTypes == "superadmin") DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Password')),
                            ],
                            rows: existingUsers
                                .map((user) => DataRow(cells: [
                              DataCell(Text(user['username'] ?? '')),
                              DataCell(Text(user['role'] ?? '')),
                              DataCell(Text(user['departments'] ?? '')),
                              if (userTypes == "superadmin") DataCell(Text(user['email'] ?? '')),
                              DataCell(Text(user['password'] ?? '')),
                            ]))
                                .toList(),
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black26,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black26,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.visibility, color: Colors.white70),
        ),
      ),
    );
  }
}
