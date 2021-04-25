import 'package:flutter/material.dart';

Decoration decoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [
        Colors.blueAccent,
        Colors.purple[600],
      ],
    ),
  );
}
