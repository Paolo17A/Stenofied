import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stenofied/providers/current_quiz_provider.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

import '../../models/drawing_point.dart';

class StudentTakeQuizScreen extends ConsumerStatefulWidget {
  const StudentTakeQuizScreen({super.key});

  @override
  ConsumerState<StudentTakeQuizScreen> createState() =>
      _StudentTakeQuizScreenState();
}

class _StudentTakeQuizScreenState extends ConsumerState<StudentTakeQuizScreen> {
  //var historyDrawingPoints = <DrawingPoint>[];

  var drawingPoints = <DrawingPoint>[];
  DrawingPoint? currentDrawingPoint;
  bool hasDoodle = false;
  ScreenshotController screenshotController = ScreenshotController();
  double doodleWidth = 5;

  void onNextButtonPress() async {
    if (hasDoodle) {
      final traceOutput = await screenshotController.capture();
      if (traceOutput == null) return;
      if (ref.read(currentQuizProvider).isLookingAtCurrentDoodle()) {
        ref.read(currentQuizProvider).addNewDoodleOutput(traceOutput);
      } else {
        ref.read(currentQuizProvider).replaceDoodleOutput(traceOutput);
      }
      if (ref.read(currentQuizProvider).isLookingAtLastWord()) {
        QuizzesCollectionUtil.submitNewQuizResult(context, ref);
      } else {
        ref.read(currentQuizProvider).incrementQuizIndex();
      }
      drawingPoints.clear();
      hasDoodle = false;
    } else if (ref.read(currentQuizProvider).questionIndex !=
            ref.read(currentQuizProvider).doodleOutputList.length &&
        ref.read(currentQuizProvider).getCurrentDoodle() != null) {
      ref.read(currentQuizProvider).incrementQuizIndex();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have not yet writted this word.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(currentQuizProvider);
    return Scaffold(
      appBar: appBarWidget(mayGoBack: true),
      body: stackedLoadingContainer(
          context,
          ref.read(loadingProvider).isLoading,
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: all20Pix(
                  child: Column(
                children: [
                  _quizIndexHeader(),
                  _writingCanvas(),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          drawingPoints.clear();
                          hasDoodle = false;
                        });
                        ref.read(currentQuizProvider).deleteDoodleOutput();
                      },
                      child: whiteAndadaProBold('RESET SHORTHAND')),
                  Gap(100),
                  _navigatorButtons()
                ],
              )),
            ),
          )),
    );
  }

  Widget _quizIndexHeader() {
    return blackCinzelBold(
        'Quiz ${ref.read(currentQuizProvider).currentQuizModel!.quizIndex.toString()}',
        fontSize: 40);
  }

  Widget _writingCanvas() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: CustomColors.ketchup, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _currentWord(),
          Screenshot(
            controller: screenshotController,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: ref
                              .read(currentQuizProvider)
                              .isLookingAtPreviousDoodle() &&
                          ref.read(currentQuizProvider).getCurrentDoodle() !=
                              null
                      ? DecorationImage(
                          fit: BoxFit.contain,
                          image: MemoryImage(ref
                                  .read(currentQuizProvider)
                                  .doodleOutputList[
                              ref.read(currentQuizProvider).questionIndex]!))
                      : null),
              child: GestureDetector(
                onPanStart: (details) {
                  if (!ref
                          .read(currentQuizProvider)
                          .isLookingAtPreviousDoodle() &&
                      ref.read(currentQuizProvider).getCurrentDoodle() !=
                          null) {
                    print('may not draw');
                    return;
                  }
                  setState(() {
                    currentDrawingPoint = DrawingPoint(
                        id: DateTime.now().millisecondsSinceEpoch,
                        offsets: [details.localPosition]);
                    if (currentDrawingPoint == null) return;
                    drawingPoints.add(currentDrawingPoint!);
                  });
                },
                onPanUpdate: (details) {
                  if (!ref
                          .read(currentQuizProvider)
                          .isLookingAtPreviousDoodle() &&
                      ref.read(currentQuizProvider).getCurrentDoodle() != null)
                    return;
                  setState(() {
                    if (currentDrawingPoint == null) return;
                    currentDrawingPoint = currentDrawingPoint?.copyWith(
                        offsets: currentDrawingPoint!.offsets
                          ..add(details.localPosition));
                    drawingPoints.last = currentDrawingPoint!;
                  });
                },
                onPanEnd: (details) {
                  currentDrawingPoint = null;
                  hasDoodle = true;
                  print('drawing points: ${drawingPoints.length}');
                },
                child: CustomPaint(
                  painter: DrawingPainter(drawingPoints: drawingPoints),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    //color: Colors.grewen,
                  ),
                ),
              ),
            ),
          ),
          Slider(
              value: doodleWidth,
              min: 1,
              max: 10,
              thumbColor: Colors.white,
              activeColor: Colors.white,
              inactiveColor: Colors.white70,
              onChanged: (newVal) {
                setState(() {
                  doodleWidth = newVal;
                });
              }),
          Gap(10),
          whiteAndadaProBold('Write the word above in shorthand.'),
        ],
      ),
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

  Widget _navigatorButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
            onPressed: ref.read(currentQuizProvider).questionIndex == 0
                ? null
                : () async {
                    if (hasDoodle) {
                      final traceOutput = await screenshotController.capture();
                      if (traceOutput == null) return;

                      if (ref
                          .read(currentQuizProvider)
                          .isLookingAtCurrentDoodle()) {
                        ref
                            .read(currentQuizProvider)
                            .addNewDoodleOutput(traceOutput);
                      } else {
                        ref
                            .read(currentQuizProvider)
                            .replaceDoodleOutput(traceOutput);
                      }
                    }
                    drawingPoints.clear();
                    hasDoodle = false;
                    ref.read(currentQuizProvider).decrementQuizIndex();
                  },
            style: ElevatedButton.styleFrom(
                disabledBackgroundColor: CustomColors.blush),
            child: whiteAndadaProBold('PREV')),
        SizedBox(
          child: ElevatedButton(
              onPressed: () => onNextButtonPress(),
              child: whiteAndadaProBold(
                  ref.read(currentQuizProvider).isLookingAtLastWord()
                      ? 'SUBMIT'
                      : 'NEXT')),
        )
      ],
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  DrawingPainter({required this.drawingPoints});
  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;

      for (var i = 0; i < drawingPoint.offsets.length; i++) {
        var notLastOffset = i != drawingPoint.offsets.length - 1;
        if (notLastOffset) {
          final current = drawingPoint.offsets[i];
          final next = drawingPoint.offsets[i + 1];
          canvas.drawLine(current, next, paint);
        } else {
          continue;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
