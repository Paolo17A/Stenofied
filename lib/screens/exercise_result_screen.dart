import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/models/tracing_model.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/providers/user_data_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/delete_entry_dialog_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

class ExerciseResultScreen extends ConsumerStatefulWidget {
  final String exerciseResultID;
  const ExerciseResultScreen({super.key, required this.exerciseResultID});

  @override
  ConsumerState<ExerciseResultScreen> createState() =>
      _ExerciseResultScreenState();
}

class _ExerciseResultScreenState extends ConsumerState<ExerciseResultScreen> {
  List<dynamic> exerciseResults = [];
  int exerciseIndex = 0;
  int score = 0;
  bool isGraded = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final exerciseResult =
            await getExerciseResultDoc(widget.exerciseResultID);
        print('done getting exercise results');
        final exerciseResultData =
            exerciseResult.data() as Map<dynamic, dynamic>;
        exerciseIndex = exerciseResultData[ExerciseResultFields.exerciseIndex];
        print('exercise index: $exerciseIndex');
        isGraded = exerciseResultData[ExerciseResultFields.isGraded];
        exerciseResults =
            exerciseResultData[ExerciseResultFields.exerciseResults];
        for (var result in exerciseResults) {
          if (result[EntryFields.isCorrect]) score++;
        }
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting exercise results: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(userDataProvider);
    print('Current loading state: ${ref.read(loadingProvider).isLoading}');
    return Scaffold(
      appBar: appBarWidget(
          mayGoBack: true,
          actions: ref.read(userDataProvider).userType == UserTypes.student &&
                  !ref.read(loadingProvider).isLoading
              ? [
                  TextButton(
                      onPressed: () {
                        displayDeleteEntryDialog(context,
                            message:
                                'Are you sure you wish to retake this exercise? Your current entry will be deleted.',
                            deleteWord: 'Retake',
                            deleteEntry: () => retakeThisExercise(context, ref,
                                exerciseResultID: widget.exerciseResultID,
                                exerciseIndex: exerciseIndex));
                      },
                      child: sangriaInterBold('RETAKE', fontSize: 16))
                ]
              : null),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SingleChildScrollView(
              child: Column(
            children: [
              all10Pix(
                  child:
                      blackInterBold('Exercise $exerciseIndex', fontSize: 32)),
              if (!ref.read(loadingProvider).isLoading) answersContainer()
            ],
          ))),
    );
  }

  Widget answersContainer() {
    return Container(
      decoration: BoxDecoration(
          color: CustomColors.ketchup, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          if (!isGraded)
            whiteInterBold('NOT YET GRADED', fontSize: 22)
          else if (exerciseIndex > 0)
            whiteInterBold(
                'Score: ${score}/${allExerciseModels[exerciseIndex - 1].tracingModels.length}',
                fontSize: 22),
          Divider(color: Colors.white),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: exerciseResults.length,
              itemBuilder: (context, index) {
                return vertical10Pix(
                    child: answerEntry(index, exerciseResults[index]));
              }),
        ],
      ),
    );
  }

  Widget answerEntry(int index, Map<dynamic, dynamic> answerData) {
    return Container(
      height: 80,
      decoration: BoxDecoration(color: CustomColors.blush),
      padding: EdgeInsets.all(4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          whiteInterBold('${index + 1}.', fontSize: 20),
          GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(border: Border.all()),
                                child: Image.network(
                                  answerData[EntryFields.imageURL],
                                  fit: BoxFit.fill,
                                )),
                            ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: whiteInterBold('CLOSE'))
                          ],
                        ),
                      ),
                    )),
            child: all10Pix(
              child: Image.network(
                answerData[EntryFields.imageURL],
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width * 0.3,
                //height: 90,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              whiteInterBold(
                  'Word/s: ${allExerciseModels[exerciseIndex - 1].tracingModels[index].word}',
                  fontSize: 16),
              if (isGraded)
                whiteInterBold(
                    'Result: ${answerData[EntryFields.isCorrect] ? 'CORRECT' : 'WRONG'}')
            ],
          )
        ],
      ),
    );
  }
}
