import 'package:flutter/material.dart';
import 'package:bikeapp/models/responsive_size.dart';

class CoolButton extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color filledColor;
  final Function() onPressed;

  CoolButton({this.title, this.textColor, this.filledColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: responsiveWidth(26.0),
      child: ElevatedButton(
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: responsiveWidth(12.0),
          ),
        ),
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(filledColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
              side: BorderSide(
                color: Colors.cyanAccent,
                width: responsiveWidth(1.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
