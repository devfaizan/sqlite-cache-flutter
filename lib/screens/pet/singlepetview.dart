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
    final petProvider = Provider.of<PetProvider>(context, listen: true);
    final currentUser = userFormProvider.currentUser;
    final displayedPet = petProvider.updatedPet ?? widget.pet;
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
                    displayedPet.fav == 1
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: displayedPet.fav == 1 ? Colors.red : Colors.white,
                  ),
                  onPressed: () async {
                    await petProvider.toggleFavoriteStatus(
                        displayedPet, currentUser!, _databaseHelper, context);
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
                              File(displayedPet.image),
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
                              gradient: const LinearGradient(
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
                                  text: displayedPet.type,
                                ),
                                SubheadingText(
                                  text: displayedPet.name,
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
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 50,
                  horizontal: 30,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10.0,
                          sigmaY: 10.0,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.1),
                            gradient: LinearGradient(
                              colors: [
                                colorGray,
                                colorGreenAccent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: SubheadingText(
                                    text: "‘‘ ${displayedPet.tagLine} ’’",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -25,
                      right: 10,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10.0,
                            sigmaY: 10.0,
                          ),
                          child: CustomPaint(
                            painter: TrianglePainterWithColorAndGradient(
                              fillColor: Colors.grey.shade200.withOpacity(0.01),
                              gradient: LinearGradient(
                                colors: [colorGray, colorGray],
                              ),
                              borderColor: Color.fromARGB(255, 177, 177,
                                  177), // Set the border color here
                              borderWidth: 2.0, // Set the border width here
                            ),
                            size: const Size(30, 25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                          builder: (context) => UpdateScreen(pet: displayedPet),
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
                          "Edit ${displayedPet.name}",
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

class TrianglePainterWithColorAndGradient extends CustomPainter {
  final Color fillColor;
  final Gradient gradient;
  final double borderWidth;
  final Color borderColor;

  TrianglePainterWithColorAndGradient({
    required this.fillColor,
    required this.gradient,
    required this.borderWidth,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define the triangle path
    final path = Path()
      ..moveTo(size.width / 2, 0) // Top point of the triangle
      ..lineTo(size.width, size.height) // Bottom-right point
      ..lineTo(0, size.height) // Bottom-left point
      ..close();

    // Paint for the solid color fill

    // Paint for the gradient
    final gradientPaint = Paint()
      ..shader = gradient.createShader(Offset.zero & size);
    canvas.drawPath(path, gradientPaint);

    final fillPaint = Paint()..color = fillColor;
    canvas.drawPath(path, fillPaint);

    // Paint for the border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Draw the border (if borderWidth > 0)
    if (borderWidth > 0) {
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
