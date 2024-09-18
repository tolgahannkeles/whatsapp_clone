import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static const String kAccessTokenKey = "accessToken";
  static const String kRefreshToken = "refreshToken";
  static Future<void> saveTokens(
      String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await clearTokens();
    await prefs.setString(kAccessTokenKey, accessToken);
    await prefs.setString(kRefreshToken, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(kAccessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(kRefreshToken);
  }

  static Future<void> clearTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.remove(kAccessTokenKey);
    await prefs.remove(kRefreshToken);
  }

  static Future<bool> isTokenAvailable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(kAccessTokenKey);
  }
}
