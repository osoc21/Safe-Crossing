import 'package:flutter/material.dart';

class InputAddressTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final double width;
  final Icon prefixIcon;
  final Widget? suffixIcon;
  final Function(String) locationCallback;

  InputAddressTextField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.width,
    required this.prefixIcon,
    this.suffixIcon,
    required this.locationCallback,
  });

  @override
  _InputAddressTextFieldState createState() => _InputAddressTextFieldState();
}

class _InputAddressTextFieldState extends State<InputAddressTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.8,
      child: TextField(
        onChanged: (value) {
          widget.locationCallback(value);
        },
        controller: widget.controller,
        focusNode: widget.focusNode,
        decoration: new InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          labelText: widget.label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: widget.hint,
        ),
      ),
    );
  }
}
