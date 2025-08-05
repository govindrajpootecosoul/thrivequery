class ApiConfig {
  // Base URL
  // static const String baseUrl = 'http://10.12.253.131:5200/api';
  //static const String baseUrl = 'http://localhost:5200/api';
  static const String baseUrl = "https://thriveworklytics.thrivebrands.ai/api";
  //static const String baseUrl = "http://192.168.50.92:5200/api";

  //https://thriveworklytics.thrivebrands.ai/api


  // Endpoints
  static const String signin = '$baseUrl/signin';
  static const String signup = '$baseUrl/signup';
  static const String statuscount = '$baseUrl/overall';
  static const String users_list = '$baseUrl/users';
  static const String users_name_list = '$baseUrl/registration/usernames';
  static const String all_query_list = '$baseUrl/registration';
  static const String delete_query = '$baseUrl/delete';
  static const String all_users_auth = '$baseUrl/usersall_details';
  static const String add_query = '$baseUrl/register';
  static const String update_query = '$baseUrl/update';

}



