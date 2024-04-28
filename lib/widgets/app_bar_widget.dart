import 'package:flutter/material.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/string_util.dart';

PreferredSizeWidget appBarWidget(
    {bool mayGoBack = false, List<Widget>? actions}) {
  return AppBar(
      automaticallyImplyLeading: mayGoBack,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(ImagePaths.logo, scale: 9),
          //whiteInterBold('STENOFIED')
        ],
      ),
      iconTheme: const IconThemeData(color: CustomColors.sangria),
      actions: actions);
}
