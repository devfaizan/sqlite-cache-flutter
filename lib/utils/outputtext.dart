import 'package:flutter/material.dart';
import 'package:sqlsqlsql/utils/colors.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.light
        ? colorBlack
        : colorWhite;
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class GradientHeading extends StatelessWidget {
  const GradientHeading(
      {required this.text, required this.gradient, super.key});

  final String text;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SubheadingText extends StatelessWidget {
  const SubheadingText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.light
        ? colorBlack
        : colorWhite;
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class UnboldSubheadingText extends StatelessWidget {
  const UnboldSubheadingText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.light
        ? colorBlack
        : colorWhite;
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 24,
      ),
    );
  }
}

class NormalText extends StatelessWidget {
  const NormalText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.light
        ? colorBlack
        : colorWhite;
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
