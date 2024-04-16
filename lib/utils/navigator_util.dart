import 'package:flutter/material.dart';
import 'package:stenofied/screens/student_register_screen.dart';
import 'package:stenofied/screens/teacher_login_screen.dart';
import 'package:stenofied/screens/student_login_screen.dart';
import 'package:stenofied/screens/teacher_register_screen.dart';

import '../screens/admin_login_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/welcome_screen.dart';

class NavigatorRoutes {
  static const welcome = 'welcome';
  static const forgotPassword = 'forgotPassword';
  static const editProfile = 'editProfile';

  //  USERS
  static const studentLogin = 'studentLogin';
  static const userRegister = 'userRegister';
  static const userHome = 'userHome';
  static const userProfile = 'userProfile';

  //  COLLECTORS
  static const teacherLogin = 'teacherLogin';
  static const teacherRegister = 'teacherRegister';
  static const teacherHome = 'teacherHome';
  static const collectorProfile = 'collectorProfile';

  //  ADMINS
  static const adminLogin = 'adminLogin';
  static const adminHome = 'adminHome';
  static const adminViewUsers = 'adminViewUsers';
  /*static void adminSelectedUser(BuildContext context,
      {required String userID}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AdminSelectedUserScreen(userID: userID)));
  }*/

  static const adminViewCollectors = 'adminViewCollectors';
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
  //NavigatorRoutes.editProfile: (context) => const EditProfileScreen(),

  //  USERS
  NavigatorRoutes.studentLogin: (context) => const StudentLoginScreen(),
  NavigatorRoutes.userRegister: (context) => const StudentRegisterScreen(),
  //NavigatorRoutes.userHome: (context) => const UserHomeScreen(),
  //NavigatorRoutes.userProfile: (context) => const UserProfileScreen(),

  //  COLLECTORS
  NavigatorRoutes.teacherLogin: (context) => const TeacherLoginScreen(),
  NavigatorRoutes.teacherRegister: (context) => const TeacherRegisterScreen(),
  //NavigatorRoutes.collectorHome: (context) => const CollectorHomeScreen(),
  //NavigatorRoutes.collectorProfile: (context) => const CollectorProfileScreen(),

  //  ADMIN
  NavigatorRoutes.adminLogin: (context) => const AdminLoginScreen(),
  /*NavigatorRoutes.adminHome: (context) => const AdminHomeScreen(),
  NavigatorRoutes.adminViewUsers: (context) => const AdminViewUsersScreen(),
  NavigatorRoutes.adminViewCollectors: (context) =>
      const AdminViewCollectorsScreen()*/
};
