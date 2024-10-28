import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stenofied/models/quiz_model.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/providers/user_data_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

class QuizResultScreen extends ConsumerStatefulWidget {
  final String quizResultID;
  const QuizResultScreen({super.key, required this.quizResultID});

  @override
  ConsumerState<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen> {
  List<dynamic> quizResults = [];
  int quizIndex = 0;
  num averageAccuracy = 0;
  bool isGraded = false;
  Duration elapsedTime = Duration();
  DateTime dateAnswered = DateTime.now();

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
        quizIndex = quizResultData[QuizResultFields.quizIndex];
        isGraded = quizResultData[QuizResultFields.isGraded];
        quizResults = quizResultData[QuizResultFields.quizResults];
        num totalAccuracy = 0;
        for (var result in quizResults) {
          totalAccuracy += result[EntryFields.accuracy];
        }
        averageAccuracy = totalAccuracy / quizResults.length;
        elapsedTime = Duration(minutes: 15) -
            Duration(
                hours: quizResultData[QuizResultFields.elapsedTime]['hours'],
                minutes: quizResultData[QuizResultFields.elapsedTime]
                    ['minutes'],
                seconds: quizResultData[QuizResultFields.elapsedTime]
                    ['seconds']);
        dateAnswered =
            (quizResultData[QuizResultFields.dateAnswered] as Timestamp)
                .toDate();
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting quiz results: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(userDataProvider);
    return Scaffold(
      appBar: appBarWidget(mayGoBack: true),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SingleChildScrollView(
              child: Column(
            children: [
              all10Pix(child: blackCinzelBold('Quiz $quizIndex', fontSize: 32)),
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
            whiteAndadaProBold('NOT YET GRADED', fontSize: 22)
          else if (quizIndex > 0)
            whiteAndadaProRegular(
                'Average Accuracy: ${(averageAccuracy * 100).toStringAsFixed(2)}%',
                fontSize: 22),
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              whiteAndadaProRegular(
                  'Date Answered: ${DateFormat('MMM dd, yyyy').format(dateAnswered)}',
                  fontSize: 16),
              whiteAndadaProRegular(
                  'Elapsed Time: ${elapsedTime.inMinutes} mins ${elapsedTime.inSeconds % 60} seconds',
                  fontSize: 16),
            ])
          ]),
          Divider(color: Colors.white),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: quizResults.length,
              itemBuilder: (context, index) {
                return vertical10Pix(
                    child: answerEntry(index, quizResults[index]));
              }),
        ],
      ),
    );
  }

  Widget answerEntry(int index, Map<dynamic, dynamic> answerData) {
    return Container(
      height: answerData[EntryFields.feedback].toString().isNotEmpty ? 120 : 80,
      decoration: BoxDecoration(color: CustomColors.blush),
      padding: EdgeInsets.all(4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          whiteAndadaProBold('${index + 1}.', fontSize: 20),
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
                                child: whiteAndadaProBold('CLOSE'))
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
              whiteAndadaProBold(
                  'Word/s: ${allQuizModels[quizIndex - 1].wordsToWrite[index]}',
                  fontSize: 16),
              if (isGraded)
                whiteAndadaProBold(
                    'Accuracy: ${((answerData[EntryFields.accuracy] as num) * 100).toStringAsFixed(2)}%'),
              if (answerData[EntryFields.feedback].toString().isNotEmpty)
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: whiteAndadaProRegular(
                        'Feedback: ${answerData[EntryFields.feedback]}',
                        textAlign: TextAlign.left)),
            ],
          )
        ],
      ),
    );
  }
}
