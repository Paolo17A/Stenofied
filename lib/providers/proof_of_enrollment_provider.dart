import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProofOfEnrollmentNotifier extends ChangeNotifier {
  File? proofOfEnrollmentFile;

  Future setProofOfEmployment() async {
    ImagePicker imagePicker = ImagePicker();
    final selectedXFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedXFile != null) {
      proofOfEnrollmentFile = File(selectedXFile.path);
      notifyListeners();
    }
  }

  void resetProofOfEmployment() {
    proofOfEnrollmentFile = null;
    notifyListeners();
  }
}

final proofOfEnrollmentProvider =
    ChangeNotifierProvider((ref) => ProofOfEnrollmentNotifier());
