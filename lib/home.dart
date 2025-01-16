import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlsqlsql/dbhelper.dart';
import 'package:sqlsqlsql/provider/petprovider.dart';
import 'package:sqlsqlsql/provider/userformprovider.dart';
import 'package:sqlsqlsql/screens/pet/form.dart';
import 'package:sqlsqlsql/utils/colors.dart';
import 'package:sqlsqlsql/utils/outputtext.dart';
import 'package:sqlsqlsql/widgets/drawer/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserFormProvider>(context, listen: false);
    final petProvider = Provider.of<PetProvider>(context, listen: false);

    userProvider.loadSessionData().then((_) {
      if (userProvider.currentUser != null) {
        petProvider.getSingleFavPet(
          userId: userProvider.currentUser!.id!,
          databaseHelper: _databaseHelper,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserFormProvider>(context);
    final currentUser = userProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: currentUser == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeadingText(text: "Welcome, ${currentUser.name}!"),
                    const SizedBox(height: 20),
                    Consumer<PetProvider>(
                      builder: (context, petProvider, child) {
                        final favoritePet = petProvider.favoritePet;
                        if (petProvider.isLoading) {
                          return const CircularProgressIndicator();
                        }

                        return favoritePet == null
                            ? const NormalText(text: "No favorite pet found.")
                            : Column(
                                children: [
                                  const NormalText(text: "Favorite Pet"),
                                  const SizedBox(height: 10),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment(0.8, 1),
                                        colors: <Color>[
                                          colorPurple,
                                          colorGreen,
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 50,
                                                    backgroundImage: favoritePet
                                                            .image.isNotEmpty
                                                        ? FileImage(File(
                                                            favoritePet.image))
                                                        : null,
                                                    child: favoritePet
                                                            .image.isEmpty
                                                        ? const Icon(Icons.pets,
                                                            size: 50)
                                                        : null,
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: -20,
                                                    child: Text(
                                                      '💯',
                                                      style: TextStyle(
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? const Color.fromARGB(
                                                          255, 244, 244, 244)
                                                      : const Color.fromARGB(
                                                          255, 49, 47, 47),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 20,
                                                  ),
                                                  child: Text("Tag Line"),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              SubheadingText(
                                                  text: favoritePet.name),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
