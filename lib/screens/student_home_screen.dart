import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/models/lesson_model.dart';
import 'package:stenofied/models/quiz_model.dart';
import 'package:stenofied/models/tracing_model.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/widgets/app_bottom_nav_bar_widget.dart';
import 'package:stenofied/widgets/custom_button_widgets.dart';

import '../providers/current_exercise_provider.dart';
import '../providers/current_quiz_provider.dart';
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
            label: ref.read(userDataProvider).lessonIndex >=
                    allLessonModels.length
                ? 'DONE WITH ALL LESSONS'
                : 'YOUR NEXT LESSON:\n\nLesson ${ref.read(userDataProvider).lessonIndex}',
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.9,
            color: CustomColors.ketchup,
            onPress: () =>
                ref.read(userDataProvider).lessonIndex >= allLessonModels.length
                    ? null
                    : NavigatorRoutes.studentSelectedLesson(context,
                        lessonModel: allLessonModels[
                            ref.read(userDataProvider).lessonIndex - 1])),
        Column(
          children: [
            homeButton(context,
                label: ref.read(userDataProvider).lessonIndex >=
                        allExerciseModels.length
                    ? 'NO EXERCISES LEFT TO TAKE'
                    : 'YOUR NEXT\nEXERCISE:\n\n${allExerciseModels[ref.read(userDataProvider).lessonIndex].exerciseDescription}',
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.width * 0.45 - 10,
                color: CustomColors.sangria, onPress: () {
              if (ref.read(userDataProvider).lessonIndex >=
                  allExerciseModels.length) return;
              Navigator.of(context).pushNamed(NavigatorRoutes.studentExercises);
              ref.read(currentExerciseProvider).resetExerciseProvider();
              ref.read(currentExerciseProvider).setExerciseModel(
                  allExerciseModels[
                      ref.read(userDataProvider).lessonIndex - 1]);
              Navigator.of(context)
                  .pushNamed(NavigatorRoutes.studentTakeExercise);
            }),
            Gap(20),
            homeButton(context,
                label: ref.read(userDataProvider).lessonIndex >=
                        allQuizModels.length
                    ? 'NO QUIZZES LEFT TO TAKE'
                    : 'YOUR NEXT QUIZ:\n\n${allQuizModels[ref.read(userDataProvider).lessonIndex].quizDescription}',
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.width * 0.45 - 10,
                color: CustomColors.blush,
                onPress: () => ref.read(userDataProvider).lessonIndex >=
                        allQuizModels.length
                    ? null
                    : () {
                        Navigator.of(context)
                            .pushNamed(NavigatorRoutes.studentQuizzes);
                        ref.read(currentQuizProvider).resetQuizProvider();
                        ref.read(currentQuizProvider).setQuizModel(
                            allQuizModels[
                                ref.read(userDataProvider).lessonIndex - 1]);
                        Navigator.of(context)
                            .pushNamed(NavigatorRoutes.studentTakeQuiz);
                      })
          ],
        ),
      ],
    );
  }
}
