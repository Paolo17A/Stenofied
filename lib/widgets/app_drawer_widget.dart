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
                  label: 'PROFILE',
                  imagePath: ImagePaths.profile,
                  currentPath: currentPath,
                  thisPath: NavigatorRoutes.editProfile),
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
            ],
          ),
        ),
        _logOutButton(context)
      ],
    ),
  );
}

/*Widget _home(BuildContext context,
    {required String userType, required bool isHome}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: ListTile(
      leading: Image.asset(ImagePaths.home, scale: 20),
      title: whiteInterBold('HOME'),
      onTap: () {
        Navigator.of(context).pop();
        if (isHome) {
          return;
        }
        if (userType == UserTypes.admin) {
          Navigator.of(context).pushReplacementNamed(NavigatorRoutes.adminHome);
        } else if (userType == UserTypes.teacher) {
          Navigator.of(context)
              .pushReplacementNamed(NavigatorRoutes.teacherHome);
        } else if (userType == UserTypes.student) {
          Navigator.of(context)
              .pushReplacementNamed(NavigatorRoutes.studentHome);
        }
      },
    ),
  );
}

Widget _lessons(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: ListTile(
      leading: Image.asset(ImagePaths.lessons, scale: 20),
      title: whiteInterBold('LESSONS'),
      onTap: () {
        Navigator.of(context).pop();

        Navigator.of(context).pushNamed(NavigatorRoutes.studentLessons);
      },
    ),
  );
}

Widget _section(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: ListTile(
      leading: Image.asset(ImagePaths.section, scale: 20),
      title: whiteInterBold('SECTIONS'),
      onTap: () {
        Navigator.of(context).pop();

        Navigator.of(context).pushNamed(NavigatorRoutes.adminViewSections);
      },
    ),
  );
}

Widget _faq(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: ListTile(
      leading: Image.asset(ImagePaths.faqs, scale: 20),
      title: whiteInterBold('FAQs'),
      onTap: () {
        Navigator.of(context).pop();
      },
    ),
  );
}

Widget _profile(BuildContext context, {required String userType}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: ListTile(
      leading: const Icon(Icons.person, color: Colors.white),
      title: whiteInterBold('PROFILE'),
      onTap: () {
        Navigator.of(context).pop();

        if (userType == UserTypes.teacher) {
          Navigator.of(context).pushNamed(NavigatorRoutes.teacherProfile);
        } else if (userType == UserTypes.student) {
          Navigator.of(context).pushNamed(NavigatorRoutes.studentProfile);
        }
      },
    ),
  );
}*/

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
      title: Center(child: blackCinzelBold('LOG OUT')),
      onTap: () {
        FirebaseAuth.instance.signOut().then((value) {
          Navigator.popUntil(context, (route) => route.isFirst);
        });
      },
    ),
  );
}
