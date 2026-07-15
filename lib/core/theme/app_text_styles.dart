import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Using Anek Malayalam for seamless, premium multi-language support (English & Malayalam)
  static TextStyle get splashTitle => GoogleFonts.anekMalayalam(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        letterSpacing: 8.0,
      );
      
  static TextStyle get splashTitleBold => GoogleFonts.anekMalayalam(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.0,
      );

  static TextStyle get heading => GoogleFonts.anekMalayalam(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get body => GoogleFonts.anekMalayalam(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );
}
