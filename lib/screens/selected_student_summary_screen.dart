import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

import '../utils/color_util.dart';

class SelectedStudentSummaryScreen extends ConsumerStatefulWidget {
  final String studentID;
  const SelectedStudentSummaryScreen({super.key, required this.studentID});

  @override
  ConsumerState<SelectedStudentSummaryScreen> createState() =>
      _SelectedStudentSummaryScreenState();
}

class _SelectedStudentSummaryScreenState
    extends ConsumerState<SelectedStudentSummaryScreen> {
  String formattedName = '';
  String profileImageURL = '';

  int currentQuizIndex = 1;
  List<DocumentSnapshot> exerciseResultDocs = [];
  List<DocumentSnapshot> quizResultDocs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);

        //  Get student data
        final userDoc =
            await UsersCollectionUtil.getThisUserDoc(widget.studentID);
        final userData = userDoc.data() as Map<dynamic, dynamic>;
        formattedName =
            '${userData[UserFields.firstName]} ${userData[UserFields.lastName]}';
        profileImageURL = userData[UserFields.profileImageURL];
        currentQuizIndex = userData[UserFields.currentLessonIndex];

        //  Get student results
        exerciseResultDocs =
            await ExercisesCollectionUtil.getStudentExerciseResultDocs(
                widget.studentID);
        exerciseResultDocs = exerciseResultDocs.where((element) {
          final exerciseResultData = element.data() as Map<dynamic, dynamic>;
          return exerciseResultData[ExerciseResultFields.isGraded];
        }).toList();
        exerciseResultDocs.sort((a, b) {
          final aMap = a.data() as Map<dynamic, dynamic>;
          int aIndex = aMap[ExerciseResultFields.exerciseIndex];
          final bMap = b.data() as Map<dynamic, dynamic>;
          int bIndex = bMap[ExerciseResultFields.exerciseIndex];

          return aIndex.compareTo(bIndex);
        });
        quizResultDocs = await QuizzesCollectionUtil.getStudentQuizResultDocs(
            widget.studentID);
        quizResultDocs = quizResultDocs.where((element) {
          final quizResultData = element.data() as Map<dynamic, dynamic>;
          return quizResultData[QuizResultFields.isGraded];
        }).toList();
        quizResultDocs.sort((a, b) {
          final aMap = a.data() as Map<dynamic, dynamic>;
          int aIndex = aMap[QuizResultFields.quizIndex];
          final bMap = b.data() as Map<dynamic, dynamic>;
          int bIndex = bMap[QuizResultFields.quizIndex];

          return aIndex.compareTo(bIndex);
        });
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text('Error getting selected student summary: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      appBar: appBarWidget(mayGoBack: true),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SingleChildScrollView(
            child: all20Pix(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerWidgets(),
                  Divider(color: CustomColors.ketchup),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_exerciseResults(), _quizResults()])
                ],
              ),
            ),
          )),
    );
  }

  Widget _headerWidgets() {
    return all10Pix(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(12),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            all10Pix(
                child: buildProfileImageWidget(
                    profileImageURL: profileImageURL,
                    radius: MediaQuery.of(context).size.width * 0.2)),
            blackCinzelBold(formattedName, fontSize: 26),
            blackCinzelRegular('Current Level: $currentQuizIndex')
          ],
        ),
      ),
    );
  }

  Widget _exerciseResults() {
    return vertical20Pix(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: CustomColors.ketchup),
      padding: EdgeInsets.all(12),
      child: Column(children: [
        Image.asset(ImagePaths.tropic, height: 100, fit: BoxFit.fill),
        Gap(12),
        whiteAndadaProBold('EXERCISE RESULTS', fontSize: 16),
        exerciseResultDocs.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return exerciseResultEntry(exerciseResultDocs[index]);
                },
                itemCount: exerciseResultDocs.length)
            : vertical20Pix(
                child: whiteAndadaProBold('NO EXERCISE RESULTS AVAILABLE',
                    fontSize: 20))
      ]),
    ));
  }

  Widget _quizResults() {
    return vertical20Pix(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: CustomColors.ketchup),
      padding: EdgeInsets.all(12),
      child: Column(children: [
        Image.asset(ImagePaths.writing, height: 100, fit: BoxFit.fill),
        Gap(12),
        whiteAndadaProBold('QUIZ RESULTS', fontSize: 16),
        quizResultDocs.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return quizResultEntry(quizResultDocs[index]);
                },
                itemCount: quizResultDocs.length)
            : vertical20Pix(
                child: whiteAndadaProBold('NO EXERCISE RESULTS AVAILABLE',
                    fontSize: 20))
      ]),
    ));
  }

  Widget exerciseResultEntry(DocumentSnapshot exerciseResultDoc) {
    final exerciseResultData =
        exerciseResultDoc.data() as Map<dynamic, dynamic>;
    int exerciseIndex = exerciseResultData[ExerciseResultFields.exerciseIndex];
    List<dynamic> exerciseResults =
        exerciseResultData[ExerciseResultFields.exerciseResults];
    num totalAccuracy = 0;
    num averageAccuracy = 0;
    for (var result in exerciseResults) {
      totalAccuracy += result[EntryFields.accuracy];
    }
    averageAccuracy = totalAccuracy / exerciseResults.length;
    return InkWell(
      onTap: () => NavigatorRoutes.selectedExerciseResult(context,
          exerciseResultID: exerciseResultDoc.id),
      child: vertical10Pix(
        child: Container(
          color: CustomColors.blush,
          padding: EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whiteAndadaProBold('Exercise: $exerciseIndex'),
              whiteAndadaProRegular(
                  'Average Accuracy:${(averageAccuracy * 100).toStringAsFixed(2)}%',
                  textAlign: TextAlign.left,
                  fontSize: 12)
            ],
          ),
        ),
      ),
    );
  }

  Widget quizResultEntry(DocumentSnapshot quizResultDoc) {
    final quizResultData = quizResultDoc.data() as Map<dynamic, dynamic>;
    int quizIndex = quizResultData[QuizResultFields.quizIndex];
    List<dynamic> quizResults = quizResultData[QuizResultFields.quizResults];
    num totalAccuracy = 0;
    num averageAccuracy = 0;
    for (var result in quizResults) {
      totalAccuracy += result[EntryFields.accuracy];
    }
    averageAccuracy == totalAccuracy / quizResults.length;
    return InkWell(
      onTap: () => NavigatorRoutes.selectedQuizResult(context,
          quizResultID: quizResultDoc.id),
      child: vertical10Pix(
        child: Container(
          color: CustomColors.blush,
          padding: EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whiteAndadaProBold('Quiz: $quizIndex'),
              whiteAndadaProRegular(
                  'Average Accuracy: ${(averageAccuracy * 100).toStringAsFixed(2)}%',
                  textAlign: TextAlign.left,
                  fontSize: 12)
            ],
          ),
        ),
      ),
    );
  }
}
