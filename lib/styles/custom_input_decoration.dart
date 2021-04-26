import 'package:flutter/material.dart';
import 'package:bikeapp/models/responsive_size.dart';

InputDecoration customInputDecoration({String hint, Icon icon}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.white,
      fontSize: responsiveWidth(10.0),
    ),
    errorStyle: TextStyle(
      color: Colors.redAccent,
      fontSize: responsiveWidth(9.0),
      fontWeight: FontWeight.w500,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: Colors.cyanAccent,
        width: responsiveWidth(2.0),
      ),
    ),
    prefixIcon: Container(
      padding: EdgeInsets.only(left: 25, right: 20),
      child: IconTheme(
        data: IconThemeData(color: Colors.white),
        child: icon,
      ),
    ),
  );
}
