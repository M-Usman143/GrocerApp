import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _keyPhoneNumber = "phone_number";
  static const String _keyUserLocation = "user_location";

  static Future<void> savePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhoneNumber, phoneNumber);
  }

  static Future<String?> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhoneNumber);
  }

  static Future<void> clearPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPhoneNumber);
  }
  static Future<void> saveLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserLocation, location);
  }

  static Future<String?> getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserLocation);
  }

  static Future<void> clearLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserLocation);
  }


}
