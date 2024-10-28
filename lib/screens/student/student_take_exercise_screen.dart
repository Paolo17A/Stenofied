import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stenofied/providers/current_exercise_provider.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

import '../../models/drawing_point.dart';

class StudentTakeExerciseScreen extends ConsumerStatefulWidget {
  const StudentTakeExerciseScreen({super.key});

  @override
  ConsumerState<StudentTakeExerciseScreen> createState() =>
      _StudentTakeExerciseScreenState();
}

class _StudentTakeExerciseScreenState
    extends ConsumerState<StudentTakeExerciseScreen> {
  var drawingPoints = <DrawingPoint>[];
  DrawingPoint? currentDrawingPoint;
  bool hasDoodle = false;
  double doodleWidth = 5;
  ScreenshotController screenshotController = ScreenshotController();
  FlutterTts flutterTts = FlutterTts();
  //  TIMER VARIABLES
  Duration elapsedTime = Duration.zero;
  Duration elapsedCountdown = const Duration(hours: 1);
  @override
  void dispose() {
    super.dispose();
    flutterTts.pause();
    flutterTts.stop();
  }

  Future playback() async {
    //await flutterTts.stop();
    await flutterTts
        .setLanguage('en-US'); // Set the language (adjust as needed)
    await flutterTts.setPitch(1.0); // Set pitch (adjust as needed)
    await flutterTts.setSpeechRate(0.5); // Set speech rate (adjust as needed)
    String currentWord = ref
        .read(currentExerciseProvider)
        .currentExerciseModel!
        .tracingModels[ref.read(currentExerciseProvider).tracingIndex]
        .word;
    await flutterTts.speak(currentWord);
  }

  void onNextButtonPress() async {
    if (hasDoodle) {
      final traceOutput = await screenshotController.capture();
      if (traceOutput == null) return;
      if (ref.read(currentExerciseProvider).isLookingAtCurrentTrace()) {
        ref.read(currentExerciseProvider).addNewTraceOutput(traceOutput);
      } else {
        ref.read(currentExerciseProvider).replaceTraceOutput(traceOutput);
      }
      if (ref.read(currentExerciseProvider).isLookingAtLastWord()) {
        ExercisesCollectionUtil.submitNewExerciseResult(context, ref,
            elapsedTime: elapsedTime);
      } else {
        ref.read(currentExerciseProvider).incrementTracingIndex();
      }
      drawingPoints.clear();
      hasDoodle = false;
    } else if (!ref.read(currentExerciseProvider).isLookingAtCurrentTrace() &&
        ref.read(currentExerciseProvider).getCurrentTrace() != null) {
      ref.read(currentExerciseProvider).incrementTracingIndex();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have not yet traced this word.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(currentExerciseProvider);
    return Scaffold(
      appBar: appBarWidget(mayGoBack: true),
      body: stackedLoadingContainer(
          context,
          ref.read(loadingProvider).isLoading,
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: all10Pix(
                child: Column(
              children: [
                _exerciseIndexHeader(),
                _tracingCanvas(),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        drawingPoints.clear();
                        hasDoodle = false;
                      });
                      ref.read(currentExerciseProvider).deleteTraceOutput();
                    },
                    child: whiteAndadaProBold('RESET TRACE')),
                Gap(40),
                _navigatorButtons()
              ],
            )),
          )),
    );
  }

  Widget _exerciseIndexHeader() {
    return blackCinzelBold(
        'Exercise ${ref.read(currentExerciseProvider).currentExerciseModel!.exerciseIndex.toString()}',
        fontSize: 40);
  }

  Widget _tracingCanvas() {
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
                  image: ref
                              .read(currentExerciseProvider)
                              .isLookingAtPreviousTrace() &&
                          ref.read(currentExerciseProvider).getCurrentTrace() !=
                              null
                      ? DecorationImage(
                          fit: BoxFit.contain,
                          image: MemoryImage(ref
                                  .read(currentExerciseProvider)
                                  .traceOutputList[
                              ref.read(currentExerciseProvider).tracingIndex]!))
                      : DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage(ref
                              .read(currentExerciseProvider)
                              .currentExerciseModel!
                              .tracingModels[ref
                                  .read(currentExerciseProvider)
                                  .tracingIndex]
                              .imagePath))),
              child: GestureDetector(
                onPanStart: (details) {
                  if (!ref
                          .read(currentExerciseProvider)
                          .isLookingAtPreviousTrace() &&
                      ref.read(currentExerciseProvider).getCurrentTrace() !=
                          null) return;
                  setState(() {
                    currentDrawingPoint = DrawingPoint(
                        id: DateTime.now().millisecondsSinceEpoch,
                        offsets: [details.localPosition],
                        width: doodleWidth);
                    if (currentDrawingPoint == null) return;
                    drawingPoints.add(currentDrawingPoint!);
                  });
                },
                onPanUpdate: (details) {
                  if (!ref
                          .read(currentExerciseProvider)
                          .isLookingAtPreviousTrace() &&
                      ref.read(currentExerciseProvider).getCurrentTrace() !=
                          null) return;
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
                },
                child: CustomPaint(
                  painter: DrawingPainter(drawingPoints: drawingPoints),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
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
          whiteAndadaProBold('Trace the shorthanded word above.'),
        ],
      ),
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
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        whiteAndadaProBold('Word $currentIndex/$totalWords: $currentWord',
            fontSize: 24),
        ElevatedButton(
            onPressed: playback,
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(), backgroundColor: Colors.white),
            child: Icon(
              Icons.volume_up,
              color: CustomColors.ketchup,
            ))
      ],
    ));
  }

  Widget _navigatorButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
            onPressed: ref.read(currentExerciseProvider).tracingIndex == 0
                ? null
                : () async {
                    if (hasDoodle) {
                      final traceOutput = await screenshotController.capture();
                      if (traceOutput == null) return;

                      if (ref
                          .read(currentExerciseProvider)
                          .isLookingAtCurrentTrace()) {
                        ref
                            .read(currentExerciseProvider)
                            .addNewTraceOutput(traceOutput);
                      } else {
                        ref
                            .read(currentExerciseProvider)
                            .replaceTraceOutput(traceOutput);
                      }
                    }
                    drawingPoints.clear();
                    hasDoodle = false;
                    ref.read(currentExerciseProvider).decrementTracingIndex();
                  },
            style: ElevatedButton.styleFrom(
                disabledBackgroundColor: CustomColors.blush),
            child: whiteAndadaProBold('PREV')),
        SizedBox(
          child: ElevatedButton(
              onPressed: () => onNextButtonPress(),
              child: whiteAndadaProBold(
                  ref.read(currentExerciseProvider).isLookingAtLastWord()
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
