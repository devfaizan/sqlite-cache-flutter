import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlsqlsql/provider/globalappprovider.dart';
import 'package:sqlsqlsql/utils/colors.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({
    super.key,
    required this.items,
    required this.hint,
    required this.label,
    required this.preicon,
    this.iconcolor = colorPurple,
    required this.iconsize,
    required this.onChanged,
    this.validation,
    this.initialValue,
  });
  final List<String> items;
  final String hint;
  final String label;
  final IconData preicon;
  final Color iconcolor;
  final double iconsize;
  final Function(String?) onChanged;
  final String? Function(String?)? validation;
  final String? initialValue;

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  late FocusNode myFocusNode;


  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<AppProvider>(context);
    return FormField<String>(
      validator: widget.validation,
      builder: (FormFieldState<String> state) {
        return InputDecorator(
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
            errorText: state.errorText,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: globalProvider.selectedValue,
              isExpanded: true,
              onChanged: (newValue) {
                globalProvider.setSelectedValue(newValue);
                widget.onChanged.call(newValue);
                state.didChange(newValue);
              },
              items: widget.items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
