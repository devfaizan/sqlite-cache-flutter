import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sqlsqlsql/models/users.dart';
import 'package:sqlsqlsql/screens/user/editprofile.dart';
import 'package:sqlsqlsql/utils/colors.dart';
import 'package:sqlsqlsql/utils/outputtext.dart';
import 'package:sqlsqlsql/widgets/drawer/drawer.dart';

class UserProfile extends StatefulWidget {
  final User user;
  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final heightContext = MediaQuery.of(context).size.height;
    final widthContext = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        iconTheme: IconThemeData(
          color: colorGreenAccent,
        ),
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: [
                      Container(
                        width: widthContext,
                        height: heightContext / 1.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: FileImage(
                              File(widget.user.image),
                            ),
                            // opacity: .8,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: -30,
                    left: 35,
                    child: Center(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 2.0,
                            sigmaY: 2.0,
                          ),
                          child: Container(
                            width: widthContext / 1.2,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey.shade200.withOpacity(0.3),
                              gradient: LinearGradient(
                                colors: [
                                  colorLightPurple,
                                  colorGreenAccent,
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                NormalText(
                                  text: widget.user.email,
                                ),
                                SubheadingText(
                                  text: widget.user.name,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfileScreen(user: widget.user),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                        ),
                        Text(
                          "Edit",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
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
}
