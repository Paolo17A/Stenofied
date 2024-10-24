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
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';
import 'package:stenofied/widgets/navigator_rail_widget.dart';

import '../../utils/string_util.dart';
import '../../widgets/app_drawer_widget.dart';

class TeacherHomeScreen extends ConsumerStatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  ConsumerState<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends ConsumerState<TeacherHomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
            await UsersCollectionUtil.getSectionStudentDocs(
                ref.read(userDataProvider).sectionID);
        final studentIDs = assignedStudents.map((e) => e.id).toList();
        ungradedExerciseDocs = await ExercisesCollectionUtil
            .getUngradedExerciseSubmissionsInSection(studentIDs);
        ungradedQuizDocs =
            await QuizzesCollectionUtil.getUngradedQuizSubmissionsInSection(
                studentIDs);
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
          key: scaffoldKey,
          drawer: teacherAppDrawer(context, ref,
              currentPath: NavigatorRoutes.teacherHome),
          body: switchedLoadingContainer(
              ref.read(loadingProvider).isLoading,
              safeAreaWithRail(context,
                  railWidget: teacherRail(context, scaffoldKey,
                      selectedIndex: 0,
                      currentPath: NavigatorRoutes.teacherHome),
                  mainWidget: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: vertical20Pix(
                        child: Column(
                          children: [
                            welcomeWidgets(context,
                                userType: UserTypes.teacher,
                                profileImageURL:
                                    ref.read(userDataProvider).profileImageURL),
                            all10Pix(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    exercisesToGrade(),
                                    quizzesToGrade()
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  )))),
    );
  }

  Widget gradablesTemplateWidget(BuildContext context,
      {required String title,
      required String unavailableLabel,
      required List<DocumentSnapshot> gradableDocs,
      required Widget ungradedDocsBuilder,
      required String imagePath}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
          color: CustomColors.ketchup, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: Column(children: [
        Image.asset(imagePath, height: 100),
        vertical10Pix(child: whiteAndadaProBold(title, fontSize: 16)),
        if (gradableDocs.isNotEmpty)
          if (gradableDocs.isNotEmpty)
            ungradedDocsBuilder
          else
            whiteAndadaProRegular(unavailableLabel)
      ]),
    );
  }

  Widget exercisesToGrade() {
    return gradablesTemplateWidget(context,
        title: 'Ungraded Exercises',
        unavailableLabel: 'No Exercises to Grade',
        gradableDocs: ungradedExerciseDocs,
        imagePath: ImagePaths.tropic,
        ungradedDocsBuilder: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: ungradedExerciseDocs.length,
            itemBuilder: (context, index) =>
                ungradedExerciseEntry(ungradedExerciseDocs[index])));
  }

  Widget quizzesToGrade() {
    return gradablesTemplateWidget(context,
        title: 'Ungraded Quizzes',
        unavailableLabel: 'No Quizzes to Grade',
        imagePath: ImagePaths.writing,
        gradableDocs: ungradedQuizDocs,
        ungradedDocsBuilder: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: ungradedQuizDocs.length,
            itemBuilder: (context, index) =>
                ungradedQuizEntry(ungradedQuizDocs[index])));
  }

  Widget ungradedDocTemplate(
      {required Function onPress,
      required String studentID,
      required String label}) {
    return InkWell(
      onTap: () => onPress(),
      highlightColor: CustomColors.sangria,
      child: Container(
        decoration: BoxDecoration(
            color: CustomColors.blush,
            border: Border.all(color: CustomColors.ketchup)),
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
            future: UsersCollectionUtil.getThisUserDoc(studentID),
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
                    whiteAndadaProBold(formattedName,
                        textAlign: TextAlign.left),
                    whiteAndadaProRegular(label, textAlign: TextAlign.left)
                  ]);
            }),
      ),
    );
  }

  Widget ungradedExerciseEntry(DocumentSnapshot exerciseResultDoc) {
    final exerciseResultData =
        exerciseResultDoc.data() as Map<dynamic, dynamic>;
    int exerciseIndex = exerciseResultData[ExerciseResultFields.exerciseIndex];
    String studentID = exerciseResultData[ExerciseResultFields.studentID];
    return ungradedDocTemplate(
        onPress: () {
          ref.read(currentExerciseProvider).resetExerciseProvider();
          ref.read(currentExerciseProvider).setExerciseModel(allExerciseModels
              .where((element) => element.exerciseIndex == exerciseIndex)
              .first);
          NavigatorRoutes.teacherGradeSelectedExercise(context,
              exerciseResultID: exerciseResultDoc.id);
        },
        studentID: studentID,
        label: 'Exercise ${exerciseIndex}');
  }

  Widget ungradedQuizEntry(DocumentSnapshot quizResultDoc) {
    final quizResultData = quizResultDoc.data() as Map<dynamic, dynamic>;
    int quizIndex = quizResultData[QuizResultFields.quizIndex];
    String studentID = quizResultData[QuizResultFields.studentID];
    return ungradedDocTemplate(
        onPress: () {
          ref.read(currentQuizProvider).resetQuizProvider();
          ref.read(currentQuizProvider).setQuizModel(allQuizModels
              .where((element) => element.quizIndex == quizIndex)
              .first);
          NavigatorRoutes.teacherGradeSelectedQuiz(context,
              quizResultID: quizResultDoc.id);
        },
        studentID: studentID,
        label: 'Quiz ${quizIndex}');
  }
}
