import 'package:flutter/material.dart';
import 'package:stenofied/utils/color_util.dart';

final ThemeData themeData = ThemeData(
    colorSchemeSeed: CustomColors.turquoise,
    scaffoldBackgroundColor: CustomColors.parchment,
    appBarTheme: const AppBarTheme(backgroundColor: CustomColors.turquoise),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CustomColors.turquoise,
        selectedItemColor: CustomColors.mintGreen),
    listTileTheme: const ListTileThemeData(
        iconColor: CustomColors.mintGreen,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)))),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadiusDirectional.all(Radius.circular(10)))),
            backgroundColor:
                MaterialStateProperty.all<Color>(CustomColors.ketchup))));
