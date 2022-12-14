import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.keyboardType,
    this.maxLines = 1,
    this.label,
    this.hintText,
    required this.icon,
    required this.controller,
    this.isClickable = true,
    this.validator,
    this.onTap,
    this.onFieldSubmitted,
  }) : super(key: key);
  final TextInputType? keyboardType;
  final int maxLines;
  final String? label;
  final String? hintText;
  final Widget icon;
  final TextEditingController controller;
  final bool isClickable;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final void Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        showCursor: !isClickable,
        readOnly: !isClickable,
        validator: validator,
        onTap: onTap,
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          icon: icon,
        ),
      ),
    );
  }
}
