import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const baseURL = "https://10.0.2.2:7048/api/Account";

//Here we bypass the ssl certificate, it is not allowed
  HttpClient _createHttpClient() {
    final HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }

  Future<bool> login(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        final http.Client httpClient = IOClient(_createHttpClient());

        final response = await httpClient.post(
          Uri.parse('$baseURL/Login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"userName": email, "password": password}),
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final token = jsonResponse["jwtToken"];
          final refreshToken = jsonResponse["refreshToken"];

          // Save the token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwtToken', token);
          await prefs.setString('refreshToken', refreshToken);

          return true;
        } else {
          print('Login failed with status code: ${response.statusCode}');
          return false;
        }
      } catch (e) {
        print('Login failed with error: $e');
        return false;
      }
    } else {
      print('Email or password is empty');
      return false;
    }
  }

  Future<bool> requestRefreshtoken() async {
    String? jwt = await getToken();
    String? refreshToken = await getRefreshToken();

    if (jwt != null && refreshToken != null) {
      try {
        final http.Client httpClient = IOClient(_createHttpClient());

        final response = await httpClient.post(
          Uri.parse('$baseURL/Request-RefreshToken'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"jwtToken": jwt, "refreshToken": refreshToken}),
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final token = jsonResponse["jwtToken"];
          final refreshToken = jsonResponse["refreshToken"];

          // Save the token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwtToken', token);
          await prefs.setString('refreshToken', refreshToken);

          return true;
        }
      } catch (e) {
        print('Refresh token failed with error: $e');
      }
    }

    await Logout();
    return false;
  }

  Future Logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    await prefs.remove('refreshToken');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<bool> isAuthenticated() async {
    String? jwt = await getToken();
    String? refreshToken = await getRefreshToken();
    if (jwt != null && refreshToken != null) {
      if (jwt.isEmpty || JwtDecoder.isExpired(jwt)) {
        print("tokne expired");
        final result = await requestRefreshtoken();
        if (result == false) {
          //refresh fail
          return false;
        } else {
          //refresh success

          return true;
        }
      } else {
        //token is valid
        return true;
      }
    }

    return false;
  }
}
