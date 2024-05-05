import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/models/quiz_model.dart';
import 'package:stenofied/models/tracing_model.dart';
import 'package:stenofied/providers/current_exercise_provider.dart';
import 'package:stenofied/providers/current_quiz_provider.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/providers/user_data_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/widgets/app_bottom_nav_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

import '../utils/string_util.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/app_drawer_widget.dart';

class TeacherHomeScreen extends ConsumerStatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  ConsumerState<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends ConsumerState<TeacherHomeScreen> {
  List<DocumentSnapshot> ungradedExerciseDocs = [];
  List<DocumentSnapshot> ungradedQuizDocs = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        List<DocumentSnapshot> assignedStudents =
            await getSectionStudentDocs(ref.read(userDataProvider).sectionID);
        final studentIDs = assignedStudents.map((e) => e.id).toList();
        ungradedExerciseDocs =
            await getUngradedExerciseSubmissionsInSection(studentIDs);
        ungradedQuizDocs =
            await getUngradedQuizSubmissionsInSection(studentIDs);
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(SnackBar(
            content:
                Text('Error initializing teacher dashboard screen: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(userDataProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: appBarWidget(mayGoBack: true),
          drawer: appDrawer(context, ref,
              userType: UserTypes.teacher, isHome: true),
          bottomNavigationBar:
              teacherBottomNavBar(context, path: NavigatorRoutes.teacherHome),
          body: switchedLoadingContainer(
            ref.read(loadingProvider).isLoading,
            vertical20Pix(
              child: Column(
                children: [
                  welcomeWidgets(
                      userType: UserTypes.teacher,
                      profileImageURL:
                          ref.read(userDataProvider).profileImageURL),
                  exercisesToGrade(),
                  quizzesToGrade()
                ],
              ),
            ),
          )),
    );
  }

  Widget exercisesToGrade() {
    return all20Pix(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: CustomColors.ketchup,
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            whiteInterBold('Ungraded Exercises', fontSize: 24),
            if (ungradedExerciseDocs.isNotEmpty)
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: ungradedExerciseDocs.length,
                  itemBuilder: (context, index) =>
                      ungradedExerciseEntry(ungradedExerciseDocs[index]))
            else
              whiteInterRegular('No Exercises to Grade')
          ],
        ),
      ),
    );
  }

  Widget ungradedExerciseEntry(DocumentSnapshot exerciseResultDoc) {
    final exerciseResultData =
        exerciseResultDoc.data() as Map<dynamic, dynamic>;
    int exerciseIndex = exerciseResultData[ExerciseResultFields.exerciseIndex];
    String studentID = exerciseResultData[ExerciseResultFields.studentID];
    return InkWell(
      onTap: () {
        ref.read(currentExerciseProvider).resetExerciseProvider();
        ref.read(currentExerciseProvider).setExerciseModel(allExerciseModels
            .where((element) => element.exerciseIndex == exerciseIndex)
            .first);
        NavigatorRoutes.teacherGradeSelectedExercise(context,
            exerciseResultID: exerciseResultDoc.id);
      },
      highlightColor: CustomColors.sangria,
      child: Container(
        decoration: BoxDecoration(
            color: CustomColors.blush,
            border: Border.all(color: CustomColors.ketchup)),
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
            future: getThisUserDoc(studentID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData ||
                  snapshot.hasError) return snapshotHandler(snapshot);
              final userData = snapshot.data!.data() as Map<dynamic, dynamic>;
              String formattedName =
                  '${userData[UserFields.firstName]} ${userData[UserFields.lastName]}';
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    whiteInterBold('Student: $formattedName'),
                    whiteInterRegular('Exercise ${exerciseIndex}')
                  ]);
            }),
      ),
    );
  }

  Widget quizzesToGrade() {
    return all20Pix(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: CustomColors.ketchup,
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            whiteInterBold('Ungraded Quizzes', fontSize: 24),
            if (ungradedQuizDocs.isNotEmpty)
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: ungradedQuizDocs.length,
                  itemBuilder: (context, index) =>
                      ungradedQuizEntry(ungradedQuizDocs[index]))
            else
              whiteInterRegular('No Quizzes to Grade')
          ],
        ),
      ),
    );
  }

  Widget ungradedQuizEntry(DocumentSnapshot quizResultDoc) {
    final quizResultData = quizResultDoc.data() as Map<dynamic, dynamic>;
    int quizIndex = quizResultData[QuizResultFields.quizIndex];
    String studentID = quizResultData[QuizResultFields.studentID];
    return InkWell(
      onTap: () {
        ref.read(currentQuizProvider).resetQuizProvider();
        ref.read(currentQuizProvider).setQuizModel(allQuizModels
            .where((element) => element.quizIndex == quizIndex)
            .first);
        NavigatorRoutes.teacherGradeSelectedQuiz(context,
            quizResultID: quizResultDoc.id);
      },
      highlightColor: CustomColors.sangria,
      child: Container(
        decoration: BoxDecoration(
            color: CustomColors.blush,
            border: Border.all(color: CustomColors.ketchup)),
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
            future: getThisUserDoc(studentID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData ||
                  snapshot.hasError) return snapshotHandler(snapshot);
              final userData = snapshot.data!.data() as Map<dynamic, dynamic>;
              String formattedName =
                  '${userData[UserFields.firstName]} ${userData[UserFields.lastName]}';
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    whiteInterBold('Student: $formattedName'),
                    whiteInterRegular('Quiz ${quizIndex}')
                  ]);
            }),
      ),
    );
  }
}
