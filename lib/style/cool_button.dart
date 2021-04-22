import 'package:flutter/material.dart';
import 'package:bikeapp/models/responsive_size.dart';

class CoolButton extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color filledColor;
  final Color splashColor;
  final Function() onPressed;

  CoolButton(
      {this.title,
      this.textColor,
      this.filledColor,
      this.splashColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: responsiveWidth(35.0),
      child: RaisedButton(
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: responsiveWidth(16.0),
          ),
        ),
        color: filledColor,
        splashColor: splashColor,
        onPressed: onPressed,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: responsiveWidth(1.0),
          ),
        ),
      ),
    );
  }
}
