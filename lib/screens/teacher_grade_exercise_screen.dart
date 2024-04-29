import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/providers/current_exercise_provider.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/bool_answer_button.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

import '../utils/color_util.dart';

class TeacherGradeExerciseScreen extends ConsumerStatefulWidget {
  final String exerciseResultID;
  const TeacherGradeExerciseScreen({super.key, required this.exerciseResultID});

  @override
  ConsumerState<TeacherGradeExerciseScreen> createState() =>
      _TeacherGradeExerciseScreenState();
}

class _TeacherGradeExerciseScreenState
    extends ConsumerState<TeacherGradeExerciseScreen> {
  String formattedName = '';
  List<dynamic> exerciseResults = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final exerciseResult =
            await getExerciseResultDoc(widget.exerciseResultID);
        final exerciseResultData =
            exerciseResult.data() as Map<dynamic, dynamic>;
        exerciseResults =
            exerciseResultData[ExerciseResultFields.exerciseResults];
        final student = await getThisUserDoc(
            exerciseResultData[ExerciseResultFields.studentID]);
        final studentData = student.data() as Map<dynamic, dynamic>;
        formattedName =
            '${studentData[UserFields.firstName]} ${studentData[UserFields.lastName]}';
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting exercise content: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(currentExerciseProvider);
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
                blackInterBold(formattedName, fontSize: 28),
                blackInterRegular(
                    '\t\tExercise ${ref.read(currentExerciseProvider).currentExerciseModel!.exerciseIndex.toString()}',
                    fontSize: 20),
                if (exerciseResults.isNotEmpty) _exerciseEntriesContainer(),
                Gap(50),
                _navigatorButtons()
              ],
            ))),
          )),
    );
  }

  Widget _currentWord() {
    String currentWord = ref
        .read(currentExerciseProvider)
        .currentExerciseModel!
        .tracingModels[ref.read(currentExerciseProvider).tracingIndex]
        .word;
    int currentIndex = ref.read(currentExerciseProvider).tracingIndex + 1;
    int totalWords = ref
        .read(currentExerciseProvider)
        .currentExerciseModel!
        .tracingModels
        .length;
    return vertical20Pix(
        child: whiteInterBold('Word $currentIndex/$totalWords: $currentWord',
            fontSize: 24));
  }

  Widget _exerciseEntriesContainer() {
    int currentIndex = ref.read(currentExerciseProvider).tracingIndex;
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
                        exerciseResults[currentIndex][EntryFields.imageURL]))),
          ),
          _gradingButtons(),
        ],
      ),
    );
  }

  Widget _gradingButtons() {
    int currentIndex = ref.read(currentExerciseProvider).tracingIndex;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BoolAnswerButton(
            boolVal: true,
            answer: 'CORRECT',
            onTap: () {
              setState(() {
                exerciseResults[currentIndex][EntryFields.isCorrect] = true;
              });
            },
            isSelected:
                exerciseResults[currentIndex][EntryFields.isCorrect] == true),
        BoolAnswerButton(
            boolVal: false,
            answer: 'WRONG',
            onTap: () {
              setState(() {
                exerciseResults[currentIndex][EntryFields.isCorrect] = false;
              });
            },
            isSelected:
                exerciseResults[currentIndex][EntryFields.isCorrect] == false)
      ],
    );
  }

  Widget _navigatorButtons() {
    bool isLastQuestion = ref.read(currentExerciseProvider).tracingIndex ==
        ref
                .read(currentExerciseProvider)
                .currentExerciseModel!
                .tracingModels
                .length -
            1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
            onPressed: ref.read(currentExerciseProvider).tracingIndex == 0
                ? null
                : () =>
                    ref.read(currentExerciseProvider).decrementTracingIndex(),
            style: ElevatedButton.styleFrom(
                disabledBackgroundColor: CustomColors.blush),
            child: whiteInterBold('PREV')),
        SizedBox(
          child: ElevatedButton(
              onPressed: () => isLastQuestion
                  ? gradeExerciseOutput(context, ref,
                      exerciseResultID: widget.exerciseResultID,
                      exerciseResults: exerciseResults)
                  : ref.read(currentExerciseProvider).incrementTracingIndex(),
              child: whiteInterBold(isLastQuestion ? 'SUBMIT' : 'NEXT')),
        )
      ],
    );
  }
}
