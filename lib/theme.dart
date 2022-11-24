import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

//const scaffoldBackgroundColorColor(0xFFa7a6ba);

class Themes {
  static final light = ThemeData(
      backgroundColor: Colors.white,
      primaryColor: Colors.deepPurple,
      brightness: Brightness.light
  );

  static final dark = ThemeData(
      backgroundColor: Colors.deepPurple,
      primaryColor: Colors.purpleAccent,
      brightness: Brightness.dark
  );
}

TextStyle get headingTitleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode?Colors.deepPurpleAccent[50]:Colors.deepPurple
      )
  );
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode?Colors.deepPurpleAccent:Colors.deepPurple
      )
  );
}

TextStyle get headingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode?Colors.deepPurpleAccent:Colors.deepPurple
      )
  );
}