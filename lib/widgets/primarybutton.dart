import 'package:flutter/material.dart';
import 'package:sqlsqlsql/utils/colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.borderRadius,
    required this.textsize,
  });

  final String text;
  final VoidCallback onPressed;
  final BorderRadius borderRadius;
  final double? textsize;
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.light
        ? colorWhite
        : colorBlack;
    final backColor = Theme.of(context).brightness == Brightness.light
        ? colorBlack
        : colorWhite;
    return SizedBox(
      height: 60.0,
      child: MaterialButton(
        onPressed: onPressed,
        elevation: 5.0,
        child: Container(
          decoration: BoxDecoration(
            color: backColor,
            borderRadius: borderRadius,
          ),
          constraints: const BoxConstraints(
            maxHeight: 60,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: textsize,
              fontWeight: FontWeight.bold,
              // fontFamily: fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}
