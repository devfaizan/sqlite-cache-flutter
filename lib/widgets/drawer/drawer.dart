import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlsqlsql/home.dart';
import 'package:sqlsqlsql/provider/userformprovider.dart';
import 'package:sqlsqlsql/screens/app/settings.dart';
import 'package:sqlsqlsql/screens/pet/allpets.dart';
import 'package:sqlsqlsql/screens/user/login.dart';
import 'package:sqlsqlsql/screens/user/userprofile.dart';
import 'package:sqlsqlsql/utils/colors.dart';
import 'package:sqlsqlsql/utils/outputtext.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserFormProvider>(context);
    final currentUser = userProvider.currentUser;
    return Drawer(
        child: ListView(
      children: [
        if (currentUser != null && currentUser.image.isNotEmpty)
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(
                    user: currentUser,
                  ),
                ),
              );
            },
            child: DrawerHeader(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      colorPurple,
                      colorGreen,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: FileImage(File(currentUser.image)),
                      radius: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: NormalText(text: currentUser.email),
                    )
                  ],
                ),
              ),
            ),
          ),
        if (currentUser != null)
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
        if (currentUser != null && currentUser.image.isNotEmpty)
          ListTile(
            leading: Icon(Icons.pets),
            title: Text("All Pets"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllPetsScreen()));
            },
          ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingScreen()));
          },
        ),
        ListTile(
          leading: currentUser != null ? Icon(Icons.logout) : Icon(Icons.login),
          title: currentUser != null ? Text("Logout") : Text("Login"),
          onTap: () {
            Navigator.pop(context);
            if (currentUser != null) {
              userProvider.userLogout(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          },
        ),
      ],
    ));
  }
}
