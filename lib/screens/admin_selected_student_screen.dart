import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../providers/loading_provider.dart';
import '../utils/color_util.dart';
import '../utils/delete_entry_dialog_util.dart';
import '../utils/future_util.dart';
import '../utils/string_util.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_padding_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class AdminSelectedStudentScreen extends ConsumerStatefulWidget {
  final String userID;
  const AdminSelectedStudentScreen({super.key, required this.userID});

  @override
  ConsumerState<AdminSelectedStudentScreen> createState() =>
      _AdminStudentUserScreenState();
}

class _AdminStudentUserScreenState
    extends ConsumerState<AdminSelectedStudentScreen> {
  String formattedName = '';
  String profileImageURL = '';
  String proofOfEnrollment = '';
  String assignedSectionName = '';
  bool accountVerified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final user = await getThisUserDoc(widget.userID);
        final userData = user.data() as Map<dynamic, dynamic>;
        formattedName =
            '${userData[UserFields.firstName]} ${userData[UserFields.lastName]}';
        profileImageURL = userData[UserFields.profileImageURL];
        accountVerified = userData[UserFields.accountVerified];
        proofOfEnrollment = userData[UserFields.proofOfEnrollment];
        String sectionID = userData[UserFields.sectionID];
        if (sectionID.isNotEmpty) {
          final section = await getThisSectionDoc(sectionID);
          final sectionData = section.data() as Map<dynamic, dynamic>;
          assignedSectionName = sectionData[SectionFields.name];
        }
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error getting selected user data: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      appBar: appBarWidget(mayGoBack: true, actions: [
        TextButton(
            onPressed: () => showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(content: Image.network(proofOfEnrollment))),
            child: whiteInterBold('VIEW PROOF OF ENROLLMENT'))
      ]),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: all20Pix(
                  child: Column(
                children: [
                  _studentProfileDetails(),
                  if (!accountVerified) _verificationWidgets(),
                  Divider(color: CustomColors.ketchup),
                  _exerciseResults(),
                  _quizResults()
                ],
              )),
            ),
          )),
    );
  }

  Widget _studentProfileDetails() {
    return Column(children: [
      blackInterBold('Student Profile', fontSize: 40),
      all10Pix(
          child: buildProfileImageWidget(
              profileImageURL: profileImageURL,
              radius: MediaQuery.of(context).size.width * 0.2)),
      interText(formattedName, fontSize: 20),
      interText(
          'Section: ${assignedSectionName.isNotEmpty ? assignedSectionName : 'N/A'}'),
      interText('Account Verified: $accountVerified'),
      Gap(5)
    ]);
  }

  Widget _verificationWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () => approveThisUser(context, ref,
                userType: UserTypes.student, userID: widget.userID),
            child: whiteInterBold('VERIFY\n STUDENT')),
        ElevatedButton(
            onPressed: () => displayDeleteEntryDialog(context,
                message:
                    'Are you sure you wish to deny this student\'s verification?',
                deleteWord: 'Deny',
                deleteEntry: () => denyThisUser(context, ref,
                    userType: UserTypes.teacher, userID: widget.userID)),
            child: whiteInterBold('DENY\nSTUDENT')),
      ],
    );
  }

  Widget _exerciseResults() {
    return vertical10Pix(
      child: Container(
        width: double.infinity,
        color: CustomColors.ketchup,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            whiteInterBold('EXERCISE RESULTS'),
          ],
        ),
      ),
    );
  }

  Widget _quizResults() {
    return Container(
      width: double.infinity,
      color: CustomColors.ketchup,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [whiteInterBold('QUIZ RESULTS')],
      ),
    );
  }
}
