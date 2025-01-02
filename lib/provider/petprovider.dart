import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../dbhelper.dart';
import '../models/cats.dart';

class PetProvider extends ChangeNotifier {
  String _imagePath = "";
  bool _isLoading = false;

  String get imagePath => _imagePath;

  bool get isLoading => _isLoading;

  void setImagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void pickImage() async {
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
      _isLoading = false; // Stop loading
      notifyListeners();
    }
  }

  void clearImagePath() {
    _imagePath = '';
    notifyListeners();
  }

  Future<void> submitForm({
    required String name,
    required int age,
    required String type,
    required DatabaseHelper databaseHelper,
    required BuildContext context,
    required int userId,
  }) async {
    if (name.isEmpty || type.isEmpty || _imagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All Fields are required')),
      );
      return;
    }
    setLoading(true);
    try {
      final newPet = Pet(
        name: name,
        age: age,
        type: type,
        image: imagePath,
        userId: userId,
      );
      await databaseHelper.insertPet(newPet);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User Added')),
      );
    } catch (e) {
      debugPrint('Insert Failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add user: ${e.toString()}')),
      );
    } finally {
      setLoading(false);
    }
  }
}
