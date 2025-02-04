import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/models/tracing_model.dart';
import 'package:stenofied/providers/current_exercise_provider.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/widgets/app_drawer_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/navigator_rail_widget.dart';

import '../../providers/loading_provider.dart';
import '../../providers/user_data_provider.dart';
import '../../utils/color_util.dart';
import '../../utils/future_util.dart';
import '../../utils/string_util.dart';
import '../../widgets/custom_text_widgets.dart';

class StudentExercisesScreen extends ConsumerStatefulWidget {
  const StudentExercisesScreen({super.key});

  @override
  ConsumerState<StudentExercisesScreen> createState() =>
      _StudentExercisesScreenState();
}

class _StudentExercisesScreenState
    extends ConsumerState<StudentExercisesScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<DocumentSnapshot> submittedExerciseResults = [];

  bool hasSubmission(int index) {
    return submittedExerciseResults.any((element) {
      final exerciseResultData = element.data() as Map<dynamic, dynamic>;
      return exerciseResultData[ExerciseResultFields.exerciseIndex] == index;
    });
  }

  String getCorrespondingExerciseResult(int index) {
    return submittedExerciseResults
        .where((element) {
          final exerciseResultData = element.data() as Map<dynamic, dynamic>;
          return exerciseResultData[ExerciseResultFields.exerciseIndex] ==
              index;
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
        final user = await UsersCollectionUtil.getCurrentUserDoc();
        final userData = user.data() as Map<dynamic, dynamic>;
        ref
            .read(userDataProvider)
            .setLessonIndex(userData[UserFields.currentLessonIndex]);
        submittedExerciseResults =
            await ExercisesCollectionUtil.getUserExerciseResultDocs();
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
          currentPath: NavigatorRoutes.studentExercises),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              studentRail(context, scaffoldKey,
                  selectedIndex: 2,
                  currentPath: NavigatorRoutes.studentExercises),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: SingleChildScrollView(
                  child: all20Pix(
                      child: Column(
                    children: [
                      blackCinzelBold('TRACING EXERCISES', fontSize: 32),
                      Gap(40),
                      exerciseWidgets()
                    ],
                  )),
                ),
              ),
            ],
          )),
    );
  }

  Widget exerciseWidgets() {
    return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: allExerciseModels.map((exercise) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.width * 0.2,
            child: ElevatedButton(
                onPressed: exercise.exerciseIndex <=
                        ref.read(userDataProvider).lessonIndex
                    ? () => hasSubmission(exercise.exerciseIndex)
                        ? NavigatorRoutes.selectedExerciseResult(context,
                            exerciseResultID: getCorrespondingExerciseResult(
                                exercise.exerciseIndex))
                        : showDescriptionDialog(exercise)
                    : null,
                style: ElevatedButton.styleFrom(
                    disabledBackgroundColor:
                        CustomColors.ketchup.withOpacity(0.5)),
                child: whiteAndadaProBold('Exercise ${exercise.exerciseIndex}',
                    fontSize: 16)),
          );
        }).toList());
  }

  void showDescriptionDialog(ExerciseModel exerciseModel) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: CustomColors.blush,
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    whiteAndadaProBold('Exercise Contents', fontSize: 28),
                    vertical20Pix(
                        child: whiteAndadaProRegular(
                            exerciseModel.exerciseDescription,
                            fontSize: 20)),
                    Gap(40),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ref
                              .read(currentExerciseProvider)
                              .resetExerciseProvider();
                          ref
                              .read(currentExerciseProvider)
                              .setExerciseModel(exerciseModel);
                          Navigator.of(context)
                              .pushNamed(NavigatorRoutes.studentTakeExercise);
                        },
                        child: whiteAndadaProBold('START EXERCISE'))
                  ],
                ),
              ),
            ));
  }
}
