import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/providers/user_data_provider.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/widgets/app_bottom_nav_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';

import '../utils/string_util.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/app_drawer_widget.dart';

class TeacherHomeScreen extends ConsumerStatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  ConsumerState<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends ConsumerState<TeacherHomeScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(userDataProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: appBarWidget(mayGoBack: true),
          drawer: appDrawer(context, ref,
              userType: UserTypes.teacher, isHome: true),
          bottomNavigationBar:
              teacherBottomNavBar(context, path: NavigatorRoutes.teacherHome),
          body: Column(
            children: [
              welcomeWidgets(
                  userType: UserTypes.teacher,
                  profileImageURL: ref.read(userDataProvider).profileImageURL)
            ],
          )),
    );
  }
}
