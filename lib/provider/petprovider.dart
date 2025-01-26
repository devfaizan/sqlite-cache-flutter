import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlsqlsql/models/users.dart';
import '../dbhelper.dart';
import '../models/cats.dart';

class PetProvider extends ChangeNotifier {
  String _imagePath = "";
  bool _isLoading = false;
  Pet? _favoritePet; // Holds the single favorite pet

  String get imagePath => _imagePath;

  bool get isLoading => _isLoading;

  Pet? get favoritePet => _favoritePet;

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
    required String name,
    required int age,
    required String type,
    required String tagline,
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
        tagLine: tagline,
      );
      await databaseHelper.insertPet(newPet);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet Added')),
      );
      clearImagePath();
    } catch (e) {
      debugPrint('Insert Failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add pet: ${e.toString()}')),
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> toggleFavoriteStatus(
    Pet pet,
    User user,
    DatabaseHelper databaseHelper,
    BuildContext context,
  ) async {
    final newFavStatus = pet.fav == 0 ? 1 : 0;
    try {
      await databaseHelper.updatePetFavStatus(pet.id!, user.id!, newFavStatus);
      pet.fav = newFavStatus;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet Fav')),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to update favorite status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fav: ${e.toString()}')),
      );
    }
  }

  Future<void> getSingleFavPet({
    required int userId,
    required DatabaseHelper databaseHelper,
  }) async {
    try {
      setLoading(true);
      final pet = await databaseHelper.getSingleFavPet(userId: userId);
      _favoritePet = pet; // Assign the single Pet object
    } catch (e) {
      debugPrint('Error fetching favorite pet: $e');
      _favoritePet = null;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
}
