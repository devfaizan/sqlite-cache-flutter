import 'package:flutter/material.dart';
import 'package:sqlsqlsql/utils/colors.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.label,
    required this.preicon,
    this.iconcolor = colorPurple,
    required this.iconsize,
    required this.validation,
    this.keyboard = TextInputType.text,
    this.action = TextInputAction.go,
    this.obscureText = false,
  });
  final TextEditingController controller;
  final String hint;
  final String label;
  final IconData preicon;
  final Color iconcolor;
  final double iconsize;
  final String? Function(String?) validation;
  final TextInputType keyboard;
  final TextInputAction action;
  final bool? obscureText;

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late FocusNode myFocusNode;
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    _isObscure = widget.obscureText ?? false;
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(myFocusNode);
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: colorGray,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: colorGreenAccent,
          ),
        ),
        hintText: widget.hint,
        labelText: widget.label,
        labelStyle: TextStyle(
          color: myFocusNode.hasFocus ? colorGreen : colorGray,
        ),
        prefixIcon: Icon(
          widget.preicon,
          size: widget.iconsize,
          color: widget.iconcolor,
        ),
        suffixIcon: widget.obscureText!
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: colorGray,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
      obscureText: _isObscure,
      focusNode: myFocusNode,
      keyboardType: widget.keyboard,
      textInputAction: widget.action,
      onTap: _requestFocus,
      controller: widget.controller,
      validator: widget.validation,
    );
  }
}
