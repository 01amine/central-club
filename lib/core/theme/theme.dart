import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF1A1A1A); 
  static const Color secondaryColor = Color(0xFF2A2A2A);
  static const Color accentColor = Color(0xFF3A3A3A); 
  
  // Text Colors
  static const Color primaryTextColor = Color(0xFFFFFFFF);
  static const Color secondaryTextColor = Color(0xFFB0B0B0);
  static const Color hintTextColor = Color(0xFF666666); 
  
  // Interactive Colors
  static const Color buttonColor = Color(0xFF000000);
  static const Color selectedColor = Color(0xFF4A4A4A);
  static const Color borderColor = Color(0xFF333333); 
  
  // Status Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53E3E); 
  static const Color warningColor = Color(0xFFFF9800);
  
  // Social Colors
  static const Color googleColor = Color(0xFF4285F4); 
  static const Color facebookColor = Color(0xFF1877F2);
  
  // Transparent Colors
  static const Color overlayColor = Color(0x80000000); 
  static const Color cardColor = Color(0xFF1E1E1E); 
  
  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: primaryColor,
      cardColor: cardColor,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          color: primaryTextColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.poppins(
          color: primaryTextColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.poppins(
          color: primaryTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: GoogleFonts.poppins(
          color: primaryTextColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: GoogleFonts.poppins(
          color: primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.poppins(
          color: primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.poppins(
          color: primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: GoogleFonts.poppins(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: GoogleFonts.poppins(
          color: secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: GoogleFonts.poppins(
          color: secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: GoogleFonts.poppins(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: GoogleFonts.poppins(
          color: secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.poppins(
          color: hintTextColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}