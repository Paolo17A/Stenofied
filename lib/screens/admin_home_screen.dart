import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/utils/future_util.dart';
import '../providers/loading_provider.dart';
import '../providers/user_data_provider.dart';
import '../utils/color_util.dart';
import '../utils/navigator_util.dart';
import '../utils/string_util.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/custom_button_widgets.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_padding_widgets.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  int studentsCount = 0;
  int teachersCount = 0;
  int sectionsCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(loadingProvider).toggleLoading(true);
      final students = await getAllStudentDocs();
      studentsCount = students.length;
      final teachers = await getAllTeacherDocs();
      teachersCount = teachers.length;
      final sections = await getAllSectionDocs();
      sectionsCount = sections.length;
      ref.read(loadingProvider).toggleLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(userDataProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: appBarWidget(mayGoBack: true),
        drawer:
            appDrawer(context, ref, userType: UserTypes.admin, isHome: true),
        body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SingleChildScrollView(
            child: all20Pix(
                child: Column(
              children: [
                welcomeWidgets(
                    userType: ref.read(userDataProvider).userType,
                    profileImageURL: ref.read(userDataProvider).profileImageURL,
                    containerColor: CustomColors.turquoise),
                _homeButtons()
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget _homeButtons() {
    return all20Pix(
        child: Column(
      children: [
        homeButton(context,
            label: 'STUDENT RECORDS',
            count: studentsCount,
            onPress: () => Navigator.of(context)
                .pushNamed(NavigatorRoutes.adminViewStudents)),
        homeButton(context,
            label: 'TEACHER RECORDS',
            count: teachersCount,
            onPress: () => Navigator.of(context)
                .pushNamed(NavigatorRoutes.adminViewTeachers)),
        homeButton(context,
            label: 'SECTION RECORDS',
            count: sectionsCount,
            onPress: () => Navigator.of(context)
                .pushNamed(NavigatorRoutes.adminViewSections))
      ],
    ));
  }
}
