import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqlsqlsql/dbhelper.dart';
import 'package:sqlsqlsql/utils/validation.dart';
import 'package:sqlsqlsql/widgets/drawer/drawer.dart';
import 'package:sqlsqlsql/widgets/form/formtop.dart';
import 'package:sqlsqlsql/widgets/inputdrop.dart';
import 'package:sqlsqlsql/widgets/inputwidget.dart';
import 'package:sqlsqlsql/widgets/primarybutton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sqlsqlsql/provider/userformprovider.dart';

import '../../provider/petprovider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? selectedPetType;
  final _key = GlobalKey<FormState>();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  String? imagePath;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Future<void> showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userFormProvider = Provider.of<UserFormProvider>(context);
    final currentUser = userFormProvider.currentUser;
    final heightContext = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      drawer: const AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: heightContext < 830 ? 0 : heightContext / 20,
            ),
          ),
          const FormTop(),
          Padding(
            padding: EdgeInsets.only(
              top:
                  heightContext < 830 ? heightContext / 60 : heightContext / 30,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).brightness == Brightness.light
                          ? const Color.fromARGB(255, 244, 244, 244)
                          : const Color.fromARGB(255, 49, 47, 47),
                    ),
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: heightContext < 830 ? 80 : 20,
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
                              DropdownWidget(
                                items: ['Cat', 'Parrot', 'Rooster', 'Duck'],
                                hint: 'Select Type of Your Pet',
                                label: "Pet Type",
                                preicon: Icons.pets,
                                iconsize: 25.0,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPetType = value;
                                  });
                                  print('Selected value: $value');
                                },
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select an option';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -20,
                    child: Consumer<PetProvider>(
                      builder: (context, petProvider, child) {
                        final imagePath = petProvider.imagePath;
                        if (imagePath.isNotEmpty) {
                          return Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomRight,
                            children: <Widget>[
                              CircleAvatar(
                                radius: heightContext < 830 ? 50 : 60,
                                backgroundImage: FileImage(File(imagePath)),
                              ),
                              Positioned(
                                right: -4,
                                bottom: -10,
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<PetProvider>()
                                        .clearImagePath();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? const Color.fromARGB(
                                              255, 49, 47, 47)
                                          : const Color.fromARGB(
                                              255, 244, 244, 244),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? const Color.fromARGB(
                                              255, 244, 244, 244)
                                          : const Color.fromARGB(
                                              255, 49, 47, 47),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              context.read<PetProvider>().pickImage();
                            },
                            child: CircleAvatar(
                              radius: heightContext < 830 ? 51 : 61,
                              backgroundColor: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? const Color.fromARGB(255, 49, 47, 47)
                                  : const Color.fromARGB(255, 255, 255, 255),
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? const Color.fromARGB(255, 244, 244, 244)
                                    : const Color.fromARGB(255, 49, 47, 47),
                                radius: heightContext < 830 ? 50 : 60,
                                child: IconButton(
                                  icon: const Icon(
                                      Icons.add_photo_alternate_outlined),
                                  onPressed: () {
                                    context.read<PetProvider>().pickImage();
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: heightContext < 830 ? 10 : 20,
          ),
          Column(
            children: [
              PrimaryButton(
                text: "Let's Go",
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    if (selectedPetType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please select a pet type')),
                      );
                      return;
                    }
                    final petProvider =
                        Provider.of<PetProvider>(context, listen: false);
                    petProvider.submitForm(
                      name: nameController.text,
                      age: int.parse(ageController.text),
                      type: selectedPetType!,
                      databaseHelper: _databaseHelper,
                      context: context,
                      userId: currentUser!.id!,
                    );
                    nameController.clear();
                    ageController.clear();
                  } else {
                    print("no gando giri");
                  }
                },
                borderRadius: BorderRadius.circular(5),
                textsize: 20,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: heightContext < 830 ? 10 : 30,
            ),
          ),
        ],
      ),
    );
  }
}
