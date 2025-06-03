import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'Tabscreen/mainscrentab.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthService authService = AuthService();

  bool isLoading = false;


  void _handleLogin() async {
    setState(() {
      isLoading = true;
    });

    final response = await authService.login(email.text.trim(), password.text.trim());

    setState(() {
      isLoading = false;
    });

    if (response == null || response.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${response?['error'] ?? 'Something went wrong'}")),
      );
      return;
    }

    final message = response['message']?.toString().toLowerCase() ?? '';

    if (message.contains('login successful')) {
      // ✅ Save name in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', response['name'] ?? '');

      // Navigate to main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Login failed")),
      );
    }
  }

  // void _handleLogin() async {
  //   setState(() {
  //     isLoading = true;*
  //   });
  //
  //   final response = await authService.login(email.text.trim(), password.text.trim());
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  //
  //   if (response == null || response.containsKey('error')) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Login failed: ${response?['error'] ?? 'Something went wrong'}")),
  //     );
  //     return;
  //   }
  //
  //   final message = response['message']?.toString().toLowerCase() ?? '';
  //
  //   if (message.contains('login successful')) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => MainScreen()),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(response['message'] ?? "Login failed")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _handleLogin,
              child: Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SignupScreen()),
                );
              },
              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}


