import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlsqlsql/dbhelper.dart';
import 'package:sqlsqlsql/provider/userformprovider.dart';
import 'package:sqlsqlsql/utils/validation.dart';
import 'package:sqlsqlsql/widgets/drawer/drawer.dart';
import 'package:sqlsqlsql/widgets/form/formtop.dart';
import 'package:sqlsqlsql/widgets/inputwidget.dart';
import 'package:sqlsqlsql/widgets/primarybutton.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({
    super.key,
  });

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  String? imagePath;

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightContext = MediaQuery.of(context).size.height;
    final userFormProvider =
        Provider.of<UserFormProvider>(context, listen: false);
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
          const FormTop(
            topText: 'Make an Offline Account',
            topImagePath: 'assets/users.png',
            bottomText: 'Fill Below Fields to Make an Account',
          ),
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
                                controller: emailController,
                                hint: "Email",
                                label: "Enter Your Email",
                                preicon: Icons.mail,
                                iconsize: 25.0,
                                validation: validateEmail,
                                action: TextInputAction.next,
                              ),
                              SizedBox(
                                height: heightContext / 40,
                              ),
                              InputWidget(
                                controller: nameController,
                                hint: "User Name",
                                label: "Enter Your Name",
                                preicon: Icons.person,
                                iconsize: 25.0,
                                validation: validateText,
                                action: TextInputAction.next,
                              ),
                              SizedBox(
                                height: heightContext / 40,
                              ),
                              InputWidget(
                                controller: passwordController,
                                hint: "Password",
                                label: "Choose Password",
                                preicon: Icons.password,
                                iconsize: 25.0,
                                validation: validatePassword,
                                action: TextInputAction.done,
                                obscureText: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -20,
                    child: Consumer<UserFormProvider>(
                      builder: (context, userFormProvider, child) {
                        final imagePath = userFormProvider.imagePath;
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
                                        .read<UserFormProvider>()
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
                              context.read<UserFormProvider>().pickImage();
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
                                    context
                                        .read<UserFormProvider>()
                                        .pickImage();
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
                    userFormProvider.submitForm(
                      email: emailController.text,
                      name: nameController.text,
                      password: passwordController.text,
                      databaseHelper: _databaseHelper,
                      context: context,
                    );
                    emailController.clear();
                    nameController.clear();
                    passwordController.clear();
                  } else {
                    print("Form validation failed");
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
