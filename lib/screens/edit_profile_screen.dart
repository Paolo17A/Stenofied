import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/utils/color_util.dart';

import '../providers/loading_provider.dart';
import '../providers/user_data_provider.dart';
import '../utils/future_util.dart';
import '../utils/string_util.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_padding_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  String userType = UserTypes.student;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final userDoc = await getCurrentUserDoc();
        final userData = userDoc.data() as Map<dynamic, dynamic>;
        firstNameController.text = userData[UserFields.firstName];
        lastNameController.text = userData[UserFields.lastName];
        userType = userData[UserFields.userType];
        ref
            .read(userDataProvider)
            .setProfileImage(userData[UserFields.profileImageURL]);
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error getting profile details: $error')));
        ref.read(loadingProvider).toggleLoading(false);
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(userDataProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        backgroundColor: CustomColors.ketchup,
        body: stackedLoadingContainer(
            context,
            ref.read(loadingProvider).isLoading,
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(300, 100),
                                topRight: Radius.elliptical(300, 100))),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: all20Pix(
                          child: Column(
                        children: [
                          whiteCinzelBold('EDIT PROFILE', fontSize: 35),
                          vertical20Pix(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  vertical10Pix(
                                      child: Stack(children: [
                                    buildProfileImageWidget(
                                        profileImageURL: ref
                                            .read(userDataProvider)
                                            .profileImageURL,
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.15),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () =>
                                            uploadProfilePicture(context, ref),
                                        child: Container(
                                          width: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(),
                                              shape: BoxShape.circle),
                                          child: Image.asset(ImagePaths.camera,
                                              scale: 35),
                                        ),
                                      ),
                                    )
                                  ])),
                                  /*if (ref
                                      .read(userDataProvider)
                                      .profileImageURL
                                      .isNotEmpty)
                                    ElevatedButton(
                                        onPressed: () =>
                                            removeProfilePicture(context, ref),
                                        child: whiteAndadaProBold(
                                            'REMOVE PROFILE PICTURE')),
                                   ElevatedButton(
                                      onPressed: () =>
                                          uploadProfilePicture(context, ref),
                                      child: whiteInterBold(
                                          'UPLOAD PROFILE PICTURE')),*/
                                  regularTextField(
                                      label: 'First Name',
                                      textController: firstNameController),
                                  regularTextField(
                                      label: 'Last Name',
                                      textController: lastNameController),
                                ],
                              ),
                            ),
                          ),
                          Gap(40),
                          ElevatedButton(
                              onPressed: () => updateProfile(context, ref,
                                  firstNameController: firstNameController,
                                  lastNameController: lastNameController,
                                  userType: userType),
                              child: whiteAndadaProBold('SAVE CHANGES'))
                        ],
                      )),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
