import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color whiteClr = Colors.white;
const Color primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
      primaryColor: Color(0xFF4e5ae8),
      brightness: Brightness.light,
      backgroundColor: Colors.white);
  static final dark = ThemeData(
      primaryColor: Color(0xFF121212),
      brightness: Brightness.dark,
      backgroundColor: Color(0xFF121212));
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.grey[400] : Colors.grey));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}
