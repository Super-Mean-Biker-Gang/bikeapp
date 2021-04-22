import 'package:flutter/material.dart';

class ResponsiveSize {
  static Orientation orientation;
  static double widthPortion;
  static double heightPortion;

  void deviceSize(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    widthPortion = MediaQuery.of(context).size.width;
    heightPortion = MediaQuery.of(context).size.height;
  }

  double deviceOrientation(BuildContext context) {
    if (orientation == Orientation.landscape) {
      return widthPortion * 0.05;
    } else {
      return widthPortion * 0.1;
    }
  }
}

double responsiveWidth(double input) {
  final double deviceWidth = 375.0;
  double screenWidth = ResponsiveSize.widthPortion;
  return screenWidth * (input / deviceWidth);
}

double responsiveHeight(double input) {
  final deviceHeight = 812.0;
  double screenHeight = ResponsiveSize.heightPortion;
  return screenHeight * (input / deviceHeight);
}
