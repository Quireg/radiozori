import 'package:flutter/material.dart';

//unused
class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    backgroundColor: Colors.white,
    // scaffoldBackgroundColor: AppColors.primaryLight,
    colorScheme: const ColorScheme.light(primary: Colors.black),
    // appBarTheme: AppBarTheme(
    //   backgroundColor: AppColors.primaryLight,
    // )
  );

  static ThemeData darkTheme = ThemeData(
    // scaffoldBackgroundColor: AppColors.primaryDark,
    colorScheme: ColorScheme.dark(primary: Colors.white),
    // appBarTheme: AppBarTheme(
    //   backgroundColor: AppColors.primaryDark,
    // )
  );
}
