import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';

import '../utils/color_util.dart';

Widget adminRail(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    {required int selectedIndex, required String currentPath}) {
  return GestureDetector(
    onTap: () {
      scaffoldKey.currentState!.openDrawer();
    },
    child: IntrinsicWidth(
      child: NavigationRail(
          backgroundColor: CustomColors.sangria,
          elevation: 1,
          minWidth: 50,
          extended: false,
          indicatorShape: RoundedRectangleBorder(),
          leading: Image.asset(ImagePaths.logo, scale: 10),
          trailing: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Image.asset(ImagePaths.logout, scale: 20), Gap(10)],
            ),
          ),
          destinations: [
            NavigationRailDestination(
                icon: Image.asset(ImagePaths.home, scale: 20),
                label: Container()),
            NavigationRailDestination(
                icon: Image.asset(ImagePaths.faqs, scale: 20),
                label: Container()),
          ],
          onDestinationSelected: (value) {
            if (value == currentPath) {
              return;
            }
            switch (value) {
              case 0:
                Navigator.of(context).pushNamed(NavigatorRoutes.adminHome);
                break;
              case 1:
                break;
            }
          },
          selectedIndex: selectedIndex),
    ),
  );
}

Widget teacherRail(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    {required int selectedIndex, required String currentPath}) {
  return GestureDetector(
    onTap: () {
      scaffoldKey.currentState!.openDrawer();
    },
    child: IntrinsicWidth(
      child: NavigationRail(
          backgroundColor: CustomColors.sangria,
          elevation: 1,
          minWidth: 50,
          extended: false,
          indicatorShape: RoundedRectangleBorder(),
          leading: Image.asset(ImagePaths.logo, scale: 10),
          trailing: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Image.asset(ImagePaths.logout, scale: 20), Gap(10)],
            ),
          ),
          destinations: [
            NavigationRailDestination(
                icon: Image.asset(ImagePaths.home, scale: 20),
                label: Container()),
            NavigationRailDestination(
                icon: Image.asset(ImagePaths.section, scale: 20),
                label: Container()),
            NavigationRailDestination(
                icon: Image.asset(ImagePaths.faqs, scale: 20),
                label: Container()),
            NavigationRailDestination(
                icon: Image.asset(ImagePaths.profile, scale: 20),
                label: Container()),
          ],
          onDestinationSelected: (value) {
            if (value == currentPath) {
              return;
            }
            switch (value) {
              case 0:
                Navigator.of(context).pushNamed(NavigatorRoutes.teacherHome);
                break;
              case 1:
                Navigator.of(context)
                    .pushNamed(NavigatorRoutes.teacherAssignedSection);
                break;
              case 2:
                break;
              case 3:
                Navigator.of(context).pushNamed(NavigatorRoutes.editProfile);
                break;
            }
          },
          selectedIndex: selectedIndex),
    ),
  );
}

Widget studentRail(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    {required int selectedIndex, required String currentPath}) {
  return GestureDetector(
    onTap: () {
      if (scaffoldKey.currentState == null) return;
      scaffoldKey.currentState!.openDrawer();
    },
    child: IntrinsicWidth(
      child: NavigationRail(
          backgroundColor: CustomColors.sangria,
          elevation: 1,
          minWidth: 50,
          extended: false,
          leading: Image.asset(ImagePaths.logo, scale: 10),
          indicatorShape: RoundedRectangleBorder(),
          trailing: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Image.asset(ImagePaths.logout, scale: 20), Gap(10)],
            ),
          ),
          destinations: [
            NavigationRailDestination(
                icon: vertical10Pix(
                    child: Image.asset(ImagePaths.home, scale: 20)),
                label: Container()),
            NavigationRailDestination(
                icon: vertical10Pix(
                    child: Image.asset(ImagePaths.lessons, scale: 20)),
                label: Container()),
            NavigationRailDestination(
                icon: vertical10Pix(
                    child: Image.asset(ImagePaths.exercises, scale: 20)),
                label: Container()),
            NavigationRailDestination(
                icon: vertical10Pix(
                    child: Image.asset(ImagePaths.quizzes, scale: 20)),
                label: Container()),
            NavigationRailDestination(
                icon: vertical10Pix(
                    child: Image.asset(ImagePaths.faqs, scale: 20)),
                label: Container()),
            NavigationRailDestination(
                icon: vertical10Pix(
                    child: Image.asset(ImagePaths.profile, scale: 20)),
                label: Container()),
          ],
          onDestinationSelected: (value) {
            if (value == selectedIndex) {
              return;
            }
            switch (value) {
              case 0:
                Navigator.of(context).pushNamed(NavigatorRoutes.studentHome);
                break;
              case 1:
                Navigator.of(context).pushNamed(NavigatorRoutes.studentLessons);
                break;
              case 2:
                Navigator.of(context)
                    .pushNamed(NavigatorRoutes.studentExercises);
                break;
              case 3:
                Navigator.of(context).pushNamed(NavigatorRoutes.studentQuizzes);
                break;
              case 4:
                break;
              case 5:
                Navigator.of(context).pushNamed(NavigatorRoutes.editProfile);
                break;
            }
          },
          selectedIndex: selectedIndex),
    ),
  );
}
