import 'package:flutter/material.dart';
import 'package:stenofied/models/lesson_model.dart';
import 'package:stenofied/screens/admin_add_section_screen.dart';
import 'package:stenofied/screens/admin_edit_section_screen.dart';
import 'package:stenofied/screens/admin_selected_section_screen.dart';
import 'package:stenofied/screens/admin_selected_student_screen.dart';
import 'package:stenofied/screens/admin_selected_teacher_screen.dart';
import 'package:stenofied/screens/admin_view_sections_screen.dart';
import 'package:stenofied/screens/admin_view_students_screen.dart';
import 'package:stenofied/screens/admin_view_teachers_screen.dart';
import 'package:stenofied/screens/student_selected_lesson_screen.dart';
import 'package:stenofied/screens/student_view_lessons_screen.dart';
import 'package:stenofied/screens/teacher_assigned_section_screen.dart';

import '../screens/admin_home_screen.dart';
import '../screens/admin_login_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/student_home_screen.dart';
import '../screens/student_login_screen.dart';
import '../screens/student_profile_screen.dart';
import '../screens/student_register_screen.dart';
import '../screens/teacher_home_screen.dart';
import '../screens/teacher_login_screen.dart';
import '../screens/teacher_profile_screen.dart';
import '../screens/teacher_register_screen.dart';
import '../screens/welcome_screen.dart';

class NavigatorRoutes {
  static const welcome = 'welcome';
  static const forgotPassword = 'forgotPassword';
  static const editProfile = 'editProfile';

  //  STUDENTS
  static const studentLogin = 'studentLogin';
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

  //  TEACHERS
  static const teacherLogin = 'teacherLogin';
  static const teacherRegister = 'teacherRegister';
  static const teacherHome = 'teacherHome';
  static const teacherProfile = 'teacherProfile';
  static const teacherAssignedSection = 'teacherAssignedSection';

  //  ADMINS
  static const adminLogin = 'adminLogin';
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
  NavigatorRoutes.welcome: (context) => const WelcomeScreen(),
  NavigatorRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
  NavigatorRoutes.editProfile: (context) => const EditProfileScreen(),

  //  STUDENTS
  NavigatorRoutes.studentLogin: (context) => const StudentLoginScreen(),
  NavigatorRoutes.studentRegister: (context) => const StudentRegisterScreen(),
  NavigatorRoutes.studentHome: (context) => const StudentHomeScreen(),
  NavigatorRoutes.studentProfile: (context) => const StudentProfileScreen(),
  NavigatorRoutes.studentLessons: (context) => const StudentLessonsScreen(),

  //  TEACHERS
  NavigatorRoutes.teacherLogin: (context) => const TeacherLoginScreen(),
  NavigatorRoutes.teacherRegister: (context) => const TeacherRegisterScreen(),
  NavigatorRoutes.teacherHome: (context) => const TeacherHomeScreen(),
  NavigatorRoutes.teacherProfile: (context) => const TeacherProfileScreen(),
  NavigatorRoutes.teacherAssignedSection: (context) =>
      const TeacherAssignedSectionScreen(),

  //  ADMIN
  NavigatorRoutes.adminLogin: (context) => const AdminLoginScreen(),
  NavigatorRoutes.adminHome: (context) => const AdminHomeScreen(),
  NavigatorRoutes.adminViewStudents: (context) =>
      const AdminViewStudentsScreen(),
  NavigatorRoutes.adminViewTeachers: (context) =>
      const AdminViewTeachersScreen(),
  NavigatorRoutes.adminViewSections: (context) =>
      const AdminViewSectionsScreen(),
  NavigatorRoutes.adminAddSection: (context) => const AdminAddSectionScreen()
};
