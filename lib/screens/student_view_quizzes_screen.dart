import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/models/quiz_model.dart';
import 'package:stenofied/providers/current_exercise_provider.dart';
import 'package:stenofied/providers/current_quiz_provider.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/widgets/app_drawer_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/navigator_rail_widget.dart';

import '../providers/loading_provider.dart';
import '../providers/user_data_provider.dart';
import '../utils/color_util.dart';
import '../utils/future_util.dart';
import '../utils/string_util.dart';
import '../widgets/custom_text_widgets.dart';

class StudentQuizzesScreen extends ConsumerStatefulWidget {
  const StudentQuizzesScreen({super.key});

  @override
  ConsumerState<StudentQuizzesScreen> createState() =>
      _StudentQuizzesScreenState();
}

class _StudentQuizzesScreenState extends ConsumerState<StudentQuizzesScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<DocumentSnapshot> submittedQuizResults = [];

  bool hasSubmission(int index) {
    return submittedQuizResults.any((element) {
      final quizResultData = element.data() as Map<dynamic, dynamic>;
      return quizResultData[QuizResultFields.quizIndex] == index;
    });
  }

  String getCorrespondingQuizResult(int index) {
    return submittedQuizResults
        .where((element) {
          final quizResultData = element.data() as Map<dynamic, dynamic>;
          return quizResultData[QuizResultFields.quizIndex] == index;
        })
        .first
        .id;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final user = await getCurrentUserDoc();
        final userData = user.data() as Map<dynamic, dynamic>;
        ref
            .read(userDataProvider)
            .setLessonIndex(userData[UserFields.currentLessonIndex]);
        submittedQuizResults = await getUserQuizResultDocs();
        print(submittedQuizResults.map((e) => e.id).toList());
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error getting student lesson index: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(userDataProvider);
    ref.watch(currentExerciseProvider);
    return Scaffold(
      key: scaffoldKey,
      drawer: studentAppDrawer(context, ref,
          currentPath: NavigatorRoutes.studentQuizzes),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              studentRail(context, scaffoldKey,
                  selectedIndex: 3,
                  currentPath: NavigatorRoutes.studentQuizzes),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: SingleChildScrollView(
                  child: all20Pix(
                      child: Column(
                    children: [
                      blackCinzelBold('STENOGRAPHY QUIZZES', fontSize: 32),
                      Gap(40),
                      quizWidgets()
                    ],
                  )),
                ),
              ),
            ],
          )),
    );
  }

  Widget quizWidgets() {
    return Wrap(
        spacing: 20,
        runSpacing: 10,
        children: allQuizModels.map((quizModel) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 80,
            child: ElevatedButton(
                onPressed: quizModel.quizIndex <=
                        ref.read(userDataProvider).lessonIndex
                    ? () {
                        if (hasSubmission(quizModel.quizIndex)) {
                          NavigatorRoutes.selectedQuizResult(context,
                              quizResultID: getCorrespondingQuizResult(
                                  quizModel.quizIndex));
                        } else {
                          ref.read(currentQuizProvider).resetQuizProvider();
                          ref.read(currentQuizProvider).setQuizModel(quizModel);
                          Navigator.of(context)
                              .pushNamed(NavigatorRoutes.studentTakeQuiz);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    disabledBackgroundColor:
                        CustomColors.ketchup.withOpacity(0.5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    whiteAndadaProBold('Quiz ${quizModel.quizIndex}',
                        fontSize: 20),
                    whiteAndadaProRegular(quizModel.quizDescription,
                        fontSize: 16)
                  ],
                )),
          );
        }).toList());
  }
}
