// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqlsqlsql/models/users.dart';

// class SessionProvider with ChangeNotifier {
//   Map<String, dynamic>? _userSession;

//   Map<String, dynamic>? get userSession => _userSession;

//   // Method to load the session from SharedPreferences
//   Future<void> loadUserSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (prefs.containsKey('user_id')) {
//       _userSession = {
//         'id': prefs.getInt('user_id'),
//         'email': prefs.getString('user_email'),
//         'name': prefs.getString('user_name'),
//         'image': prefs.getString('user_image'),
//       };
//       notifyListeners();
//     }
//   }

//   // Method to save the session data
//   Future<void> saveUserSession(User user) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('user_id', user.id!);
//     await prefs.setString('user_email', user.email);
//     await prefs.setString('user_name', user.name);
//     await prefs.setString('user_image', user.image);

//     _userSession = {
//       'id': user.id,
//       'email': user.email,
//       'name': user.name,
//       'image': user.image,
//     };
//     notifyListeners();
//   }

//   // Method to clear the session data
//   Future<void> clearUserSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     _userSession = null;
//     notifyListeners();
//   }
// }
