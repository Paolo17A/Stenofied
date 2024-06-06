import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SectionsProvider extends ChangeNotifier {
  List<DocumentSnapshot> sectionDocs = [];

  void setSectionDocs(List<DocumentSnapshot> sections) {
    sectionDocs = sections;
    notifyListeners();
  }
}

final sectionsProvider =
    ChangeNotifierProvider<SectionsProvider>((ref) => SectionsProvider());
