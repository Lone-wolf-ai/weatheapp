import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weatherapp/consts/colors.dart';

class Customthemes {
  static final ligthTheme = ThemeData(
      fontFamily: "poppins",
      cardColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Vx.gray800,
      iconTheme: const IconThemeData(color: Vx.gray600));

  static final darkTheme = ThemeData(
      fontFamily: "poppins",
      scaffoldBackgroundColor: bgColor,
      primaryColor: Vx.white,
      cardColor: bgColor,
      iconTheme: const IconThemeData(color: Vx.white));
}
