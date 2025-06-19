// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

class MyTextField extends StatelessWidget {
  String hintText;
  MyTextField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      style: AppTheme.darkTheme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppTheme.accentColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
    );
  }
}
