import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesNotifier extends ChangeNotifier {
  List<DocumentSnapshot> _notesDocs = [];

  List<DocumentSnapshot> getNoteDocs() {
    return _notesDocs;
  }

  void setNotesDocs(List<DocumentSnapshot> notes) {
    _notesDocs = notes;
    notifyListeners();
  }
}

final notesProvider =
    ChangeNotifierProvider<NotesNotifier>((ref) => NotesNotifier());
