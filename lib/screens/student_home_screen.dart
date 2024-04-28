import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/widgets/app_bottom_nav_bar_widget.dart';
import 'package:stenofied/widgets/custom_button_widgets.dart';

import '../providers/user_data_provider.dart';
import '../utils/color_util.dart';
import '../utils/string_util.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/custom_miscellaneous_widgets.dart';

class StudentHomeScreen extends ConsumerStatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  ConsumerState<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends ConsumerState<StudentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(userDataProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: appBarWidget(mayGoBack: true),
          bottomNavigationBar:
              studentBottomNavBar(context, path: NavigatorRoutes.studentHome),
          drawer: appDrawer(context, ref,
              userType: UserTypes.student, isHome: true),
          body: Column(
            children: [
              welcomeWidgets(
                  userType: ref.read(userDataProvider).userType,
                  profileImageURL: ref.read(userDataProvider).profileImageURL),
              Gap(40),
              _homeButtons()
            ],
          )),
    );
  }

  Widget _homeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        homeButton(context,
            label: 'STUDY YOUR NEXT LESSON',
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.8,
            color: CustomColors.ketchup,
            onPress: () => Navigator.of(context)
                .pushNamed(NavigatorRoutes.studentLessons)),
        Column(
          children: [
            homeButton(context,
                label: 'PRACTICE TRACING',
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4 - 10,
                color: CustomColors.sangria,
                onPress: () {}),
            Gap(20),
            homeButton(context,
                label: 'TAKE YOUR NEXT QUIZ',
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4 - 10,
                color: CustomColors.blush,
                onPress: () {})
          ],
        ),
      ],
    );
  }
}
