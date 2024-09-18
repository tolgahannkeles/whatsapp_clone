import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/database/shared_preferences_util.dart';
import 'package:whatsapp_clone/database/user_transactions.dart';
import 'package:whatsapp_clone/models/auth_response.dart';

class AuthService {
  static String baseUrl = "http://10.0.2.2:8080/api/auth";

  static Future<void> login(String username, String password) async {
    Uri? uri = Uri.tryParse("$baseUrl/login");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (uri != null) {
      Map<String, Object> body = {"username": username, "password": password};
      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception("Login failed: ${jsonDecode(response.body)}");
      }

      AuthResponse authResponse =
          AuthResponse.fromJson(jsonDecode(response.body));

      await SharedPreferencesUtil.saveTokens(
          authResponse.accessToken, authResponse.refreshToken);
    }
  }

  static Future<void> register(
      String email, String username, String password) async {
    Uri? uri = Uri.tryParse("$baseUrl/register");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (uri != null) {
      Map<String, Object> body = {
        "username": username,
        "password": password,
        "email": email,
      };
      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception("Login failed: ${jsonDecode(response.body)}");
      }

      AuthResponse authResponse =
          AuthResponse.fromJson(jsonDecode(response.body));
      await SharedPreferencesUtil.saveTokens(
          authResponse.accessToken, authResponse.refreshToken);
    }
  }

  static Future<bool> isTokenValid(String token) async {
    Uri? uri = Uri.tryParse("$baseUrl/isTokenValid");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    if (uri != null) {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode != 200) {
        return false;
      }

      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    Uri? uri = Uri.tryParse("$baseUrl/logout");
    if (uri == null) {
      throw Exception("Invalid URI");
    }
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) {
      throw Exception("Token is not available");
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception("Logout failed: ${jsonDecode(response.body)}");
    }
    await SharedPreferencesUtil.clearTokens();
  }
}
