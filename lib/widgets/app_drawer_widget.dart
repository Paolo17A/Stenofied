import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../providers/user_data_provider.dart';
import '../utils/color_util.dart';
import '../utils/navigator_util.dart';
import '../utils/string_util.dart';
import 'custom_miscellaneous_widgets.dart';
import 'custom_text_widgets.dart';

Drawer appDrawer(BuildContext context, WidgetRef ref,
    {required String userType,
    bool isHome = false,
    Color backgroundColor = CustomColors.ketchup}) {
  return Drawer(
    backgroundColor: backgroundColor,
    child: Column(
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                buildProfileImageWidget(
                    profileImageURL: ref.read(userDataProvider).profileImageURL,
                    radius: 52)
              ]),
              Gap(8),
            ],
          ),
          decoration: BoxDecoration(color: backgroundColor),
        ),
        Flexible(
          flex: 1,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Gap(20),
              _home(context, userType: userType, isHome: isHome),
              if (userType == UserTypes.student ||
                  userType == UserTypes.teacher)
                _profile(context, userType: userType),
            ],
          ),
        ),
        _logOutButton(context)
      ],
    ),
  );
}

Widget _home(BuildContext context,
    {required String userType, required bool isHome}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: ListTile(
      leading: const Icon(Icons.home, color: Colors.white),
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
}

Widget _logOutButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Container(
      decoration: BoxDecoration(
          color: CustomColors.ketchup,
          border: Border.all(color: CustomColors.sangria, width: 3),
          borderRadius: BorderRadius.circular(50)),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.white),
        title: Center(child: interText('LOG-OUT', color: Colors.white)),
        onTap: () {
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.popUntil(context, (route) => route.isFirst);
          });
        },
      ),
    ),
  );
}
