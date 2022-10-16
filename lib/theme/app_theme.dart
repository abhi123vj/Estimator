
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import 'app_bar_theme.dart';

class AppTheme {
  static final theme = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.cyanDark,
      backgroundColor: AppColors.yellowPale,
      scaffoldBackgroundColor: AppColors.yellowPale,
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            padding:  MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 20)),
              foregroundColor: MaterialStateProperty.all<Color>(
        AppColors.cyanNormal,
      ))),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.robotoMonoTextTheme().apply(
        bodyColor: AppColors.black,
        //displayColor: Colors.blue,
      ),
      appBarTheme: CustomAppBarTheme.theme);
}