import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:stenofied/providers/current_exercise_provider.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_field_widget.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

import '../../utils/color_util.dart';

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
  DateTime dateAnswered = DateTime.now();
  List<dynamic> exerciseResults = [];
  TextEditingController feedbackController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final exerciseResult =
            await ExercisesCollectionUtil.getExerciseResultDoc(
                widget.exerciseResultID);
        final exerciseResultData =
            exerciseResult.data() as Map<dynamic, dynamic>;
        exerciseResults =
            exerciseResultData[ExerciseResultFields.exerciseResults];
        dateAnswered =
            (exerciseResultData[ExerciseResultFields.dateAnswered] as Timestamp)
                .toDate();
        final student = await UsersCollectionUtil.getThisUserDoc(
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
  void dispose() {
    super.dispose();
    feedbackController.dispose();
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
                blackCinzelBold(formattedName, fontSize: 28),
                blackCinzelRegular(
                    '\t\tDate Answered: ${DateFormat('MMM dd, yyyy').format(dateAnswered)}',
                    fontSize: 22),
                blackCinzelRegular(
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
        child: whiteAndadaProBold(
            'Word $currentIndex/$totalWords: $currentWord',
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
    return Column(children: [
      whiteAndadaProBold(
          'Accuracy: ${((exerciseResults[currentIndex][EntryFields.accuracy] as num).toDouble() * 100).toStringAsFixed(2)}%',
          fontSize: 20),
      Slider(
          value: (exerciseResults[currentIndex][EntryFields.accuracy] as num)
              .toDouble(),
          thumbColor: Colors.white,
          activeColor: Colors.white,
          inactiveColor: Colors.white70,
          onChanged: ((value) {
            setState(() {
              exerciseResults[currentIndex][EntryFields.accuracy] = value;
            });
          })),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          whiteAndadaProBold('FEEDBACK (OPTIONAL):', fontSize: 16),
          CustomTextField(
              text: exerciseResults[currentIndex][EntryFields.feedback],
              controller: feedbackController,
              textInputType: TextInputType.text,
              displayPrefixIcon: null),
        ],
      )
    ]);
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
                : () {
                    exerciseResults[
                            ref.read(currentExerciseProvider).tracingIndex]
                        [EntryFields.feedback] = feedbackController.text;
                    ref.read(currentExerciseProvider).decrementTracingIndex();
                    setState(() {
                      feedbackController.text = exerciseResults[ref
                          .read(currentExerciseProvider)
                          .tracingIndex][EntryFields.feedback];
                    });
                  },
            style: ElevatedButton.styleFrom(
                disabledBackgroundColor: CustomColors.blush),
            child: whiteAndadaProBold('PREV')),
        SizedBox(
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  exerciseResults[
                          ref.read(currentExerciseProvider).tracingIndex]
                      [EntryFields.feedback] = feedbackController.text;
                });
                if (isLastQuestion) {
                  ExercisesCollectionUtil.gradeExerciseOutput(context, ref,
                      exerciseResultID: widget.exerciseResultID,
                      exerciseResults: exerciseResults);
                } else {
                  ref.read(currentExerciseProvider).incrementTracingIndex();
                  feedbackController.text = exerciseResults[ref
                      .read(currentExerciseProvider)
                      .tracingIndex][EntryFields.feedback];
                }
              },
              child: whiteAndadaProBold(isLastQuestion ? 'SUBMIT' : 'NEXT')),
        )
      ],
    );
  }
}
