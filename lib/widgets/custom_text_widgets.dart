import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stenofied/utils/color_util.dart';

Text interText(String label,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow}) {
  return Text(
    label,
    textAlign: textAlign,
    overflow: overflow,
    style: GoogleFonts.inter(
        fontSize: fontSize, fontWeight: fontWeight, color: color),
  );
}

Text sangriaInterBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      style: GoogleFonts.inter(
          fontSize: fontSize,
          color: CustomColors.sangria,
          decoration: textDecoration,
          fontWeight: FontWeight.bold));
}

Text whiteInterBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? textOverflow,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: 5,
      style: GoogleFonts.inter(
          fontSize: fontSize,
          color: Colors.white,
          decoration: textDecoration,
          fontWeight: FontWeight.bold));
}

Text whiteInterRegular(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      style: GoogleFonts.inter(
          fontSize: fontSize, color: Colors.white, decoration: textDecoration));
}

Text blackInterBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      style: GoogleFonts.inter(
          fontSize: fontSize,
          color: Colors.black,
          decoration: textDecoration,
          fontWeight: FontWeight.bold));
}

Text blackInterRegular(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      style: GoogleFonts.inter(
          fontSize: fontSize, color: Colors.black, decoration: textDecoration));
}
