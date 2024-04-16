import 'package:flutter/material.dart';
import 'package:stenofied/screens/admin_view_students_screen.dart';
import 'package:stenofied/screens/admin_view_teachers_screen.dart';

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

  //  USERS
  static const studentLogin = 'studentLogin';
  static const studentRegister = 'studentRegister';
  static const studentHome = 'studentHome';
  static const studentProfile = 'studentProfile';

  //  COLLECTORS
  static const teacherLogin = 'teacherLogin';
  static const teacherRegister = 'teacherRegister';
  static const teacherHome = 'teacherHome';
  static const teacherProfile = 'teacherProfile';

  //  ADMINS
  static const adminLogin = 'adminLogin';
  static const adminHome = 'adminHome';
  static const adminViewStudents = 'adminViewStudents';
  /*static void adminSelectedUser(BuildContext context,
      {required String userID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AdminSelectedUserScreen(userID: userID)));
  }*/

  static const adminViewTeachers = 'adminViewTeachers';
  /*static void adminSelectedCollector(BuildContext context,
      {required String collectorID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            AdminSelectedCollectorScreen(collectorID: collectorID)));
  }*/
}

final Map<String, WidgetBuilder> routes = {
  NavigatorRoutes.welcome: (context) => const WelcomeScreen(),
  NavigatorRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
  NavigatorRoutes.editProfile: (context) => const EditProfileScreen(),

  //  USERS
  NavigatorRoutes.studentLogin: (context) => const StudentLoginScreen(),
  NavigatorRoutes.studentRegister: (context) => const StudentRegisterScreen(),
  NavigatorRoutes.studentHome: (context) => const StudentHomeScreen(),
  NavigatorRoutes.studentProfile: (context) => const StudentProfileScreen(),

  //  COLLECTORS
  NavigatorRoutes.teacherLogin: (context) => const TeacherLoginScreen(),
  NavigatorRoutes.teacherRegister: (context) => const TeacherRegisterScreen(),
  NavigatorRoutes.teacherHome: (context) => const TeacherHomeScreen(),
  NavigatorRoutes.teacherProfile: (context) => const TeacherProfileScreen(),

  //  ADMIN
  NavigatorRoutes.adminLogin: (context) => const AdminLoginScreen(),
  NavigatorRoutes.adminHome: (context) => const AdminHomeScreen(),
  NavigatorRoutes.adminViewStudents: (context) =>
      const AdminViewStudentsScreen(),
  NavigatorRoutes.adminViewTeachers: (context) =>
      const AdminViewTeachersScreen()
};
