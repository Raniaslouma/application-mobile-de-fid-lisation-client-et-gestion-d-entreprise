import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  CacheHelper._();
  static late SharedPreferences sharedPreferences;

  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static const _isInfoExist = "isInfoExist";

  static Future<bool> setInfoExist(String value) async {
    return await sharedPreferences.setString(_isInfoExist, value);
  }

  static String? getInfoExist() {
    return sharedPreferences.getString(_isInfoExist);
  }

  static void clearCache() {
    sharedPreferences.clear();
  }
}
