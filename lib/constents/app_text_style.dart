import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle oxygen({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.oxygen(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle poppins({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: Colors.white,
    );
  }

  static TextStyle titleText({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: Colors.white,
    );
  }

  static TextStyle subTitleText() {
    return GoogleFonts.oxygen(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
  }
}
