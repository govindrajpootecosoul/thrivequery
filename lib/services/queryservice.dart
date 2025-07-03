import 'dart:convert';
import 'package:ecosoulquerytracker/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QueryService {
 /* //final String baseUrl = "http://192.168.50.92:5100/api";*/

  Future<String?> submitQuery(Map<String, dynamic> data) async {
    // var request = http.Request('POST', Uri.parse('$baseUrl/register'));

    var request = http.Request('POST', Uri.parse(ApiConfig.add_query));

    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode(data);

    var response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase;
    }
  }

  Future<String?> getQueryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('userId');
    String? userType = prefs.getString('userType');

    if (id == null || userType == null) return "Missing user data";

   // var url = Uri.parse('$baseUrl/registration?id=$id&userType=$userType');
    var url = Uri.parse('${ApiConfig.all_query_list}?id=$id&userType=$userType');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.reasonPhrase;
    }
  }
}
