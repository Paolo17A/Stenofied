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

Text cinzelText(String label,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow}) {
  return Text(
    label,
    textAlign: textAlign,
    overflow: overflow,
    style: GoogleFonts.cinzel(
        fontSize: fontSize, fontWeight: fontWeight, color: color),
  );
}

Text jostText(String label,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow}) {
  return Text(
    label,
    textAlign: textAlign,
    overflow: overflow,
    style: GoogleFonts.jost(
        fontSize: fontSize, fontWeight: fontWeight, color: color),
  );
}

Text josepfinSansText(String label,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow}) {
  return Text(
    label,
    textAlign: textAlign,
    overflow: overflow,
    style: GoogleFonts.josefinSans(
        fontSize: fontSize, fontWeight: fontWeight, color: color),
  );
}

Text andandaProText(String label,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow}) {
  return Text(
    label,
    textAlign: textAlign,
    overflow: overflow,
    style: GoogleFonts.andadaPro(
        fontSize: fontSize, fontWeight: fontWeight, color: color),
  );
}

Text whiteCinzelBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? textOverflow,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: 5,
      style: GoogleFonts.cinzel(
          fontSize: fontSize,
          color: Colors.white,
          decoration: textDecoration,
          fontWeight: FontWeight.bold));
}

Text whiteAndadaProBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? textOverflow,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: 5,
      style: GoogleFonts.andadaPro(
          fontSize: fontSize,
          color: Colors.white,
          decoration: textDecoration,
          fontWeight: FontWeight.bold));
}

Text whiteAndadaProRegular(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? textOverflow,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: 5,
      style: GoogleFonts.andadaPro(
          fontSize: fontSize, color: Colors.white, decoration: textDecoration));
}

Text whiteJosefinSansBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? textOverflow,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: 5,
      style: GoogleFonts.josefinSans(
          fontSize: fontSize,
          color: Colors.white,
          decoration: textDecoration,
          fontWeight: FontWeight.bold));
}

Text blackJosefinSansBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? textOverflow,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: 5,
      style: GoogleFonts.josefinSans(
          fontSize: fontSize,
          color: Colors.black,
          decoration: textDecoration,
          fontWeight: FontWeight.bold));
}

Text blackCinzelBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? textOverflow,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: 5,
      style: GoogleFonts.cinzel(
          fontSize: fontSize,
          color: Colors.black,
          decoration: textDecoration,
          fontWeight: FontWeight.bold));
}

Text blackCinzelRegular(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? textOverflow,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: 5,
      style: GoogleFonts.cinzel(
          fontSize: fontSize, color: Colors.black, decoration: textDecoration));
}

Text blackAndadaProBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? textOverflow,
    TextDecoration? textDecoration,
    int maxLines = 5}) {
  return Text(label,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: maxLines,
      style: GoogleFonts.andadaPro(
          fontSize: fontSize,
          color: Colors.black,
          decoration: textDecoration,
          fontWeight: FontWeight.bold));
}

Text blackAndadaProRegular(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? textOverflow,
    TextDecoration? textDecoration,
    int maxLines = 5}) {
  return Text(label,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: maxLines,
      style: GoogleFonts.andadaPro(
          fontSize: fontSize, color: Colors.black, decoration: textDecoration));
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
