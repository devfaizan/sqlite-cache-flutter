import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlsqlsql/dbhelper.dart';
import 'package:sqlsqlsql/provider/petprovider.dart';
import 'package:sqlsqlsql/provider/userformprovider.dart';
import 'package:sqlsqlsql/screens/pet/allpets.dart';
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
        petProvider.getPetsByType(
            'Cat', userProvider.currentUser!.id!, _databaseHelper);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
    final userProvider = Provider.of<UserFormProvider>(context);
    final currentUser = userProvider.currentUser;
    final petProvider = Provider.of<PetProvider>(context);
    final heightContext = MediaQuery.of(context).size.height;
    final widthContext = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: currentUser == null
            ? const CircularProgressIndicator()
            : Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GradientHeading(
                          text: "Welcome, ${currentUser.name}!",
                          gradient: LinearGradient(colors: [
                            colorGreenAccent,
                            colorLightPurple,
                            Colors.blue.shade900,
                          ]),
                        ),
                      ],
                    ),
                  ),
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
                                const SizedBox(height: 10),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: const LinearGradient(
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
                                                      ? FileImage(
                                                          File(favoritePet
                                                              .image),
                                                        )
                                                      : null,
                                                  child: favoritePet
                                                          .image.isEmpty
                                                      ? const Icon(Icons.pets,
                                                          size: 50)
                                                      : null,
                                                ),
                                                const Positioned(
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
                                                child: Text("Above The Rest"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 8, right: 8),
                              child: SubheadingText(
                                text: "Cats",
                              ),
                            ),
                          ],
                        ),
                        Consumer<PetProvider>(
                          builder: (context, petProvider, child) {
                            if (petProvider.isLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final petofSingleType =
                                petProvider.petsOfSingleType;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: SizedBox(
                                // height: heightContext / 6.51,
                                height: heightContext / 4.4,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: petofSingleType.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == petofSingleType.length) {
                                      return SizedBox(
                                        width: widthContext / 2.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AllPetsScreen()));
                                          },
                                          child: Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_circle_right_outlined,
                                                    // Use the desired icon
                                                    size: 40,
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? const Color.fromARGB(
                                                            255, 49, 47, 47)
                                                        : const Color.fromARGB(
                                                            255, 244, 244, 244),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Text(
                                                    "View All Cats",
                                                    // Use the desired text
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      final pet = petofSingleType[index];
                                      return SizedBox(
                                        width: widthContext / 2.0,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 35,
                                                      backgroundImage:
                                                          FileImage(
                                                        File(pet.image),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 5,
                                                          ),
                                                          child: Text(
                                                            "${pet.name}",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 15,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Flexible(
                                                            child: Text(
                                                              "says \n‘‘ ${pet.tagLine} ’’",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add New Pet",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
