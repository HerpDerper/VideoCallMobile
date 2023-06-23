import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  SharedPreferences? sharedPreferences;

  Future<void> initSharedPreferences() async => sharedPreferences = await SharedPreferences.getInstance();

  void setTokenToSharedPreferences(String token) async => await sharedPreferences!.setString('token', token);

  void clearSharedPreferences() async => await sharedPreferences!.clear();

  String getTokenFromSharedPreferences() => sharedPreferences!.getString('token')!;
}
