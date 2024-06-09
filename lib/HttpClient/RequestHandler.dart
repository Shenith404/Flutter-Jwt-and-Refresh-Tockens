import 'dart:convert';
import 'dart:io';

import 'package:erpmobile/Services/authe_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class RequestHandler {
  //Here we bypass the ssl certificate, it is not allowed
  HttpClient createHttpClient() {
    final HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    return client;
  }

  AuthService authService = AuthService();

  Future<Response?> getRequest(String url) async {
    {
      final http.Client httpClient = IOClient(createHttpClient());
      var isAuthenticatedUser = await authService.isAuthenticated();

      var token = await authService.getToken();

      if (isAuthenticatedUser) {
        final response = await httpClient.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        return response;
      }

      return null;
    }
  }

  Future<Response?> postRequest(String url, Map map) async {
    {
      final http.Client httpClient = IOClient(createHttpClient());
      var isAuthenticatedUser = await authService.isAuthenticated();

      var token = await authService.getToken();

      if (isAuthenticatedUser) {
        final response = await httpClient.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(map),
        );
        return response;
      }

      return null;
    }
  }
}
