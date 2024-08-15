import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  int score = 0;
  bool isGraded = false;
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
        for (var result in quizResults) {
          if (result[EntryFields.isCorrect]) score++;
        }
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
                'Score: ${score}/${allQuizModels[quizIndex - 1].wordsToWrite.length}',
                fontSize: 22),
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
      height: 80,
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
                    'Result: ${answerData[EntryFields.isCorrect] ? 'CORRECT' : 'WRONG'}')
            ],
          )
        ],
      ),
    );
  }
}
