import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_drawer_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';
import 'package:stenofied/widgets/navigator_rail_widget.dart';

import '../../widgets/custom_text_field_widget.dart';

class TeacherAssignedSectionScreen extends ConsumerStatefulWidget {
  const TeacherAssignedSectionScreen({super.key});

  @override
  ConsumerState<TeacherAssignedSectionScreen> createState() =>
      _TeacherAssignedSectionScreenState();
}

class _TeacherAssignedSectionScreenState
    extends ConsumerState<TeacherAssignedSectionScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String sectionName = '';
  List<DocumentSnapshot> studentDocs = [];
  List<DocumentSnapshot> filteredStudentDocs = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      String lowerCasedSearchInput = searchController.text.trim().toLowerCase();
      setState(() {
        filteredStudentDocs = studentDocs.where((student) {
          final studentData = student.data() as Map<dynamic, dynamic>;
          String firstName =
              studentData[UserFields.firstName].toString().toLowerCase();
          String lastName =
              studentData[UserFields.lastName].toString().toLowerCase();

          return firstName.contains(lowerCasedSearchInput) ||
              lastName.contains(lowerCasedSearchInput);
        }).toList();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final user = await UsersCollectionUtil.getCurrentUserDoc();
        final userData = user.data() as Map<dynamic, dynamic>;

        String sectionID = userData[UserFields.sectionID];
        final section =
            await SectionsCollectionUtil.getThisSectionDoc(sectionID);
        final sectionData = section.data() as Map<dynamic, dynamic>;
        sectionName = sectionData[SectionFields.name];

        studentDocs =
            await UsersCollectionUtil.getSectionStudentDocs(sectionID);
        filteredStudentDocs = studentDocs;
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error getting assigned section data: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      key: scaffoldKey,
      drawer: teacherAppDrawer(context, ref,
          currentPath: NavigatorRoutes.teacherAssignedSection),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              teacherRail(context, scaffoldKey,
                  selectedIndex: 1,
                  currentPath: NavigatorRoutes.teacherAssignedSection),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: SingleChildScrollView(
                  child: all20Pix(
                      child: Column(
                    children: [
                      Gap(28),
                      blackCinzelBold('Section: $sectionName', fontSize: 26),
                      vertical10Pix(
                        child: CustomTextField(
                            text: 'Search for a student...',
                            controller: searchController,
                            textInputType: TextInputType.text,
                            displayPrefixIcon: Icon(Icons.search)),
                      ),
                      _expandableStudents()
                    ],
                  )),
                ),
              ),
            ],
          )),
    );
  }

  Widget _expandableStudents() {
    return vertical20Pix(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsetsDirectional.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: filteredStudentDocs.length,
        itemBuilder: (context, index) => all10Pix(
          child: userRecordEntry(
              userDoc: filteredStudentDocs[index],
              onTap: () => NavigatorRoutes.selectedStudentSummary(context,
                  studentID: filteredStudentDocs[index].id)),
        ),
      ),
    );
  }
}
