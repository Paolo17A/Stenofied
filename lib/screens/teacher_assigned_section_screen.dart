import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/providers/loading_provider.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/app_bar_widget.dart';
import 'package:stenofied/widgets/app_bottom_nav_bar_widget.dart';
import 'package:stenofied/widgets/app_drawer_widget.dart';
import 'package:stenofied/widgets/custom_miscellaneous_widgets.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';
import 'package:stenofied/widgets/custom_text_widgets.dart';

import '../utils/color_util.dart';

class TeacherAssignedSectionScreen extends ConsumerStatefulWidget {
  const TeacherAssignedSectionScreen({super.key});

  @override
  ConsumerState<TeacherAssignedSectionScreen> createState() =>
      _TeacherAssignedSectionScreenState();
}

class _TeacherAssignedSectionScreenState
    extends ConsumerState<TeacherAssignedSectionScreen> {
  String sectionName = '';
  List<DocumentSnapshot> studentDocs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final user = await getCurrentUserDoc();
        final userData = user.data() as Map<dynamic, dynamic>;

        String sectionID = userData[UserFields.sectionID];
        final section = await getThisSectionDoc(sectionID);
        final sectionData = section.data() as Map<dynamic, dynamic>;
        sectionName = sectionData[SectionFields.name];

        studentDocs = await getSectionStudentDocs(sectionID);
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
      appBar: appBarWidget(mayGoBack: true),
      drawer: appDrawer(context, ref, userType: UserTypes.teacher),
      bottomNavigationBar: teacherBottomNavBar(context,
          path: NavigatorRoutes.teacherAssignedSection),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SingleChildScrollView(
            child: all20Pix(
                child: Column(
              children: [
                blackInterBold(sectionName, fontSize: 26),
                _expandableStudents()
              ],
            )),
          )),
    );
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
        title: whiteInterBold('SECTION STUDENTS', fontSize: 16),
        children: [
          vertical20Pix(
            child: studentDocs.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ListView.builder(
                      shrinkWrap: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: studentDocs.length,
                      itemBuilder: (context, index) => all10Pix(
                        child: userRecordEntry(
                            userDoc: studentDocs[index],
                            onTap: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            blackInterBold(
                                                'TODO: SHOW STUDENT GRADES'),
                                            Gap(50)
                                          ],
                                        ),
                                      ),
                                    ))),
                      ),
                    ))
                : whiteInterBold('NO AVAILABLE STUDENTS', fontSize: 16),
          )
        ],
      ),
    );
  }
}
