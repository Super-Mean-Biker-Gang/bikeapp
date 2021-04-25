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
}

double deviceOrientationForWidth() {
  if (ResponsiveSize.orientation == Orientation.landscape) {
    return ResponsiveSize.widthPortion * 0.55;
  } else {
    return ResponsiveSize.widthPortion * 1.25;
  }
}

double deviceOrientationForHeight() {
  if (ResponsiveSize.orientation == Orientation.landscape) {
    return ResponsiveSize.heightPortion * 1.25;
  } else {
    return ResponsiveSize.heightPortion * 2.0;
  }
}

double responsiveWidth(double input) {
  final double deviceWidth = 375.0;
  return deviceOrientationForWidth() * (input / deviceWidth);
}

double responsiveHeight(double input) {
  final deviceHeight = 812.0;
  return deviceOrientationForHeight() * (input / deviceHeight);
}
