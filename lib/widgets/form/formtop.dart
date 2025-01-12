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
    final heightContext = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 10,
            ),
            child: heightContext < 830
                ? SubheadingText(text: topText)
                : HeadingText(
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
            child: heightContext < 830
                ? NormalText(
                    text: bottomText,
                  )
                : SubheadingText(text: bottomText),
          ),
        ),
      ],
    );
  }
}
