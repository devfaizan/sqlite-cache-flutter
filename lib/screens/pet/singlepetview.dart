import "dart:io";
import "dart:ui";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:sqlsqlsql/dbhelper.dart";
import "package:sqlsqlsql/models/cats.dart";
import "package:sqlsqlsql/provider/petprovider.dart";
import "package:sqlsqlsql/provider/userformprovider.dart";
import "package:sqlsqlsql/screens/pet/updatepets.dart";
import "package:sqlsqlsql/utils/colors.dart";
import "package:sqlsqlsql/utils/outputtext.dart";

class SinglePetScreen extends StatefulWidget {
  final Pet pet;
  const SinglePetScreen({
    super.key,
    required this.pet,
  });

  @override
  State<SinglePetScreen> createState() => _SinglePetScreenState();
}

class _SinglePetScreenState extends State<SinglePetScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final heightContext = MediaQuery.of(context).size.height;
    final widthContext = MediaQuery.of(context).size.width;
    final userFormProvider =
        Provider.of<UserFormProvider>(context, listen: false);
    final currentUser = userFormProvider.currentUser;
    return Scaffold(
      key: _key,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: [
          Consumer<PetProvider>(
            builder: (context, petProvider, child) {
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorGray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(
                    widget.pet.fav == 1
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.pet.fav == 1 ? Colors.red : Colors.white,
                  ),
                  onPressed: () async {
                    await petProvider.toggleFavoriteStatus(
                        widget.pet, currentUser!, _databaseHelper, context);
                  },
                ),
              );
            },
          ),
        ],
        iconTheme: IconThemeData(
          color: colorGreenAccent,
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
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
                              File(widget.pet.image),
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
                                  text: widget.pet.type,
                                ),
                                SubheadingText(
                                  text: widget.pet.name,
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
                          builder: (context) => UpdateScreen(pet: widget.pet),
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
                          "Edit Pet",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubheadingText(
                    text: "Tag Line",
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
