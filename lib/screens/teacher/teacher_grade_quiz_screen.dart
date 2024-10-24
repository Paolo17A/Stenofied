import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:stenofied/providers/current_quiz_provider.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

import '../../utils/color_util.dart';
import '../../widgets/custom_text_field_widget.dart';

class TeacherGradeQuizScreen extends ConsumerStatefulWidget {
  final String quizResultID;
  const TeacherGradeQuizScreen({super.key, required this.quizResultID});

  @override
  ConsumerState<TeacherGradeQuizScreen> createState() =>
      _TeacherGradeQuizScreenState();
}

class _TeacherGradeQuizScreenState
    extends ConsumerState<TeacherGradeQuizScreen> {
  String formattedName = '';
  DateTime dateAnswered = DateTime.now();
  List<dynamic> quizResults = [];
  String studentID = '';
  TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final quizResult =
            await QuizzesCollectionUtil.getQuizResultDoc(widget.quizResultID);
        final quizResultData = quizResult.data() as Map<dynamic, dynamic>;
        quizResults = quizResultData[QuizResultFields.quizResults];
        studentID = quizResultData[QuizResultFields.studentID];
        dateAnswered =
            (quizResultData[ExerciseResultFields.dateAnswered] as Timestamp)
                .toDate();
        final student = await UsersCollectionUtil.getThisUserDoc(studentID);
        final studentData = student.data() as Map<dynamic, dynamic>;
        formattedName =
            '${studentData[UserFields.firstName]} ${studentData[UserFields.lastName]}';
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting quiz content: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(currentQuizProvider);
    return Scaffold(
      appBar: appBarWidget(mayGoBack: true),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
                child: all20Pix(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                blackCinzelBold(formattedName, fontSize: 28),
                blackCinzelRegular(
                    '\t\tDate Answered: ${DateFormat('MMM dd, yyyy').format(dateAnswered)}',
                    fontSize: 22),
                blackCinzelRegular(
                    '\t\tQuiz ${ref.read(currentQuizProvider).currentQuizModel!.quizIndex.toString()}',
                    fontSize: 20),
                if (quizResults.isNotEmpty) _quizEntriesContainer(),
                Gap(50),
                _navigatorButtons()
              ],
            ))),
          )),
    );
  }

  Widget _currentWord() {
    String currentWord = ref
        .read(currentQuizProvider)
        .currentQuizModel!
        .wordsToWrite[ref.read(currentQuizProvider).questionIndex];
    int currentIndex = ref.read(currentQuizProvider).questionIndex + 1;
    int totalWords =
        ref.read(currentQuizProvider).currentQuizModel!.wordsToWrite.length;
    return vertical20Pix(
        child: whiteAndadaProBold(
            'Word $currentIndex/$totalWords: $currentWord',
            fontSize: 24));
  }

  Widget _quizEntriesContainer() {
    int currentIndex = ref.read(currentQuizProvider).questionIndex;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: CustomColors.ketchup, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _currentWord(),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(
                        quizResults[currentIndex][EntryFields.imageURL]))),
          ),
          _gradingButtons(),
        ],
      ),
    );
  }

  Widget _gradingButtons() {
    int currentIndex = ref.read(currentQuizProvider).questionIndex;
    return Column(children: [
      whiteAndadaProBold(
          'Accuracy: ${((quizResults[currentIndex][EntryFields.accuracy] as num).toDouble() * 100).toStringAsFixed(2)}%',
          fontSize: 20),
      Slider(
          value: (quizResults[currentIndex][EntryFields.accuracy] as num)
              .toDouble(),
          thumbColor: Colors.white,
          activeColor: Colors.white,
          inactiveColor: Colors.white70,
          onChanged: ((value) {
            setState(() {
              quizResults[currentIndex][EntryFields.accuracy] = value;
            });
          })),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          whiteAndadaProBold('FEEDBACK (OPTIONAL):', fontSize: 16),
          CustomTextField(
              text: quizResults[currentIndex][EntryFields.feedback],
              controller: feedbackController,
              textInputType: TextInputType.text,
              displayPrefixIcon: null),
        ],
      )
    ]);
  }

  Widget _navigatorButtons() {
    bool isLastQuestion = ref.read(currentQuizProvider).questionIndex ==
        ref.read(currentQuizProvider).currentQuizModel!.wordsToWrite.length - 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
            onPressed: ref.read(currentQuizProvider).questionIndex == 0
                ? null
                : () {
                    //  Save input to quizResults map
                    quizResults[ref.read(currentQuizProvider).questionIndex]
                        [EntryFields.feedback] = feedbackController.text;
                    //  Decrement quiz Index
                    ref.read(currentQuizProvider).decrementQuizIndex();
                    //  DIsplay feedback of previous map
                    setState(() {
                      feedbackController.text = quizResults[ref
                          .read(currentQuizProvider)
                          .questionIndex][EntryFields.feedback];
                    });
                  },
            style: ElevatedButton.styleFrom(
                disabledBackgroundColor: CustomColors.blush),
            child: whiteAndadaProBold('PREV')),
        SizedBox(
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  quizResults[ref.read(currentQuizProvider).questionIndex]
                      [EntryFields.feedback] = feedbackController.text;
                });
                if (isLastQuestion) {
                  QuizzesCollectionUtil.gradeQuizOutput(context, ref,
                      studentID: studentID,
                      quizResultID: widget.quizResultID,
                      quizResults: quizResults);
                } else {
                  ref.read(currentQuizProvider).incrementQuizIndex();
                  feedbackController.text =
                      quizResults[ref.read(currentQuizProvider).questionIndex]
                          [EntryFields.feedback];
                }
              },
              child: whiteAndadaProBold(isLastQuestion ? 'SUBMIT' : 'NEXT')),
        )
      ],
    );
  }
}
