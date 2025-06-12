/*
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


*/



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
      final prefs = await SharedPreferences.getInstance();
      //await prefs.setString('userName', response['name'] ?? '');

      await prefs.setString('userName', response['name'] ?? '');
      await prefs.setBool('isLoggedIn', true); // ✅ Add this line


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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF9),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/loginbg.png'), // Your background image
            fit: BoxFit.cover, // or BoxFit.fitHeight if you prefer
          ),
        ),
        child: Row(
          children: [
            // Left Side (Form and Logo)
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF0f9d58), Color(0xFFa6ce39)],
                      ).createShader(bounds),
                      child:Image.asset(
                        height: 60,
                        'assets/Logo.png', // Replace with your actual image
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'WORKLYTICS:\nOFFICE ORCHESTRA',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B8E23),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: email,
                      decoration: const InputDecoration(
                        hintText: 'email@domain.com',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'password',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 30),
                    isLoading
                        ? const CircularProgressIndicator()
                        :
                    SizedBox(
                      width: 150,
                      height: 45,
                      child:Container(
                        width: 150,
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0f9d58), Color(0xFFa6ce39)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _handleLogin,
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )

                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignupScreen()),
                        );
                      },
                      child: const Text("Don't have an account? Sign up"),
                    ),
                  ],
                ),
              ),
            ),

            // Right Side (Illustration)
            if (screenSize.width > 800)
              Expanded(
                flex: 5,
                child: Image.asset(
                  'assets/bg2.png', // Replace with your actual image
                  fit: BoxFit.fitHeight,
                ),
              ),
          ],
        ),
      ),
    );
  }

}
