import "package:flutter/material.dart";
import "package:sqlsqlsql/models/cats.dart";

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
        centerTitle: true,
      ),
      body: Center(
        child: Text(widget.pet.type),
      ),
    );
  }
}
