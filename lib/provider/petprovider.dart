import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlsqlsql/models/users.dart';
import '../dbhelper.dart';
import '../models/cats.dart';

class PetProvider extends ChangeNotifier {
  String _imagePath = "";
  bool _isLoading = false;
  bool _isExpanded = false;
  Pet? _favoritePet;
  Pet? _updatedPet;
  // Map<String, List<Pet>> _petsByType = {}; // Holds pets grouped by type
  List<Pet> _catsOfSingleType = [];
  List<Pet> _parrotsOfSingleType = [];

  String get imagePath => _imagePath;

  bool get isLoading => _isLoading;

  bool get isExpended => _isExpanded;

  Pet? get favoritePet => _favoritePet;

  Pet? get updatedPet => _updatedPet;
  // Map<String, List<Pet>> get petsByType => _petsByType;
  List<Pet> get catsOfSingleType => _catsOfSingleType;
  List<Pet> get parrotsOfSingleType => _parrotsOfSingleType;

  void toggleExpended() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

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

  Future<void> updatePet({
    String? name,
    int? age,
    String? type,
    String? tagline,
    required DatabaseHelper databaseHelper,
    required BuildContext context,
    required int userId,
    required int petId,
  }) async {
    setLoading(true);
    try {
      final existingPet = await databaseHelper.getSinglePetById(petId);

      if (existingPet == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet not found')),
        );
        return;
      }

      final updatedPet = Pet(
        id: petId,
        name: name ?? existingPet.name,
        age: age ?? existingPet.age,
        type: type ?? existingPet.type,
        image: _imagePath.isNotEmpty ? _imagePath : existingPet.image,
        userId: userId,
        tagLine: tagline,
      );
      await databaseHelper.updatePet(updatedPet);
      _updatedPet = updatedPet;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet Updated for provider')),
      );
    } catch (e) {
      debugPrint('Update Failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update pet: ${e.toString()}')),
      );
    } finally {
      setLoading(false);
      notifyListeners();
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

  void printPetsOfSingleType() {
    for (var pet in _catsOfSingleType) {
      print("Name: ${pet.name}, Age: ${pet.age}");
    }
  }

  Future<void> getPetsByCat(
      int userid, DatabaseHelper databaseHelper) async {
    try {
      setLoading(true);
      _catsOfSingleType = await databaseHelper.getPetsByType('Cat', userid);
      printPetsOfSingleType();
    } catch (e) {
      debugPrint('Error fetching pets by type: $e');
      _catsOfSingleType = [];
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
  Future<void> getPetsByParrot(
      int userid, DatabaseHelper databaseHelper) async {
    try {
      setLoading(true);
      _parrotsOfSingleType = await databaseHelper.getPetsByType('Parrot', userid);
      printPetsOfSingleType();
    } catch (e) {
      debugPrint('Error fetching pets by type: $e');
      _parrotsOfSingleType = [];
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
}
