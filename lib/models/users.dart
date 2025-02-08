import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  final int? id;
  final String email;
  final String name;
  final String password;
  final String image;

  const User({
    this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': id,
      'user_email': email,
      'user_name': name,
      'user_password': password,
      'user_image': image,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user_id'],
      email: map['user_email'],
      name: map['user_name'],
      password: map['user_password'],
      image: map['user_image'],
    );
  }

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hashed = sha256.convert(bytes);
    return hashed.toString();
  }

  factory User.withHashedPassword({
    int? id,
    required String email,
    required String name,
    required String password,
    required String image,
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      password: hashPassword(password),
      image: image,
    );
  }
}
