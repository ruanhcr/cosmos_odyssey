import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';

abstract class AppTypography {
  TextStyle heading({
    required double fontSize, 
    required Color color, 
    FontWeight fontWeight = FontWeight.bold,
  });
  
  TextStyle body({
    required double fontSize, 
    required Color color, 
    FontWeight fontWeight = FontWeight.normal,
    double? height,
  });
}

@Singleton(as: AppTypography)
class GoogleAppTypography implements AppTypography {
  @override
  TextStyle heading({
    required double fontSize, 
    required Color color, 
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return GoogleFonts.spaceMono(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }

  @override
  TextStyle body({
    required double fontSize, 
    required Color color, 
    FontWeight fontWeight = FontWeight.normal,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: height,
    );
  }
}