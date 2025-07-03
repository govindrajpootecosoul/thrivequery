// import 'package:dio/dio.dart';
//
// class QueryService {
//   final Dio dio = Dio();
//
//   Future<String?> sendQuery(Map<String, dynamic> data) async {
//     try {
//       final response = await dio.post("http://localhost:5100/api/query", data: data);
//       return response.data["message"];
//     } catch (e) {
//       return "Failed to send query";
//     }
//   }
//
//   Future<String?> updateQuery(Map<String, dynamic> data) async {
//     try {
//       final response = await dio.put("http://localhost:5100/api/query/update", data: data);
//       return response.data["message"];
//     } catch (e) {
//       return "Failed to update query";
//     }
//   }
//
//   Future<String?> getQueryList() async {
//     try {
//       final response = await dio.get("http://192.168.50.92:5100/api/query");
//       return response.toString(); // or return response.data;
//     } catch (e) {
//       return null;
//     }
//   }
// }
