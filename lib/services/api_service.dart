// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthService {
//   final String baseUrl = "http://192.168.31.175:5100/api";
//
//
//   Future<String?> login(String email, String password) async {
//     var request = http.Request('POST', Uri.parse('$baseUrl/signin'));
//     request.headers['Content-Type'] = 'application/json';
//     request.body = jsonEncode({'email': email, 'password': password});
//
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       var res = jsonDecode(await response.stream.bytesToString());
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString('userId', res['id']);
//       prefs.setString('userType', res['userType']);
//       return res['message'];
//     } else {
//       return response.reasonPhrase;
//     }
//   }
//
//
//
//
//   Future<String?> signup(String name, String email, String password) async {
//     var request = http.Request('POST', Uri.parse('$baseUrl/signup'));
//     request.headers['Content-Type'] = 'application/json';
//     request.body = jsonEncode({'name': name, 'email': email, 'password': password});
//
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       return await response.stream.bytesToString();
//     } else {
//       return response.reasonPhrase;
//     }
//   }
// }



import 'dart:convert';
import 'package:ecosoulquerytracker/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //final String baseUrl = "http://192.168.50.92:5100/api";

  Future<String?> login(String email, String password) async {
    //var request = http.Request('POST', Uri.parse('$baseUrl/signin'));
    var request = http.Request('POST', Uri.parse(ApiConfig.signin));

    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({'email': email, 'password': password});

    var response = await request.send();
    if (response.statusCode == 200) {
      var res = jsonDecode(await response.stream.bytesToString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', res['id']);
      prefs.setString('userType', res['userType']);
      print("user typeeee sign ::: ${res['userType']}");
      return res['message'];

    } else {
      return response.reasonPhrase;

    }
  }

  Future<String?> signup(String name, String email, String password) async {
    //var request = http.Request('POST', Uri.parse('$baseUrl/signup'));
    var request = http.Request('POST', Uri.parse(ApiConfig.signup));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({'name': name, 'email': email, 'password': password});

    var response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase;
    }
  }

  // New method to fetch dashboard data
  // Future<Map<String, dynamic>?> fetchDashboardData() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? userId = prefs.getString('userId');
  //     String? userType = prefs.getString('userType');
  //     print("user typeee>>> ${prefs.getString('userType')}");
  //
  //     if (userId == null || userType == null) {
  //       print('User ID or User Type not found in SharedPreferences');
  //       return null;
  //     }
  //     print("user typeeee all ::: ${userType}");
  //     print("user typeeee user id all ::: ${userId}");
  //
  //     var url = Uri.parse('$baseUrl/overall?id=$userId&userType=$userType');
  //     var response = await http.get(url);
  //
  //     if (response.statusCode == 200) {
  //
  //       return jsonDecode(response.body);
  //     } else {
  //       print('Failed to fetch dashboard data: ${response.reasonPhrase}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching dashboard data: $e');
  //     return null;
  //   }
  // }


  Future<Map<String, dynamic>?> fetchDashboardData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Fetch userId and userType from SharedPreferences
      String? userId = prefs.getString('userId');
      String? userType = prefs.getString('userType');

      // Logging the values retrieved
      print("📥 Retrieved from SharedPreferences -> userId: $userId, userType: $userType");

      // Check if either is null
      if (userId == null || userType == null) {
        print('❌ Error: User ID or User Type not found in SharedPreferences.');
        return null;
      }

      // Build the URL
      var url = Uri.parse('${ApiConfig.statuscount}?id=$userId&userType=$userType');
      print("🌐 Fetching dashboard data from: $url");

      // Make GET request
      var response = await http.get(url);

      // Handle response
      if (response.statusCode == 200) {
        print("✅ Dashboard data fetched successfully.");
        return jsonDecode(response.body);
      } else {
        print('❌ Failed to fetch dashboard data: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('❗ Exception occurred while fetching dashboard data: $e');
      return null;
    }
  }



}

