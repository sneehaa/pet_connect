import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_connect/config/themes/app_colors.dart';

class AppStyles {
  const AppStyles._();

  static TextStyle headline1 = GoogleFonts.alice(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle headline2 = GoogleFonts.alice(
    fontSize: 35,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle headline3 = GoogleFonts.alice(
    fontSize: 23,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle subtitle = GoogleFonts.alice(
    color: AppColors.textLightGrey,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static TextStyle body = GoogleFonts.alice(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static TextStyle small = GoogleFonts.alice(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textLightGrey,
  );

  static TextStyle button = GoogleFonts.alice(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle linkText = GoogleFonts.alice(
    fontSize: 18,
    color: AppColors.errorRed,
  );
 
}
