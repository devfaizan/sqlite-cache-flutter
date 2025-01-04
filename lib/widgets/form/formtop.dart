import 'package:flutter/material.dart';
import 'package:sqlsqlsql/utils/outputtext.dart';

class FormTop extends StatelessWidget {
  final String topText;
  final String topImagePath;
  final String bottomText;
  const FormTop({
    super.key,
    required this.topText,
    required this.topImagePath,
    required this.bottomText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 10,
            ),
            child: HeadingText(
              text: topText,
            ),
          ),
        ),
        Center(
          child: Image.asset(
            topImagePath,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: SubheadingText(
              text: bottomText,
            ),
          ),
        ),
      ],
    );
  }
}
