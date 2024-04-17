import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/models/lesson_model.dart';
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
                  profileImageURL: ref.read(userDataProvider).profileImageURL,
                  containerColor: CustomColors.turquoise),
              Gap(40),
              if (ref.read(userDataProvider).lessonIndex <
                  allLessonModels.length)
                studentHomeButton(context,
                    label: 'STUDY YOUR\nNEXT LESSON',
                    onPress: () => NavigatorRoutes.studentSelectedLesson(
                        context,
                        lessonModel: allLessonModels[
                            ref.read(userDataProvider).lessonIndex - 1])),
              studentHomeButton(context,
                  label: 'PRACTICE TRACING', onPress: () {}),
              studentHomeButton(context,
                  label: 'TAKE THE NEXT QUIZ', onPress: () {})
            ],
          )),
    );
  }
}
