import 'package:ecosoulquerytracker/main.dart';
import 'package:ecosoulquerytracker/splash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/Tabscreen/mainscrentab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Query App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // <--- Use splash to check login
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   Widget? _nextScreen;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }
//
//   Future<void> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final id = prefs.getString('id');
//
//     // Artificial delay (optional for loading effect)
//     await Future.delayed(Duration(seconds: 1));
//
//     setState(() {
//       _nextScreen = id != null ? MainScreen() : LoginScreen();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_nextScreen == null) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     } else {
//       return _nextScreen!;
//     }
//   }
// }
