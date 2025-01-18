import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlsqlsql/models/cats.dart';
import 'models/users.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  final String _userTableName = "users";
  final String _userIdColumn = "user_id";
  final String _userEmailColumn = "user_email";
  final String _userNameColumn = "user_name";
  final String _userPassColumn = "user_password";
  final String _userImageColumn = "user_image";

  final String _tableName = "pets";
  final String _idColumn = "pet_id";
  final String _nameColumn = "pet_name";
  final String _ageColumn = "pet_age";
  final String _typeColumn = "pet_type";
  final String _imageColumn = "pet_image";
  final String _isFav = "pet_fav";
  final String _foreignIdColumn = "userid";

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = join(await getDatabasesPath(), 'pet_database.db');
    return openDatabase(
      databasePath,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $_userTableName($_userIdColumn INTEGER PRIMARY KEY,$_userEmailColumn TEXT NOT NULL UNIQUE,$_userNameColumn TEXT NOT NULL,$_userPassColumn TEXT NOT NULL,$_userImageColumn TEXT)');
        await db.execute(
            'CREATE TABLE $_tableName($_idColumn INTEGER PRIMARY KEY, $_nameColumn TEXT NOT NULL, $_ageColumn INTEGER NOT NULL, $_typeColumn TEXT NOT NULL,$_imageColumn TEXT,$_isFav INTEGER NOT NULL DEFAULT 0,$_foreignIdColumn INTEGER NOT NULL,FOREIGN KEY($_foreignIdColumn) REFERENCES $_userTableName($_userIdColumn) ON DELETE CASCADE)');
      },
      version: 1,
    );
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      _userTableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      _userTableName,
      user.toMap(),
      where: '$_userIdColumn = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(User user) async {
    final db = await database;
    await db.delete(
      _userTableName,
      where: '$_userIdColumn = ?',
      whereArgs: [user.id],
    );
  }

  Future<User?> loginUser(String email, String hashpassword) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT * FROM $_userTableName WHERE $_userEmailColumn = ? AND $_userPassColumn = ?',
      [email, hashpassword],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<void> insertPet(Pet pet) async {
    final db = await database;
    await db.insert(
      _tableName,
      pet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> updatePet(Pet pet) async {
    final db = await database;
    await db.update(
      _tableName,
      pet.toMap(),
      where: '$_idColumn = ? AND $_foreignIdColumn = ?',
      whereArgs: [pet.id, pet.userId],
    );
  }

  Future<void> deletePet(int petId, int userId) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: '$_idColumn = ? AND $_foreignIdColumn = ?',
      whereArgs: [petId, userId],
    );
  }

  Future<List<Pet>> getPetsForUser(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pets',
      where: 'userid = ?',
      whereArgs: [userId],
    );
    debugPrint('Fetched pets: $maps');
    return List<Pet>.from(maps.map((map) => Pet.fromMap(map)));
  }

  Future<void> updatePetFavStatus(int petId, int userId, int isFav) async {
    final db = await database;
    await db.update(
      _tableName,
      {_isFav: isFav},
      where: '$_idColumn = ? AND $_foreignIdColumn = ?',
      whereArgs: [petId, userId],
    );
  }

  Future<Pet?> getSingleFavPet({required int userId}) async {
    final db = await database;
    final result = await db.query(
      'pets',
      where: 'userid = ? AND pet_fav = ?',
      whereArgs: [userId, 1],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Pet.fromMap(result.first);
    }
    return null; // No favorite pet found
  }
}
