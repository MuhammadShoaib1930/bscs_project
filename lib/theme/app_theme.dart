import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(String fontFamily, double fontSize) {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: fontFamily, 
      textTheme: ThemeData.light().textTheme
          .apply(bodyColor: Colors.black, displayColor: Colors.black)
          .copyWith(
            bodyLarge: TextStyle(fontSize: fontSize),
            bodyMedium: TextStyle(fontSize: fontSize),
            bodySmall: TextStyle(fontSize: fontSize),
          ),
      useMaterial3: true,
    );
  }

  static ThemeData darkTheme(String fontFamily, double fontSize) {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      textTheme: ThemeData.dark().textTheme
          .apply(bodyColor: Colors.white, displayColor: Colors.white)
          .copyWith(
            bodyLarge: TextStyle(fontSize: fontSize),
            bodyMedium: TextStyle(fontSize: fontSize),
            bodySmall: TextStyle(fontSize: fontSize),
          ),
      useMaterial3: true,
    );
  }
}
