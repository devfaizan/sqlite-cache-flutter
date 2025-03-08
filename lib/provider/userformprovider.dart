import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlsqlsql/dbhelper.dart';

import '../models/users.dart';

class UserFormProvider extends ChangeNotifier {
  String _imagePath = '';
  bool _isLoading = false;
  User? _currentUser;

  String get imagePath => _imagePath;

  bool get isLoading => _isLoading;

  User? get currentUser => _currentUser;

  void setImagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
    try {
      _isLoading = true;
      notifyListeners();

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _imagePath = pickedFile.path;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearImagePath() {
    _imagePath = '';
    notifyListeners();
  }

  Future<void> submitForm({
    required String email,
    required String name,
    required String password,
    required DatabaseHelper databaseHelper,
    required BuildContext context,
  }) async {
    if (email.isEmpty ||
        name.isEmpty ||
        password.isEmpty ||
        _imagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All Fields are required')),
      );
      return;
    }
    setLoading(true);
    try {
      final newUser = User.withHashedPassword(
        email: email,
        name: name,
        password: password,
        image: _imagePath,
      );
      await databaseHelper.insertUser(newUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User Added')),
      );
      clearImagePath();
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your Email already Exists')),
        );
      } else {
        debugPrint('Insert Failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add user: ${e.toString()}')),
        );
      }
    } finally {
      setLoading(false);
    }
  }

  Future<bool> userLogin(
      {required String email,
      required String password,
      required DatabaseHelper databaseHelper,
      required BuildContext context}) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All Fields are required')),
      );
      return false;
    }
    setLoading(true);
    try {
      final hashpassword = User.hashPassword(password);
      final user = await databaseHelper.loginUser(email, hashpassword);
      if (user != null) {
        await saveSession(user);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login: ${e.toString()}')),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> saveSession(User user) async {
    final perfers = await SharedPreferences.getInstance();
    await perfers.setInt('user_id', user.id!);
    await perfers.setString('user_email', user.email);
    await perfers.setString('user_name', user.name);
    await perfers.setString('user_image', user.image);
    print(user.id);
    notifyListeners();
    return true;
  }

  Future<User> loadSession() async {
    final perfers = await SharedPreferences.getInstance();

    final currentUserID = perfers.getInt('user_id');
    final currentUserEmail = perfers.getString('user_email');
    final currentUserName = perfers.getString('user_name');
    final currentUserImage = perfers.getString('user_image');

    notifyListeners();
    return User(
      id: currentUserID,
      email: currentUserEmail.toString(),
      name: currentUserName.toString(),
      password: '',
      image: currentUserImage.toString(),
    );
  }

  Future<void> loadSessionData() async {
    try {
      _currentUser = await loadSession();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading session data: $e');
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_image');
    notifyListeners();
  }

  Future<void> userLogout(BuildContext context) async {
    await clearSession();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateUser({
    required User user,
    required DatabaseHelper databaseHelper,
    required BuildContext context,
  }) async {
    if (user.name.isEmpty || _imagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Image are required')),
      );
      return;
    }

    setLoading(true);
    try {
      final updatedUser = User(
        id: user.id,
        email: user.email,
        name: user.name,
        password: user.password,
        image: _imagePath.isNotEmpty ? _imagePath : user.image,
      );

      await databaseHelper.updateUser(updatedUser);
      await saveSession(updatedUser); // Save the updated user session
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully!')),
      );
      clearImagePath();
    } catch (e) {
      debugPrint('Update failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user: $e')),
      );
    } finally {
      setLoading(false);
    }
  }
}
