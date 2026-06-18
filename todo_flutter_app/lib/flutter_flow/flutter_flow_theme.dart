import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlutterFlowTheme {
  static FlutterFlowTheme of(BuildContext context) => FlutterFlowTheme._();
  FlutterFlowTheme._();

  Color get primary => const Color(0xFF4B39EF);
  Color get secondary => const Color(0xFF39D2C0);
  Color get tertiary => const Color(0xFFEE8B60);
  Color get alternate => const Color(0xFFE0E3E7);
  Color get primaryText => const Color(0xFF14181B);
  Color get secondaryText => const Color(0xFF57636C);
  Color get primaryBackground => const Color(0xFFF1F4F8);
  Color get secondaryBackground => const Color(0xFFFFFFFF);
  Color get success => const Color(0xFF249689);
  Color get warning => const Color(0xFFF9CF58);
  Color get error => const Color(0xFFFF5963);
  Color get info => const Color(0xFFFFFFFF);

  TextStyle get displaySmall => GoogleFonts.urbanist(
        color: primaryText, fontWeight: FontWeight.w600, fontSize: 36);
  TextStyle get headlineLarge => GoogleFonts.urbanist(
        color: primaryText, fontWeight: FontWeight.w600, fontSize: 32);
  TextStyle get headlineMedium => GoogleFonts.urbanist(
        color: primaryText, fontWeight: FontWeight.w600, fontSize: 24);
  TextStyle get headlineSmall => GoogleFonts.urbanist(
        color: primaryText, fontWeight: FontWeight.w600, fontSize: 20);
  TextStyle get titleLarge => GoogleFonts.urbanist(
        color: primaryText, fontWeight: FontWeight.w500, fontSize: 18);
  TextStyle get titleMedium => GoogleFonts.urbanist(
        color: info, fontWeight: FontWeight.w500, fontSize: 16);
  TextStyle get titleSmall => GoogleFonts.urbanist(
        color: info, fontWeight: FontWeight.w500, fontSize: 14);
  TextStyle get labelLarge => GoogleFonts.urbanist(
        color: secondaryText, fontWeight: FontWeight.w500, fontSize: 16);
  TextStyle get labelMedium => GoogleFonts.urbanist(
        color: secondaryText, fontWeight: FontWeight.w500, fontSize: 14);
  TextStyle get labelSmall => GoogleFonts.urbanist(
        color: secondaryText, fontWeight: FontWeight.w500, fontSize: 12);
  TextStyle get bodyLarge => GoogleFonts.urbanist(
        color: primaryText, fontWeight: FontWeight.w400, fontSize: 16);
  TextStyle get bodyMedium => GoogleFonts.urbanist(
        color: primaryText, fontWeight: FontWeight.w400, fontSize: 14);
  TextStyle get bodySmall => GoogleFonts.urbanist(
        color: primaryText, fontWeight: FontWeight.w400, fontSize: 12);
}
