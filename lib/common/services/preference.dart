import 'package:cinemabooking/datalayer/services/auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? pref;

  static Future<void> init() async {
    pref = await SharedPreferences.getInstance(); 
  }

  static Future<void> saveToken (String token) async {
    await pref!.setString(AuthKey.tokenKey, token);
  }
  static Future<String?> getToken () async {
    return pref!.getString(AuthKey.tokenKey);
  }
  static Future<void> deleteToken() async {
    await pref!.remove(AuthKey.tokenKey);
  }
}