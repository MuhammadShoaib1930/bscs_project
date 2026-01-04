import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme(String fontFamily, double fontSize) {
    return ThemeData(
      brightness: Brightness.light,
      textTheme: GoogleFonts.getTextTheme(fontFamily)
          .apply(bodyColor: Colors.black, displayColor: Colors.black)
          .copyWith(
            bodyLarge: GoogleFonts.getFont(fontFamily, fontSize: fontSize),
            bodyMedium: GoogleFonts.getFont(fontFamily, fontSize: fontSize),
            bodySmall: GoogleFonts.getFont(fontFamily, fontSize: fontSize),
          ),
    );
  }

  static ThemeData darkTheme(String fontFamily, double fontSize) {
    return ThemeData(
      brightness: Brightness.dark,
      textTheme: GoogleFonts.getTextTheme(fontFamily)
          .apply(bodyColor: Colors.white, displayColor: Colors.white)
          .copyWith(
            bodyLarge: GoogleFonts.getFont(fontFamily, fontSize: fontSize),
            bodyMedium: GoogleFonts.getFont(fontFamily, fontSize: fontSize),
            bodySmall: GoogleFonts.getFont(fontFamily, fontSize: fontSize),
          ),
    );
  }
}
