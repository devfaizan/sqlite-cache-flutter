import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlsqlsql/dbhelper.dart';
import 'package:sqlsqlsql/models/cats.dart';
import 'package:sqlsqlsql/provider/petprovider.dart';
import 'package:sqlsqlsql/provider/userformprovider.dart';
import 'package:sqlsqlsql/screens/pet/singlepetview.dart';
import 'package:sqlsqlsql/utils/validation.dart';
import 'package:sqlsqlsql/widgets/inputdrop.dart';
import 'package:sqlsqlsql/widgets/inputwidget.dart';
import 'package:sqlsqlsql/widgets/primarybutton.dart';

class UpdateScreen extends StatefulWidget {
  final Pet? pet;

  const UpdateScreen({super.key, this.pet});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController tagLineController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? selectedPetType;
  final _key = GlobalKey<FormState>();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  String? imagePath;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.pet?.name ?? '');
    tagLineController = TextEditingController(text: widget.pet?.tagLine ?? '');
    ageController =
        TextEditingController(text: widget.pet?.age.toString() ?? '');
    imagePath = widget.pet?.image;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final petProvider = Provider.of<PetProvider>(context, listen: false);
      petProvider.setSelectedPetType(widget.pet?.type);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserFormProvider>(context);
    final petProvider = Provider.of<PetProvider>(context, listen: true);
    final currentUser = userProvider.currentUser;
    final heightContext = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Edit ${widget.pet!.name}"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: heightContext / 50,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await petProvider.pickImage();

            },
            child: const Text("Change Image"),
          ),
          Consumer<PetProvider>(
            builder: (context, petProvider, child) {
              return CircleAvatar(
                radius: 120,
                backgroundImage: petProvider.imagePath.isNotEmpty
                    ? FileImage(File(petProvider.imagePath))
                    : FileImage(File(widget.pet!.image)),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              top: heightContext / 50,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).brightness == Brightness.light
                      ? const Color.fromARGB(255, 244, 244, 244)
                      : const Color.fromARGB(255, 49, 47, 47),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  children: <Widget>[
                    SizedBox(
                      height: heightContext < 830
                          ? heightContext / 30
                          : heightContext / 10,
                    ),
                    Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InputWidget(
                            controller: nameController,
                            hint: "Pet Name",
                            label: "Enter Your Pet Name",
                            preicon: Icons.person,
                            iconsize: 25.0,
                            validation: validateText,
                            action: TextInputAction.next,
                          ),
                          SizedBox(
                            height: heightContext / 40,
                          ),
                          InputWidget(
                            controller: tagLineController,
                            hint: "Pet Tag Line",
                            label: "Enter Your Pet Tag Line",
                            preicon: Icons.tag,
                            iconsize: 25.0,
                            keyboard: TextInputType.text,
                            validation: validateText,
                            action: TextInputAction.next,
                          ),
                          SizedBox(
                            height: heightContext / 40,
                          ),
                          InputWidget(
                            controller: ageController,
                            hint: "Pet Age",
                            label: "Enter Your Pet Age",
                            preicon: Icons.cake,
                            iconsize: 25.0,
                            keyboard: TextInputType.number,
                            validation: validateNumber,
                            action: TextInputAction.next,
                          ),
                          SizedBox(
                            height: heightContext / 40,
                          ),
                          Consumer<PetProvider>(
                              builder: (context, petProvider, child) {
                            return DropdownWidget(
                              items: const ['Cat', 'Parrot', 'Rooster', 'Duck'],
                              hint: 'Select Type of Your Pet',
                              label: "Pet Type",
                              preicon: Icons.pets,
                              iconsize: 25.0,
                              onChanged: (value) {
                                petProvider.setSelectedPetType(value);
                              },
                              initialValue: petProvider.selectedPetType,
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select an option';
                                }
                                return null;
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: heightContext / 50,
            ),
          ),
          Column(
            children: [
              PrimaryButton(
                text: "Update Pet",
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    await petProvider.updatePet(
                      name: nameController.text,
                      age: int.parse(ageController.text),
                      type: petProvider.selectedPetType!,
                      tagline: tagLineController.text,
                      databaseHelper: _databaseHelper,
                      context: context,
                      userId: currentUser!.id!,
                      petId: widget.pet!.id!,
                    );
                    final updatedPet =
                        await _databaseHelper.getSinglePetById(widget.pet!.id!);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: petProvider,
                          child: SinglePetScreen(pet: updatedPet!),
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                  } else {
                    if (kDebugMode) {
                      print("not working");
                    }
                  }
                },
                borderRadius: BorderRadius.circular(5),
                textsize: 20,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: heightContext / 90,
            ),
          ),
        ],
      ),
    );
  }
}
