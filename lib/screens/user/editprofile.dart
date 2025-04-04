import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlsqlsql/home.dart';
import 'package:sqlsqlsql/models/users.dart';
import 'package:sqlsqlsql/provider/userformprovider.dart';
import 'package:sqlsqlsql/utils/validation.dart';
import 'package:sqlsqlsql/widgets/inputwidget.dart';
import 'package:sqlsqlsql/widgets/primarybutton.dart';

import '../../dbhelper.dart';

class EditProfileScreen extends StatefulWidget {
  final User? user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?.name ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userFormProvider = Provider.of<UserFormProvider>(context);
    final currentUser = userFormProvider.currentUser;
    final heightContext = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.user!.name}'s Profile"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: heightContext / 50,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await userFormProvider.pickImage();
            },
            child: const Text("Change Image"),
          ),
          Consumer<UserFormProvider>(
            builder: (context, userFormProvider, child) {
              return CircleAvatar(
                radius: 120,
                backgroundImage: userFormProvider.imagePath.isNotEmpty
                    ? FileImage(File(userFormProvider.imagePath))
                    : FileImage(File(widget.user!.image)),
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
                  padding: EdgeInsets.symmetric(
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
                            hint: "User Name",
                            label: "Enter Your Name",
                            preicon: Icons.person,
                            iconsize: 25.0,
                            validation: validateText,
                            action: TextInputAction.done,
                          ),
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
                text: "Update Profile",
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    final name = nameController.text.trim();
                    final newImagePath = userFormProvider.imagePath;

                    if (name == widget.user?.name &&
                        (newImagePath.isEmpty ||
                            newImagePath == widget.user?.image)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No changes were made'),
                        ),
                      );
                      return;
                    }

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields correctly'),
                        ),
                      );
                      return;
                    }

                    final updatedUser = UpdateUser(
                      id: widget.user!.id!,
                      email: currentUser!.email,
                      name: name,
                      image: newImagePath.isNotEmpty
                          ? newImagePath
                          : widget.user!.image,
                    );

                    await userFormProvider.updateUser(
                      user: updatedUser,
                      databaseHelper: _databaseHelper,
                      context: context,
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
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
