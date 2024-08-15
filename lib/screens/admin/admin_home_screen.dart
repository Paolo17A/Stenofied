import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/widgets/navigator_rail_widget.dart';

import '../../providers/loading_provider.dart';
import '../../providers/user_data_provider.dart';
import '../../utils/navigator_util.dart';
import '../../utils/string_util.dart';
import '../../widgets/app_drawer_widget.dart';
import '../../widgets/custom_button_widgets.dart';
import '../../widgets/custom_miscellaneous_widgets.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int studentsCount = 0;
  int teachersCount = 0;
  int sectionsCount = 0;
  bool extended = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(loadingProvider).toggleLoading(true);
      final students = await UsersCollectionUtil.getAllStudentDocs();
      studentsCount = students.length;
      final teachers = await UsersCollectionUtil.getAllTeacherDocs();
      teachersCount = teachers.length;
      final sections = await SectionsCollectionUtil.getAllSectionDocs();
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
        key: scaffoldKey,
        drawer: adminAppDrawer(context, ref,
            currentPath: NavigatorRoutes.adminHome),
        body: switchedLoadingContainer(
            ref.read(loadingProvider).isLoading,
            safeAreaWithRail(context,
                railWidget: adminRail(context, scaffoldKey,
                    selectedIndex: 0, currentPath: NavigatorRoutes.adminHome),
                mainWidget: Column(
                  children: [
                    welcomeWidgets(context,
                        userType: ref.read(userDataProvider).userType,
                        profileImageURL:
                            ref.read(userDataProvider).profileImageURL),
                    Gap(60),
                    _homeButtons()
                  ],
                ))),
      ),
    );
  }

  Widget _homeButtons() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        homeButton(context,
            label: 'STUDENT RECORDS',
            imagePath: ImagePaths.studentRecord,
            count: studentsCount,
            willDisplayCount: true,
            onPress: () => Navigator.of(context)
                .pushNamed(NavigatorRoutes.adminViewStudents)),
        homeButton(context,
            imagePath: ImagePaths.teacherRecord,
            label: 'TEACHER RECORDS',
            count: teachersCount,
            willDisplayCount: true,
            onPress: () => Navigator.of(context)
                .pushNamed(NavigatorRoutes.adminViewTeachers)),
        homeButton(context,
            label: 'SECTION RECORDS',
            imagePath: ImagePaths.sectionRecord,
            count: sectionsCount,
            willDisplayCount: true,
            onPress: () => Navigator.of(context)
                .pushNamed(NavigatorRoutes.adminViewSections))
      ],
    );
  }
}
