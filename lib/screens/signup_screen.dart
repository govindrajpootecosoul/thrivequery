import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: name, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: email, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: password, obscureText: true, decoration: InputDecoration(labelText: 'Password')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var result = await authService.signup(name.text, email.text, password.text);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result ?? "Error")));
                Navigator.pop(context);
              },
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
