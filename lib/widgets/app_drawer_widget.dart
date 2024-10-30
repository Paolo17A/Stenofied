import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';

import '../utils/color_util.dart';
import '../utils/navigator_util.dart';
import '../utils/string_util.dart';
import 'custom_text_widgets.dart';

Drawer adminAppDrawer(BuildContext context, WidgetRef ref,
    {required String currentPath}) {
  return Drawer(
    backgroundColor: CustomColors.ketchup,
    shape: RoundedRectangleBorder(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        all10Pix(
            child: Row(
          children: [
            Image.asset(ImagePaths.logo, scale: 10),
            Gap(40),
            whiteCinzelBold('Stenofied', fontSize: 24)
          ],
        )),
        Flexible(
          flex: 1,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _drawerTile(context,
                  label: 'HOME',
                  imagePath: ImagePaths.home,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.adminHome),
              _drawerTile(context,
                  label: 'PROFILE',
                  imagePath: ImagePaths.profile,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.editProfile),
              _drawerTile(context,
                  label: 'FAQs',
                  imagePath: ImagePaths.faqs,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.adminFAQ),
            ],
          ),
        ),
        _logOutButton(context)
      ],
    ),
  );
}

Drawer studentAppDrawer(BuildContext context, WidgetRef ref,
    {required String currentPath}) {
  return Drawer(
    backgroundColor: CustomColors.ketchup,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        all10Pix(
            child: Row(
          children: [
            Image.asset(ImagePaths.logo, scale: 10),
            Gap(40),
            whiteCinzelBold('Stenofied', fontSize: 24)
          ],
        )),
        Flexible(
          flex: 1,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Gap(20),
              _drawerTile(context,
                  label: 'HOME',
                  imagePath: ImagePaths.home,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.studentHome),
              _drawerTile(context,
                  label: 'LESSONS',
                  imagePath: ImagePaths.lessons,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.studentLessons),
              _drawerTile(context,
                  label: 'EXERCISES',
                  imagePath: ImagePaths.exercises,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.studentExercises),
              _drawerTile(context,
                  label: 'QUIZZES',
                  imagePath: ImagePaths.quizzes,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.studentQuizzes),
              _drawerTile(context,
                  label: 'NOTES',
                  imagePath: ImagePaths.notes,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.studentNotes),
              _drawerTile(context,
                  label: 'TRANSLATOR',
                  imagePath: ImagePaths.translator,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.studentTranslate),
              _drawerTile(context,
                  label: 'PROFILE',
                  imagePath: ImagePaths.profile,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.editProfile),
              _drawerTile(context,
                  label: 'FAQ',
                  imagePath: ImagePaths.faqs,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.studentFAQ),
            ],
          ),
        ),
        _logOutButton(context)
      ],
    ),
  );
}

Drawer teacherAppDrawer(BuildContext context, WidgetRef ref,
    {required String currentPath}) {
  return Drawer(
    backgroundColor: CustomColors.ketchup,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        all10Pix(
            child: Row(
          children: [
            Image.asset(ImagePaths.logo, scale: 10),
            Gap(40),
            whiteCinzelBold('Stenofied', fontSize: 24)
          ],
        )),
        Flexible(
          flex: 1,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Gap(20),
              _drawerTile(context,
                  label: 'TEACHER',
                  imagePath: ImagePaths.home,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.teacherHome),
              _drawerTile(context,
                  label: 'MY SECTION',
                  imagePath: ImagePaths.section,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.teacherAssignedSection),
              _drawerTile(context,
                  label: 'PROFILE',
                  imagePath: ImagePaths.profile,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.editProfile),
              _drawerTile(context,
                  label: 'FAQ',
                  imagePath: ImagePaths.faqs,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.teacherFAQ),
            ],
          ),
        ),
        _logOutButton(context)
      ],
    ),
  );
}

Widget _drawerTile(BuildContext context,
    {required String label,
    required String imagePath,
    required String thisPath,
    required String currentPath}) {
  return ListTile(
    leading: Image.asset(imagePath, scale: 20),
    title: whiteCinzelBold(label, fontSize: 16),
    onTap: () {
      Navigator.of(context).pop();
      if (thisPath == currentPath || thisPath.isEmpty) return;
      Navigator.of(context).pushNamed(thisPath);
    },
  );
}

Widget _logOutButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: ListTile(
      leading: Image.asset(ImagePaths.logout, scale: 15),
      title: Center(child: whiteCinzelBold('LOG OUT')),
      onTap: () {
        FirebaseAuth.instance.signOut().then((value) {
          Navigator.popUntil(context, (route) => route.isFirst);
        });
      },
    ),
  );
}
