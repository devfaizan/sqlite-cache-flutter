import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlsqlsql/dbhelper.dart';
import 'package:sqlsqlsql/models/cats.dart';
import 'package:sqlsqlsql/provider/userformprovider.dart';
import 'package:sqlsqlsql/screens/pet/form.dart';
import 'package:sqlsqlsql/screens/pet/updatepets.dart';
import 'package:sqlsqlsql/utils/outputtext.dart';

class AllPetsScreen extends StatefulWidget {
  const AllPetsScreen({super.key});

  @override
  State<AllPetsScreen> createState() => _AllPetsScreenState();
}

class _AllPetsScreenState extends State<AllPetsScreen> {
  List<Pet> _petList = [];
  bool _isLoading = true;

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _fetchCats();
  }

  Future<void> _fetchCats() async {
    final userProvider = Provider.of<UserFormProvider>(context, listen: false);
    if (userProvider.currentUser == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user ID found')),
      );
      return;
    }
    try {
      final userId = userProvider.currentUser!.id!;
      print("Fetching pets for user ID: $userId");

      final pets = await _databaseHelper.getPetsForUser(userId);

      setState(() {
        _petList = pets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error fetching pets: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch pets: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Pets"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              child: const Icon(Icons.add),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormScreen()),
                ).then((value) {
                  if (value == true) {}
                });
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _petList.isEmpty
              ? const Center(child: Text("No pets found"))
              : ListView.builder(
                  itemCount: _petList.length,
                  itemBuilder: (context, index) {
                    final pet = _petList[index];
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onLongPress: () {
                              print("Buchu");
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/backbackdialog.png'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Stack(
                                            children: [
                                              Center(
                                                child: Text(
                                                  "Select An Option",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                child: GestureDetector(
                                                  child: Icon(
                                                      Icons.close_rounded,
                                                      color: Colors.white),
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          UnboldSubheadingText(
                                            text: "Edit or Delete ",
                                          ),
                                          SubheadingText(
                                            text: pet.name,
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateScreen(
                                                        pet: Pet(
                                                          id: pet.id,
                                                          name: pet.name,
                                                          age: pet.age,
                                                          type: pet.type,
                                                          image: pet.image,
                                                          userId: pet.userId,
                                                        ),
                                                      ),
                                                    ),
                                                  ).then((value) {
                                                    if (value == true) {
                                                      _fetchCats();
                                                    }
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit,
                                                        color: Colors.white),
                                                    SizedBox(width: 10),
                                                    Text("Edit",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  _databaseHelper.deletePet(
                                                      pet.id!, pet.userId);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "Deleted Successfully"),
                                                    ),
                                                  );
                                                  Navigator.of(context).pop();
                                                  _fetchCats();
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete,
                                                        color: Colors.red),
                                                    SizedBox(width: 10),
                                                    Text("Delete",
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                  ],
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    pet.type.toLowerCase() == 'cat'
                                        ? 'assets/back-cat.png'
                                        : pet.type.toLowerCase() == 'parrot'
                                            ? 'assets/back-parrot.png'
                                            : 'assets/backbackback.png',
                                  ),
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: FileImage(File(pet.image)),
                                ),
                                title: Text(pet.name),
                                subtitle: Text("Age: ${pet.age}"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
