import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlsqlsql/dbhelper.dart';
import 'package:sqlsqlsql/models/cats.dart';
import 'package:sqlsqlsql/provider/userformprovider.dart';
import 'package:sqlsqlsql/provider/petprovider.dart'; // Import PetProvider
import 'package:sqlsqlsql/screens/pet/form.dart';
import 'package:sqlsqlsql/screens/pet/singlepetview.dart';
import 'package:sqlsqlsql/screens/pet/updatepets.dart';
import 'package:sqlsqlsql/utils/colors.dart';
import 'package:sqlsqlsql/utils/outputtext.dart';
import 'package:sqlsqlsql/widgets/drawer/drawer.dart';

class AllPetsScreen extends StatefulWidget {
  const AllPetsScreen({super.key});

  @override
  State<AllPetsScreen> createState() => _AllPetsScreenState();
}

class _AllPetsScreenState extends State<AllPetsScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCats();
    });
  }

  Future<void> _fetchCats() async {
    final userProvider = Provider.of<UserFormProvider>(context, listen: false);
    final petProvider = Provider.of<PetProvider>(context, listen: false);

    if (userProvider.currentUser == null) {
      petProvider.setLoading(false); // Use provider to manage loading state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user ID found')),
      );
      return;
    }

    try {
      petProvider.setLoading(true); // Use provider to manage loading state
      final userId = userProvider.currentUser!.id!;
      print("Fetching pets for user ID: $userId");

      final pets = await _databaseHelper.getPetsForUser(userId);
      petProvider.setPetList(pets); // Use provider to manage pet list
    } catch (e) {
      petProvider.setLoading(false); // Use provider to manage loading state
      print('Error fetching pets: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch pets: $e')),
      );
    } finally {
      petProvider.setLoading(false); // Use provider to manage loading state
    }
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Pets"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              child: Tooltip(
                message: "Add New Pet",
                showDuration: Duration(seconds: 5),
                child: const Icon(Icons.add),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormScreen()),
                ).then((value) {
                  if (value == true) {
                    _fetchCats(); // Refresh the list after adding a pet
                  }
                });
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: petProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : petProvider.petList.isEmpty
          ? const Center(child: Text("No pets found"))
          : ListView.builder(
        itemCount: petProvider.petList.length,
        itemBuilder: (context, index) {
          final pet = petProvider.petList[index];
          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorGray,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SinglePetScreen(
                              pet: pet,
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/backbackdialog.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      children: [
                                        Center(
                                          child: Text(
                                            "Edit or Delete ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight:
                                              FontWeight.bold,
                                              color: Theme.of(context)
                                                  .brightness ==
                                                  Brightness.light
                                                  ? const Color
                                                  .fromARGB(
                                                  255, 49, 47, 47)
                                                  : const Color
                                                  .fromARGB(255,
                                                  255, 255, 255),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: GestureDetector(
                                            child: const Icon(
                                                Icons.close_rounded,
                                                color: Colors.white),
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pop();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SubheadingText(
                                      text: pet.name,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
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
                                                        userId:
                                                        pet.userId,
                                                      ),
                                                    ),
                                              ),
                                            ).then((value) {
                                              if (value == true) {
                                                _fetchCats(); // Refresh the list after updating
                                              }
                                            });
                                          },
                                          style: OutlinedButton
                                              .styleFrom(
                                            side: BorderSide(
                                              color: Theme.of(context)
                                                  .brightness ==
                                                  Brightness.light
                                                  ? const Color
                                                  .fromARGB(
                                                  255, 49, 47, 47)
                                                  : const Color
                                                  .fromARGB(255,
                                                  255, 255, 255),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Theme.of(context)
                                                    .brightness ==
                                                    Brightness
                                                        .light
                                                    ? const Color
                                                    .fromARGB(255,
                                                    49, 47, 47)
                                                    : const Color
                                                    .fromARGB(
                                                    255,
                                                    255,
                                                    255,
                                                    255),
                                              ),
                                              const SizedBox(
                                                  width: 10),
                                              Text(
                                                "Edit",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .brightness ==
                                                      Brightness
                                                          .light
                                                      ? const Color
                                                      .fromARGB(
                                                      255,
                                                      49,
                                                      47,
                                                      47)
                                                      : const Color
                                                      .fromARGB(
                                                      255,
                                                      241,
                                                      232,
                                                      232),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            _databaseHelper.deletePet(
                                                pet.id!, pet.userId);
                                            ScaffoldMessenger.of(
                                                context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Deleted Successfully"),
                                              ),
                                            );
                                            Navigator.of(context)
                                                .pop();
                                            _fetchCats(); // Refresh the list after deleting
                                          },
                                          style: OutlinedButton
                                              .styleFrom(
                                            side: const BorderSide(
                                                color: Colors.red),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(Icons.delete,
                                                  color: Colors.red),
                                              SizedBox(width: 10),
                                              Text("Delete",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .red)),
                                            ],
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                pet.type.toLowerCase() == 'cat'
                                    ? 'assets/back-cat.png'
                                    : pet.type.toLowerCase() ==
                                    'parrot'
                                    ? 'assets/back-parrot.png'
                                    : 'assets/backbackback.png',
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                FileImage(File(pet.image)),
                              ),
                              title: Text(pet.name),
                              subtitle: Text("Age: ${pet.age}"),
                            ),
                          ),
                        ),
                      ),
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