// // lib/utils/dio_client.dart
//
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:dio/io.dart';
//
// class DioClient {
//   static Dio getDio() {
//    final dio = Dio();
//
//     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//         (HttpClient client) {
//       client.badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//       return client;
//     };
//
//     return dio;
//   }
// }
