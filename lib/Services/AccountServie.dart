import 'dart:convert';

import 'package:erpmobile/HttpClient/RequestHandler.dart';
import 'package:erpmobile/Services/AutheService.dart';

class Accountservie {
  AuthService authService = AuthService();
  RequestHandler requestHandler = RequestHandler();

  Future<bool> getUserDetails() async {
    try {
      var baseURL = authService.baseURL;

      final response =
          await requestHandler.getRequest('$baseURL/Get-User-Details');

      await requestHandler.postRequest('$baseURL/Get-User-Details', {});
      if (response == null) {
        return false;
      }
      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final username = jsonResponse["username"];

        return true;
      }
      return false;
    } catch (e) {
      print('request faild  :$e');
    }

    return false;
  }
}
