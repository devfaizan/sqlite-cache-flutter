import 'package:flutter/material.dart';
import 'package:sqlsqlsql/utils/outputtext.dart';

class FormTop extends StatelessWidget {
  const FormTop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              bottom: 10,
            ),
            child: HeadingText(
              text: "SQLite Operations",
            ),
          ),
        ),
        Center(
          child: Image.asset('assets/sqlite.png'),
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: SubheadingText(text: "Fill the fields listed below"),
          ),
        ),
      ],
    );
  }
}
