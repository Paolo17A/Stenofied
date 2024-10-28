import 'package:flutter/material.dart';
import 'package:stenofied/models/lesson_model.dart';
import 'package:stenofied/screens/exercise_result_screen.dart';
import 'package:stenofied/screens/login_screen.dart';
import 'package:stenofied/screens/quiz_result_screen.dart';
import 'package:stenofied/screens/selected_student_summary_screen.dart';
import 'package:stenofied/screens/student/student_add_note_screen.dart';
import 'package:stenofied/screens/student/student_edit_note_screen.dart';
import 'package:stenofied/screens/student/student_notes_screen.dart';
import 'package:stenofied/screens/student/student_translate_screen.dart';
import 'package:stenofied/screens/teacher/teacher_register_screen.dart';

import '../screens/admin/admin_add_section_screen.dart';
import '../screens/admin/admin_edit_section_screen.dart';
import '../screens/admin/admin_home_screen.dart';
import '../screens/admin/admin_selected_section_screen.dart';
import '../screens/admin/admin_selected_student_screen.dart';
import '../screens/admin/admin_selected_teacher_screen.dart';
import '../screens/admin/admin_view_sections_screen.dart';
import '../screens/admin/admin_view_students_screen.dart';
import '../screens/admin/admin_view_teachers_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/student/student_home_screen.dart';
import '../screens/student/student_profile_screen.dart';
import '../screens/student/student_register_screen.dart';
import '../screens/student/student_selected_lesson_screen.dart';
import '../screens/student/student_take_exercise_screen.dart';
import '../screens/student/student_take_quiz_screen.dart';
import '../screens/student/student_view_exercises_screen.dart';
import '../screens/student/student_view_lessons_screen.dart';
import '../screens/student/student_view_quizzes_screen.dart';
import '../screens/teacher/teacher_assigned_section_screen.dart';
import '../screens/teacher/teacher_grade_exercise_screen.dart';
import '../screens/teacher/teacher_grade_quiz_screen.dart';
import '../screens/teacher/teacher_home_screen.dart';
import '../screens/teacher/teacher_profile_screen.dart';

class NavigatorRoutes {
  static const login = 'login';
  static const forgotPassword = 'forgotPassword';
  static const editProfile = 'editProfile';
  static void selectedExerciseResult(BuildContext context,
      {required String exerciseResultID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ExerciseResultScreen(exerciseResultID: exerciseResultID)));
  }

  static void selectedQuizResult(BuildContext context,
      {required String quizResultID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => QuizResultScreen(quizResultID: quizResultID)));
  }

  static void selectedStudentSummary(BuildContext context,
      {required String studentID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            SelectedStudentSummaryScreen(studentID: studentID)));
  }

  //  STUDENTS
  static const studentRegister = 'studentRegister';
  static const studentHome = 'studentHome';
  static const studentProfile = 'studentProfile';
  static const studentLessons = 'studentLessons';
  static void studentSelectedLesson(BuildContext context,
      {required LessonModel lessonModel}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            StudentSelectedLessonScreen(lessonModel: lessonModel)));
  }

  static const studentExercises = 'studentExercises';
  static const studentTakeExercise = 'studentTakeExercise';
  static const studentQuizzes = 'studentQuizzes';
  static const studentTakeQuiz = 'studentTakeQuiz';
  static const studentNotes = 'studentNotes';
  static const studentAddNote = 'studentAddNote';
  static void studentEditNote(BuildContext context, {required String noteID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => StudentEditNoteScreen(noteID: noteID)));
  }

  static const studentTranslate = 'studentTranslate';

  //  TEACHERS
  static const teacherRegister = 'teacherRegister';
  static const teacherHome = 'teacherHome';
  static const teacherProfile = 'teacherProfile';
  static const teacherAssignedSection = 'teacherAssignedSection';
  static void teacherGradeSelectedExercise(BuildContext context,
      {required String exerciseResultID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            TeacherGradeExerciseScreen(exerciseResultID: exerciseResultID)));
  }

  static void teacherGradeSelectedQuiz(BuildContext context,
      {required String quizResultID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            TeacherGradeQuizScreen(quizResultID: quizResultID)));
  }

  //  ADMINS
  static const adminHome = 'adminHome';
  static const adminViewStudents = 'adminViewStudents';
  static void adminSelectedStudent(BuildContext context,
      {required String userID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AdminSelectedStudentScreen(userID: userID)));
  }

  static const adminViewTeachers = 'adminViewTeachers';
  static void adminSelectedTeacher(BuildContext context,
      {required String userID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AdminSelectedTeacherScreen(userID: userID)));
  }

  static const adminViewSections = 'adminViewSections';
  static void adminSelectedSection(BuildContext context,
      {required String sectionID, bool isReplacing = false}) {
    if (isReplacing) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              AdminSelectedSectionScreen(sectionID: sectionID)));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              AdminSelectedSectionScreen(sectionID: sectionID)));
    }
  }

  static const adminAddSection = 'adminAddSection';
  static void adminEditSection(BuildContext context,
      {required String sectionID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AdminEditSectionScreen(sectionID: sectionID)));
  }
}

final Map<String, WidgetBuilder> routes = {
  NavigatorRoutes.login: (context) => const LoginScreen(),
  NavigatorRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
  NavigatorRoutes.editProfile: (context) => const EditProfileScreen(),

  //  STUDENTS
  NavigatorRoutes.studentRegister: (context) => const StudentRegisterScreen(),
  NavigatorRoutes.studentHome: (context) => const StudentHomeScreen(),
  NavigatorRoutes.studentProfile: (context) => const StudentProfileScreen(),
  NavigatorRoutes.studentLessons: (context) => const StudentLessonsScreen(),
  NavigatorRoutes.studentExercises: (context) => const StudentExercisesScreen(),
  NavigatorRoutes.studentTakeExercise: (context) =>
      const StudentTakeExerciseScreen(),
  NavigatorRoutes.studentQuizzes: (context) => const StudentQuizzesScreen(),
  NavigatorRoutes.studentTakeQuiz: (context) => const StudentTakeQuizScreen(),
  NavigatorRoutes.studentNotes: (context) => const StudentNotesScreen(),
  NavigatorRoutes.studentAddNote: (context) => const StudentAddNoteScreen(),
  NavigatorRoutes.studentTranslate: (context) => const StudentTranslateScreen(),

  //  TEACHERS
  NavigatorRoutes.teacherRegister: (context) => const TeacherRegisterScreen(),
  NavigatorRoutes.teacherHome: (context) => const TeacherHomeScreen(),
  NavigatorRoutes.teacherProfile: (context) => const TeacherProfileScreen(),
  NavigatorRoutes.teacherAssignedSection: (context) =>
      const TeacherAssignedSectionScreen(),

  //  ADMIN
  NavigatorRoutes.adminHome: (context) => const AdminHomeScreen(),
  NavigatorRoutes.adminViewStudents: (context) =>
      const AdminViewStudentsScreen(),
  NavigatorRoutes.adminViewTeachers: (context) =>
      const AdminViewTeachersScreen(),
  NavigatorRoutes.adminViewSections: (context) =>
      const AdminViewSectionsScreen(),
  NavigatorRoutes.adminAddSection: (context) => const AdminAddSectionScreen()
};
