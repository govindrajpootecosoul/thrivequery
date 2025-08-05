import 'dart:convert';
import 'package:ecosoulquerytracker/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //final String baseUrl = 'http://192.168.50.92:5100/api'; // <-- Replace if different


  Future<Map<String, dynamic>?> login(String email, String password) async {
    print("email ====> $email");
    print("pass ====> $password");
    print("ApiConfig.signin =====> ${ApiConfig.signin}");
    final response = await http.post(
      Uri.parse(ApiConfig.signin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      print("response.body =====> ${response.body}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', res['id']);
      await prefs.setString('userType', res['userType']);

      print("✅ SharedPreferences Saved: userId = ${res['id']}, userType = ${res['userType']}");
      return res;
    } else {
      print("❌ Login failed: ${response.reasonPhrase}");
      return {'error': response.reasonPhrase ?? 'Login failed'};
    }
  }



/*
  Future<Map<String, dynamic>?> login(String email, String password) async {
    //var request = http.Request('POST', Uri.parse('$baseUrl/signin'));
    var request = http.Request('POST', Uri.parse(ApiConfig.signin));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({
      'email': email,
      'password': password,
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      var resBody = await response.stream.bytesToString();
      var res = jsonDecode(resBody);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', res['id']);
      await prefs.setString('userType', res['userType']);

      print("✅ SharedPreferences Saved: userId = ${res['id']}, userType = ${res['userType']}");
      return res;
    } else {
      print("❌ Login failed: ${response.reasonPhrase}");
      return {'error': response.reasonPhrase ?? 'Login failed'};
    }
  }
*/

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userType');
    print("🚪 Logged out: SharedPreferences cleared");
  }
}
