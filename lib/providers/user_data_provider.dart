import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/string_util.dart';

class UserDataNotifier extends ChangeNotifier {
  String userType = UserTypes.student;
  String profileImageURL = '';
  int lessonIndex = 1;
  String sectionID = '';

  void setUserType(String type) {
    userType = type;
    notifyListeners();
  }

  void setProfileImage(String imageURL) {
    profileImageURL = imageURL;
    notifyListeners();
  }

  void setLessonIndex(int index) {
    lessonIndex = index;
    notifyListeners();
  }

  void setSectionID(String section) {
    sectionID = section;
    notifyListeners();
  }
}

final userDataProvider =
    ChangeNotifierProvider<UserDataNotifier>((ref) => UserDataNotifier());
