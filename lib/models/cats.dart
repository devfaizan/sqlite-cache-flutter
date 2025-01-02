class Pet {
  final int? id;
  final String name;
  final int age;
  final String type;
  final String image;
  final int userId;

  Pet({
    this.id,
    required this.name,
    required this.age,
    required this.type,
    required this.image,
    required this.userId,
  });

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['pet_id'],
      name: map['pet_name'],
      age: map['pet_age'],
      type: map['pet_type'],
      image: map['pet_image'],
      userId: map['userid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pet_id': id,
      'pet_name': name,
      'pet_age': age,
      'pet_type': type,
      'pet_image': image,
      'userid': userId,
    };
  }
}
