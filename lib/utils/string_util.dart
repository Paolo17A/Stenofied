import 'dart:math';

class ImagePaths {
  static const String logo = 'assets/images/stenofied.png';
  static const String studentUser = 'assets/images/student.png';
  static const String teacherUser = 'assets/images/teacher.png';
  static const String tracingPath = 'assets/images/tracing';
  static const String home = 'assets/images/icons/home.png';
  static const String section = 'assets/images/icons/section.png';
  static const String faqs = 'assets/images/icons/FAQs.png';
  static const String profile = 'assets/images/icons/profile.png';
  static const String logout = 'assets/images/icons/logout.png';
  static const String studentRecord = 'assets/images/icons/student record.png';
  static const String sectionRecord = 'assets/images/icons/section record.png';
  static const String teacherRecord = 'assets/images/icons/teacher record.png';
  static const String writing = 'assets/images/icons/writing_vector.png';
  static const String tropic = 'assets/images/icons/4.png';
  static const String tower = 'assets/images/icons/5.png';
  static const String lessons = 'assets/images/icons/lessons.png';
  static const String exercises = 'assets/images/icons/exercise.png';
  static const String quizzes = 'assets/images/icons/quiz.png';
  static const String camera = 'assets/images/icons/camera.png';
  static const String notes = 'assets/images/icons/notes.png';
  static const String edit = 'assets/images/icons/edit.png';
  static const String convert = 'assets/images/icons/convert.png';
  static const String translator = 'assets/images/icons/translator.png';
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
  static const String notes = 'notes';
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
  static const String dateAnswered = 'dateAnswered';
  static const String elapsedTime = 'elapsedTime';
}

class QuizResultFields {
  static const String studentID = 'studentID';
  static const String quizIndex = 'quizIndex';
  static const String quizResults = 'quizResults';
  static const String isGraded = 'isGraded';
  static const String dateAnswered = 'dateAnswered';
  static const String elapsedTime = 'elapsedTime';
}

class EntryFields {
  //static const String isCorrect = 'isCorrect';
  static const String imageURL = 'imageURL';
  static const String accuracy = 'accuracy';
  static const String feedback = 'feedback';
}

class FAQFields {
  static const String question = 'question';
  static const String answer = 'answer';
}

class NotesFields {
  static const String studentID = 'studentID';
  static const String title = 'title';
  static const String content = 'content';
  static const String dateCreated = 'dateCreated';
  static const String dateModified = 'dateModified';
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

List<String> getLetters(String input) {
  // Create a list to hold the individual letters
  List<String> letters = [];

  // Iterate through each character in the input string
  for (int i = 0; i < input.length; i++) {
    // Check if the character is a letter
    if (RegExp(r'[a-zA-Z]').hasMatch(input[i])) {
      // Add the letter to the list
      letters.add(input[i].toLowerCase());
    }
  }

  return letters;
}
