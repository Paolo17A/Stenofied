import 'package:flutter/material.dart';
import 'package:stenofied/utils/color_util.dart';

final ThemeData themeData = ThemeData(
    colorSchemeSeed: CustomColors.sangria,
    scaffoldBackgroundColor: CustomColors.parchment,
    appBarTheme: const AppBarTheme(backgroundColor: CustomColors.parchment),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CustomColors.latte, selectedItemColor: Colors.white),
    listTileTheme: const ListTileThemeData(
        iconColor: Colors.white,
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
