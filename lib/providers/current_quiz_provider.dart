import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz_model.dart';

class CurrentQuizNotifier extends ChangeNotifier {
  QuizModel? currentQuizModel;
  int questionIndex = 0;
  List<Uint8List?> doodleOutputList = [];

  void setQuizModel(QuizModel quizModel) {
    currentQuizModel = quizModel;
    notifyListeners();
  }

  void decrementQuizIndex() {
    questionIndex--;
    notifyListeners();
  }

  void replaceDoodleOutput(Uint8List trace) {
    doodleOutputList[questionIndex] = trace;
    notifyListeners();
  }

  void addNewDoodleOutput(Uint8List trace) {
    doodleOutputList.add(trace);
    notifyListeners();
  }

  void deleteDoodleOutput() {
    if (doodleOutputList.isEmpty || questionIndex == doodleOutputList.length)
      return;
    doodleOutputList[questionIndex] = null;
    notifyListeners();
  }

  void incrementQuizIndex() {
    questionIndex++;
    notifyListeners();
  }

  void resetQuizProvider() {
    currentQuizModel = null;
    questionIndex = 0;
    doodleOutputList.clear();
    notifyListeners();
  }

  bool isLookingAtPreviousDoodle() {
    return questionIndex < doodleOutputList.length;
  }

  bool isLookingAtCurrentDoodle() {
    return questionIndex == doodleOutputList.length;
  }

  bool isLookingAtLastWord() {
    return questionIndex == currentQuizModel!.wordsToWrite.length - 1;
  }

  Uint8List? getCurrentDoodle() {
    if (questionIndex >= doodleOutputList.length) return null;
    return doodleOutputList[questionIndex];
  }
}

final currentQuizProvider =
    ChangeNotifierProvider((ref) => CurrentQuizNotifier());
