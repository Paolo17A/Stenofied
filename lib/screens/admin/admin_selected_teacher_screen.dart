import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../providers/loading_provider.dart';
import '../../utils/delete_entry_dialog_util.dart';
import '../../utils/future_util.dart';
import '../../utils/string_util.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/custom_miscellaneous_widgets.dart';
import '../../widgets/custom_padding_widgets.dart';
import '../../widgets/custom_text_widgets.dart';

class AdminSelectedTeacherScreen extends ConsumerStatefulWidget {
  final String userID;
  const AdminSelectedTeacherScreen({super.key, required this.userID});

  @override
  ConsumerState<AdminSelectedTeacherScreen> createState() =>
      _AdminSelectedTeacherScreenState();
}

class _AdminSelectedTeacherScreenState
    extends ConsumerState<AdminSelectedTeacherScreen> {
  String formattedName = '';
  String profileImageURL = '';
  String assignedSectionName = '';
  String proofOfEmployment = '';
  bool accountVerified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final user = await UsersCollectionUtil.getThisUserDoc(widget.userID);
        final userData = user.data() as Map<dynamic, dynamic>;
        formattedName =
            '${userData[UserFields.firstName]} ${userData[UserFields.lastName]}';
        profileImageURL = userData[UserFields.profileImageURL];
        accountVerified = userData[UserFields.accountVerified];
        proofOfEmployment = userData[UserFields.proofOfEnrollment];
        String sectionID = userData[UserFields.sectionID];
        if (sectionID.isNotEmpty) {
          final section =
              await SectionsCollectionUtil.getThisSectionDoc(sectionID);
          final sectionData = section.data() as Map<dynamic, dynamic>;
          assignedSectionName = sectionData[SectionFields.name];
        }
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error getting selected collector data: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      appBar: appBarWidget(mayGoBack: true),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: all20Pix(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    blackAndadaProBold('Professor Profile', fontSize: 40),
                    all10Pix(
                        child: buildProfileImageWidget(
                            profileImageURL: profileImageURL,
                            radius: MediaQuery.of(context).size.width * 0.2)),
                    interText(formattedName, fontSize: 20),
                    interText(
                        'Section: ${assignedSectionName.isNotEmpty ? assignedSectionName : 'N/A'}'),
                    interText(
                        'Account Verified: ${accountVerified ? 'YES' : 'NO'}'),
                    if (!accountVerified)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () =>
                                  UsersCollectionUtil.approveThisUser(
                                      context, ref,
                                      userType: UserTypes.teacher,
                                      userID: widget.userID),
                              child: whiteAndadaProBold('VERIFY\nTEACHER')),
                          ElevatedButton(
                              onPressed: () => displayDeleteEntryDialog(context,
                                  message:
                                      'Are you sure you wish to deny this teacher\'s verification?',
                                  deleteWord: 'Deny',
                                  deleteEntry: () =>
                                      UsersCollectionUtil.denyThisUser(
                                          context, ref,
                                          userType: UserTypes.teacher,
                                          userID: widget.userID)),
                              child: whiteAndadaProBold('DENY\nTEACHER')),
                        ],
                      ),
                    //Divider(color: CustomColors.turquoise),
                    Gap(40),
                    /*Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: CustomColors.turquoise)),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [blackInterBold('COLLECTED LINO HISTORY')],
                      ),
                    )*/
                  ],
                ),
              )),
            ),
          )),
    );
  }
}
