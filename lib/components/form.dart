import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormDataField extends StatelessWidget {
  String label;
  int line;
  TextEditingController controller;
  TextInputType textInputType;
  Function validator;
  String hintText;
  String helperText;
  bool enabled = true;

  FormDataField({
    @required this.label,
    @required this.line,
    @required this.controller,
    @required this.textInputType,
    this.validator,
    this.hintText,
    this.helperText,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return _buildForm();
  }

  Widget _buildForm() {
    return TextFormField(
      enabled: this.enabled,
      controller: controller,
      validator: validator,
      maxLines: line,
      style: TextStyle(color: Colors.black),
      keyboardType: textInputType,
      decoration: new InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle:
              TextStyle(color: Color(0xFF848484), fontWeight: FontWeight.bold),
          hintText: hintText,
          hintStyle: TextStyle(
              color: Color(0xFF848484).withOpacity(0.5), fontSize: 11),
          labelText: label,
          helperText: helperText,
          helperStyle: TextStyle(
              color: Color(0xFF848484).withOpacity(0.7), fontSize: 11),
          suffixStyle: TextStyle(color: Colors.black45)),
    );
  }
}
