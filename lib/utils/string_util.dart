import 'dart:math';

class ImagePaths {
  static const String logo = 'assets/images/stenofied.png';
  static const String studentUser = 'assets/images/student.png';
  static const String teacherUser = 'assets/images/teacher.png';
  static const String tracingPath = 'assets/images/tracing';
}

class StorageFields {
  static const String profilePics = 'profilePics';
  static const String proofOfEnrollments = 'proofOfEnrollments';
  static const String exerciseImages = 'exerciseImages';
  static const String quizImages = 'quizImages';
}

class UserTypes {
  static const String student = 'STUDENT';
  static const String teacher = 'TEACHER';
  static const String admin = 'ADMIN';
}

class Collections {
  static const String users = 'users';
  static const String sections = 'sections';
  static const String faqs = 'faqs';
  static const String exerciseResults = 'exerciseResults';
  static const String quizResults = 'quizResults';
}

class UserFields {
  static const String email = 'email';
  static const String password = 'password';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String userType = 'userType';
  static const String profileImageURL = 'profileImageURL';
  static const String proofOfEnrollment = 'proofOfEnrollment';
  static const String accountVerified = 'accountVerified';
  static const String sectionID = 'sectionID';
  static const String currentLessonIndex = 'currentLessonIndex';
}

class SectionFields {
  static const String name = 'name';
  static const String teacherIDs = 'teacherIDs';
  static const String studentIDs = 'studentIDs';
}

class ExerciseResultFields {
  static const String studentID = 'studentID';
  static const String exerciseIndex = 'exerciseIndex';
  static const String exerciseResults = 'exerciseResults';
  static const String isGraded = 'isGraded';
}

class QuizResultFields {
  static const String studentID = 'studentID';
  static const String quizIndex = 'quizIndex';
  static const String quizResults = 'quizResults';
  static const String isGraded = 'isGraded';
}

class EntryFields {
  static const String isCorrect = 'isCorrect';
  static const String imageURL = 'imageURL';
}

class FAQFields {
  static const String question = 'question';
  static const String answer = 'answer';
}

String generateRandomHexString(int length) {
  final random = Random();
  final codeUnits = List.generate(length ~/ 2, (index) {
    return random.nextInt(255);
  });

  final hexString =
      codeUnits.map((value) => value.toRadixString(16).padLeft(2, '0')).join();
  return hexString;
}
