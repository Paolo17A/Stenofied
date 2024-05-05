import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/models/lesson_model.dart';
import 'package:stenofied/models/quiz_model.dart';
import 'package:stenofied/models/tracing_model.dart';
import 'package:stenofied/providers/loading_provider.dart';
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
  String latestExerciseResultID = '';
  String latestQuizResultID = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final latestExerciseDocs = await FirebaseFirestore.instance
            .collection(Collections.exerciseResults)
            .where(ExerciseResultFields.studentID,
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where(ExerciseResultFields.exerciseIndex,
                isEqualTo: ref.read(userDataProvider).lessonIndex)
            .get();
        if (latestExerciseDocs.docs.isNotEmpty) {
          latestExerciseResultID = latestExerciseDocs.docs.first.id;
        }

        final latestQuizDocs = await FirebaseFirestore.instance
            .collection(Collections.quizResults)
            .where(QuizResultFields.studentID,
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where(QuizResultFields.quizIndex,
                isEqualTo: ref.read(userDataProvider).lessonIndex)
            .get();

        if (latestQuizDocs.docs.isNotEmpty) {
          latestQuizResultID = latestQuizDocs.docs.first.id;
        }
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error initializing student home screen: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(userDataProvider);
    ref.watch(loadingProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: appBarWidget(mayGoBack: true),
          bottomNavigationBar:
              studentBottomNavBar(context, path: NavigatorRoutes.studentHome),
          drawer: appDrawer(context, ref,
              userType: UserTypes.student, isHome: true),
          body: SingleChildScrollView(
            child: Column(
              children: [
                welcomeWidgets(
                    userType: ref.read(userDataProvider).userType,
                    profileImageURL:
                        ref.read(userDataProvider).profileImageURL),
                Gap(40),
                _homeButtons()
              ],
            ),
          )),
    );
  }

  Widget _homeButtons() {
    return Column(
      children: [
        homeButton(context,
            label: ref.read(userDataProvider).lessonIndex >=
                    allLessonModels.length
                ? 'DONE WITH ALL LESSONS'
                : 'YOUR CURRENT LESSON:\n\nLesson ${ref.read(userDataProvider).lessonIndex}',
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.35 - 10,
            color: CustomColors.ketchup,
            onPress: () =>
                ref.read(userDataProvider).lessonIndex >= allLessonModels.length
                    ? null
                    : NavigatorRoutes.studentSelectedLesson(context,
                        lessonModel: allLessonModels[
                            ref.read(userDataProvider).lessonIndex - 1])),
        Gap(20),
        homeButton(context,
            label: ref.read(userDataProvider).lessonIndex >=
                    allExerciseModels.length
                ? 'NO EXERCISES LEFT TO TAKE'
                : 'YOUR CURRENT\nEXERCISE:\n\n${allExerciseModels[ref.read(userDataProvider).lessonIndex - 1].exerciseDescription}',
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.35,
            color: CustomColors.sangria, onPress: () {
          if (ref.read(userDataProvider).lessonIndex >=
              allExerciseModels.length) return;
          if (latestExerciseResultID.isNotEmpty) {
            NavigatorRoutes.selectedExerciseResult(context,
                exerciseResultID: latestExerciseResultID);
          } else {
            Navigator.of(context).pushNamed(NavigatorRoutes.studentExercises);
            ref.read(currentExerciseProvider).resetExerciseProvider();
            ref.read(currentExerciseProvider).setExerciseModel(
                allExerciseModels[ref.read(userDataProvider).lessonIndex - 1]);
            Navigator.of(context)
                .pushNamed(NavigatorRoutes.studentTakeExercise);
          }
        }),
        Gap(20),
        homeButton(context,
            label: ref.read(userDataProvider).lessonIndex >=
                    allQuizModels.length
                ? 'NO QUIZZES LEFT TO TAKE'
                : 'YOUR CURRENT QUIZ:\n\n${allQuizModels[ref.read(userDataProvider).lessonIndex - 1].quizDescription}',
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.35,
            color: CustomColors.blush, onPress: () {
          if (ref.read(userDataProvider).lessonIndex >= allQuizModels.length)
            return;
          if (latestQuizResultID.isNotEmpty) {
            NavigatorRoutes.selectedQuizResult(context,
                quizResultID: latestQuizResultID);
          } else {
            Navigator.of(context).pushNamed(NavigatorRoutes.studentQuizzes);
            ref.read(currentQuizProvider).resetQuizProvider();
            ref.read(currentQuizProvider).setQuizModel(
                allQuizModels[ref.read(userDataProvider).lessonIndex - 1]);
            Navigator.of(context).pushNamed(NavigatorRoutes.studentTakeQuiz);
          }
        })
      ],
    );
  }
}
