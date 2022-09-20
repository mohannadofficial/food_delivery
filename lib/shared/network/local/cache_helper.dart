import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {

  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }


  static Future<bool> setData(String key, dynamic value) async {

    if(value is String) {
      return await sharedPreferences.setString(key, value);
    } else if(value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if(value is int) {
      return await sharedPreferences.setInt(key, value);
    } else if(value is List<String>) {
      return await sharedPreferences.setStringList(key, value);
    } else {
      return await sharedPreferences.setDouble(key, value);
    }

  }

  static dynamic getData(String key){
    return sharedPreferences.get(key);
  }

  static Future<bool> deleteData(String key) async {
    return await sharedPreferences.remove(key);
  }

}