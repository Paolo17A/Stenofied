import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/models/tracing_model.dart';

class CurrentExerciseNotifier extends ChangeNotifier {
  ExerciseModel? currentExerciseModel;
  int tracingIndex = 0;
  List<Uint8List?> traceOutputList = [];

  void setExerciseModel(ExerciseModel tracingModel) {
    currentExerciseModel = tracingModel;
    notifyListeners();
  }

  void decrementTracingIndex() {
    tracingIndex--;
    notifyListeners();
  }

  void replaceTraceOutput(Uint8List trace) {
    traceOutputList[tracingIndex] = trace;
    notifyListeners();
  }

  void addNewTraceOutput(Uint8List trace) {
    traceOutputList.add(trace);
    notifyListeners();
  }

  void deleteTraceOutput() {
    if (traceOutputList.isEmpty || tracingIndex == traceOutputList.length)
      return;
    traceOutputList[tracingIndex] = null;
    notifyListeners();
  }

  void incrementTracingIndex() {
    tracingIndex++;
    notifyListeners();
  }

  void resetExerciseProvider() {
    currentExerciseModel = null;
    tracingIndex = 0;
    traceOutputList.clear();
    notifyListeners();
  }

  bool isLookingAtPreviousTrace() {
    return tracingIndex < traceOutputList.length;
  }

  bool isLookingAtCurrentTrace() {
    return tracingIndex == traceOutputList.length;
  }

  bool isLookingAtLastWord() {
    return tracingIndex == currentExerciseModel!.tracingModels.length - 1;
  }

  Uint8List? getCurrentTrace() {
    if (tracingIndex >= traceOutputList.length) return null;
    return traceOutputList[tracingIndex];
  }
}

final currentExerciseProvider =
    ChangeNotifierProvider((ref) => CurrentExerciseNotifier());
