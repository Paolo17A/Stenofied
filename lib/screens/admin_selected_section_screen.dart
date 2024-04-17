import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

class AdminSelectedSectionScreen extends ConsumerStatefulWidget {
  final String sectionID;
  const AdminSelectedSectionScreen({super.key, required this.sectionID});

  @override
  ConsumerState<AdminSelectedSectionScreen> createState() =>
      _AdminSelectedSectionScreenState();
}

class _AdminSelectedSectionScreenState
    extends ConsumerState<AdminSelectedSectionScreen> {
  //  SECTION
  String sectionName = '';

  //  TEACHER
  String assignedTeacherName = '';
  List<DocumentSnapshot> availableTeacherDocs = [];

  //  STUDENTS
  List<DocumentSnapshot> sectionStudentDocs = [];
  List<DocumentSnapshot> studentsWithNoSectionDocs = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);

        //  SECTIONS
        final section = await getThisSectionDoc(widget.sectionID);
        final sectionData = section.data() as Map<dynamic, dynamic>;
        sectionName = sectionData[SectionFields.name];

        //  TEACHERS
        final teachers = await getSectionTeacherDoc(widget.sectionID);
        if (teachers.isNotEmpty) {
          final teacherData = teachers.first.data() as Map<dynamic, dynamic>;
          assignedTeacherName =
              '${teacherData[UserFields.firstName]} ${teacherData[UserFields.lastName]}';
        }
        availableTeacherDocs = await getAvailableTeacherDocs();

        //  STUDENTS
        sectionStudentDocs = await getSectionStudentDocs(widget.sectionID);
        studentsWithNoSectionDocs = await getStudentsWithNoSectionDocs();
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error getting section details: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      appBar: appBarWidget(mayGoBack: true, actions: [
        IconButton(
            onPressed: () => NavigatorRoutes.adminEditSection(context,
                sectionID: widget.sectionID),
            icon: Icon(Icons.edit))
      ]),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SingleChildScrollView(
            child: all20Pix(
                child: Column(
              children: [
                _selectedSectionHeader(),
                _sectionTeacher(),
                Divider(color: CustomColors.turquoise),
                _expandableStudents()
              ],
            )),
          )),
    );
  }

  Widget _selectedSectionHeader() {
    return blackInterBold(sectionName, fontSize: 40);
  }

  Widget _sectionTeacher() {
    return vertical20Pix(
        child: Column(
      children: [
        Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            interText('Section Teacher:', fontSize: 24),
            interText(
                assignedTeacherName.isNotEmpty ? assignedTeacherName : 'N/A',
                fontSize: 20)
          ])
        ]),
        ElevatedButton(
            onPressed: () {
              availableTeacherDocs.isNotEmpty
                  ? showAvailableTeachers()
                  : ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No available teachers.')));
            },
            child: whiteInterBold('ASSIGN NEW TEACHER'))
      ],
    ));
  }

  Widget _expandableStudents() {
    return vertical20Pix(
      child: ExpansionTile(
        collapsedBackgroundColor: CustomColors.turquoise,
        backgroundColor: CustomColors.turquoise,
        textColor: Colors.white,
        iconColor: Colors.white,
        collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), side: BorderSide()),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), side: BorderSide()),
        title: whiteInterBold('ASSIGNED STUDENTS', fontSize: 16),
        children: [
          ElevatedButton(
              onPressed: () {
                studentsWithNoSectionDocs.isNotEmpty
                    ? showAvailableStudents()
                    : ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No available students.')));
              },
              child: whiteInterBold('ASSIGN NEW STUDENT')),
          vertical20Pix(
            child: sectionStudentDocs.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ListView.builder(
                      shrinkWrap: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: sectionStudentDocs.length,
                      itemBuilder: (context, index) => all10Pix(
                        child: userRecordEntry(
                            userDoc: sectionStudentDocs[index], onTap: () {}),
                      ),
                    ))
                : whiteInterBold('NO AVAILABLE STUDENTS', fontSize: 16),
          )
        ],
      ),
    );
  }

  void showAvailableTeachers() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                  child: Column(
                children: [
                  blackInterBold('AVAILABLE TEACHERS', fontSize: 20),
                  Column(
                    children: availableTeacherDocs.map((teacher) {
                      final teacherData =
                          teacher.data() as Map<dynamic, dynamic>;
                      final teacherName =
                          '${teacherData[UserFields.firstName]} ${teacherData[UserFields.lastName]}';
                      return vertical10Pix(
                          child: ElevatedButton(
                              onPressed: () => assignUserToSection(context, ref,
                                  sectionID: widget.sectionID,
                                  userID: teacher.id),
                              child: whiteInterBold(teacherName)));
                    }).toList(),
                  ),
                ],
              )),
            ));
  }

  void showAvailableStudents() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                  child: Column(
                children: [
                  blackInterBold('AVAILABLE STUDENTS', fontSize: 20),
                  Column(
                    children: studentsWithNoSectionDocs.map((student) {
                      final studentData =
                          student.data() as Map<dynamic, dynamic>;
                      final teacherName =
                          '${studentData[UserFields.firstName]} ${studentData[UserFields.lastName]}';
                      return vertical10Pix(
                          child: ElevatedButton(
                              onPressed: () => assignUserToSection(context, ref,
                                  sectionID: widget.sectionID,
                                  userID: student.id),
                              child: whiteInterBold(teacherName)));
                    }).toList(),
                  ),
                ],
              )),
            ));
  }
}
