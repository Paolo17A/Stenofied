import 'package:flutter/material.dart';

import '../utils/color_util.dart';
import '../utils/navigator_util.dart';
import 'custom_text_widgets.dart';

Widget studentBottomNavBar(BuildContext context, {required String path}) {
  return BottomAppBar(
    color: CustomColors.turquoise,
    height: 85,
    notchMargin: 0,
    shape: CircularNotchedRectangle(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            children: [
              IconButton(
                  onPressed: () => path == NavigatorRoutes.studentHome
                      ? null
                      : Navigator.of(context)
                          .pushNamed(NavigatorRoutes.studentHome),
                  icon: Icon(Icons.home,
                      color: path == NavigatorRoutes.studentHome
                          ? Colors.white
                          : CustomColors.mintGreen)),
              interText('HOME',
                  fontSize: 8,
                  color: path == NavigatorRoutes.studentHome
                      ? Colors.white
                      : CustomColors.mintGreen)
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            children: [
              IconButton(
                  onPressed: () => path == NavigatorRoutes.studentLessons
                      ? null
                      : Navigator.of(context)
                          .pushNamed(NavigatorRoutes.studentLessons),
                  icon: Icon(Icons.library_books_rounded,
                      color: path == NavigatorRoutes.studentLessons
                          ? Colors.white
                          : CustomColors.mintGreen)),
              interText('LESSONS',
                  fontSize: 8,
                  color: path == NavigatorRoutes.studentLessons
                      ? Colors.white
                      : CustomColors.mintGreen)
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            children: [
              IconButton(
                  onPressed: () => path == 'aaa' ? null : () {},
                  icon: Icon(Icons.quiz,
                      color: path == 'aaa'
                          ? Colors.white
                          : CustomColors.mintGreen)),
              interText('EXERCISES',
                  fontSize: 8,
                  color: path == 'aaa' ? Colors.white : CustomColors.mintGreen)
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            children: [
              IconButton(
                  onPressed: () => path == 'aaa' ? null : () {},
                  icon: Icon(Icons.edit_document,
                      color: path == 'aaa'
                          ? Colors.white
                          : CustomColors.mintGreen)),
              interText('QUIZZES',
                  fontSize: 8,
                  color: path == 'aaa' ? Colors.white : CustomColors.mintGreen)
            ],
          ),
        ),
      ],
    ),
  );
}
