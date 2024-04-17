import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/utils/string_util.dart';

PreferredSizeWidget appBarWidget(
    {bool mayGoBack = false, List<Widget>? actions}) {
  return AppBar(
      automaticallyImplyLeading: mayGoBack,
      title: Row(
        children: [
          Image.asset(ImagePaths.logo, scale: 9),
          Gap(10),
          //whiteInterBold('STENOFIED')
        ],
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: actions);
}
