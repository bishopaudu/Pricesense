import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String tokenKey = 'auth_token';
  static const String tokenTimestampKey = 'token_timestamp';
  static const String userFirstNameKey = 'user_first_name';
  static const String userLastNameKey = 'user_last_name';
  static const String userEmailKey = 'user_email';
  static const String userPhoneKey = 'phone_phone';
  static const String userGenderKey = 'user_gender';
  static const String userCityKey = 'user_city';
  static const String userIdKey = 'user_id';
  static const String userCoordinatorKey = 'user_coordinator';
  static const String userRoleKey = 'user_role';
  static const String userNameKey = 'user_name';

  Future<void> saveUserData(
      String token,
      String firstName,
      String lastName,
      String email,
      String phone,
      String city,
      String id,
      String coordinator,
      String gender,
      String username,
      String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    await prefs.setInt(
        tokenTimestampKey, DateTime.now().millisecondsSinceEpoch);
    await prefs.setString(userFirstNameKey, firstName);
    await prefs.setString(userLastNameKey, lastName);
    await prefs.setString(userEmailKey, email);
    await prefs.setString(userPhoneKey, phone);
    await prefs.setString(userCityKey, city);
    await prefs.setString(userIdKey, id);
        await prefs.setString(userGenderKey,gender);
    await prefs.setString(userCoordinatorKey, coordinator);
    await prefs.setString(userRoleKey, role);
    await prefs.setString(userNameKey, username);
  }

  Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString(tokenKey),
      'firstName': prefs.getString(userFirstNameKey),
      'lastName': prefs.getString(userLastNameKey),
      'email': prefs.getString(userEmailKey),
      'phone': prefs.getString(userPhoneKey),
      'gender': prefs.getString(userGenderKey),
      'city': prefs.getString(userCityKey),
      'id': prefs.getString(userIdKey),
      'coordinator': prefs.getString(userCoordinatorKey),
      'role': prefs.getString(userRoleKey),
       'username': prefs.getString(userNameKey)
    };
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(tokenTimestampKey);
    await prefs.remove(userFirstNameKey);
    await prefs.remove(userLastNameKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userCityKey);
    await prefs.remove(userGenderKey); 
    await prefs.remove(userPhoneKey);
    await prefs.remove(userCoordinatorKey);
    await prefs.remove(userIdKey);
    await prefs.remove(userRoleKey);
    await prefs.remove(userNameKey);  
  }

  Future<bool> isTokenValid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? timestamp = prefs.getInt(tokenTimestampKey);

    if (timestamp == null) {
      return false;
    }

    DateTime tokenDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    Duration tokenAge = DateTime.now().difference(tokenDate);

    return tokenAge.inDays < 30;
  }
}
