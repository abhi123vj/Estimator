import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hyundai_expense/constants/app_colors.dart';

class CustomAppBarTheme {
  static final  theme = AppBarTheme(
    titleTextStyle:GoogleFonts.robotoMonoTextTheme().titleMedium!.copyWith(color: AppColors.blackGlaze,fontWeight: FontWeight.w800,fontSize: 18),
    color: AppColors.cyanNormal,
    elevation: 0
  );
}