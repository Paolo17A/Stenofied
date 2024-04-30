import 'package:flutter/material.dart';

import '../utils/color_util.dart';
import '../utils/navigator_util.dart';
import 'custom_text_widgets.dart';

Widget studentBottomNavBar(BuildContext context, {required String path}) {
  return BottomAppBar(
    color: CustomColors.latte,
    height: 85,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: bottomButton(context,
                iconData: Icons.home,
                label: 'HOME',
                thisPath: NavigatorRoutes.studentHome,
                currentPath: path)),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: bottomButton(context,
                iconData: Icons.library_books_rounded,
                label: 'LESSONS',
                thisPath: NavigatorRoutes.studentLessons,
                currentPath: path)),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: bottomButton(context,
                iconData: Icons.quiz,
                label: 'EXERCISES',
                thisPath: NavigatorRoutes.studentExercises,
                currentPath: path)),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: bottomButton(context,
                iconData: Icons.edit_document,
                label: 'QUIZZES',
                thisPath: NavigatorRoutes.studentQuizzes,
                currentPath: path))
      ],
    ),
  );
}

Widget teacherBottomNavBar(BuildContext context, {required String path}) {
  return BottomAppBar(
    color: CustomColors.latte,
    height: 85,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: bottomButton(context,
                iconData: Icons.home,
                label: 'HOME',
                thisPath: NavigatorRoutes.teacherHome,
                currentPath: path)),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: bottomButton(context,
                iconData: Icons.people,
                label: 'MY SECTION',
                thisPath: NavigatorRoutes.teacherAssignedSection,
                currentPath: path))
      ],
    ),
  );
}

Widget bottomButton(BuildContext context,
    {required IconData iconData,
    required String label,
    required String thisPath,
    required String currentPath}) {
  return Column(
    children: [
      IconButton(
          onPressed: () => thisPath == currentPath || thisPath.isEmpty
              ? null
              : Navigator.of(context).pushNamed(thisPath),
          icon: Icon(iconData,
              color: thisPath == currentPath
                  ? Colors.white
                  : CustomColors.parchment)),
      interText(label,
          fontSize: 8,
          color:
              thisPath == currentPath ? Colors.white : CustomColors.parchment)
    ],
  );
}
