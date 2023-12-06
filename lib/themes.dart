import 'package:flutter/material.dart';
import 'package:weather_app/consts/colors.dart';

class Themes {

  static final lightTheme = ThemeData(
    cardColor: Colors.white,
    fontFamily: 'poppins',
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.grey.shade800,
    iconTheme: IconThemeData(
      color: Colors.grey.shade600
    )
  );

  static final darkTheme = ThemeData(
    cardColor: bgColor.withOpacity(0.6),
      fontFamily: 'poppins',
      scaffoldBackgroundColor: bgColor,
      primaryColor: Colors.white,
      iconTheme: const IconThemeData(
          color: Colors.white
      )
  );

}