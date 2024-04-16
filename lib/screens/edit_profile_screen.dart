import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/utils/color_util.dart';

import '../providers/loading_provider.dart';
import '../utils/future_util.dart';
import '../utils/string_util.dart';
import '../widgets/app_bar_widget.dart';
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
    ref.read(loadingProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBarWidget(mayGoBack: true),
        body: stackedLoadingContainer(
            context,
            ref.read(loadingProvider).isLoading,
            SingleChildScrollView(
              child: all20Pix(
                  child: Column(
                children: [
                  blackInterBold('EDIT PROFILE', fontSize: 35),
                  Gap(30),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: CustomColors.turquoise,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        regularTextField(
                            label: 'First Name',
                            textController: firstNameController),
                        regularTextField(
                            label: 'Last Name',
                            textController: lastNameController),
                      ],
                    ),
                  ),
                  Gap(40),
                  ElevatedButton(
                      onPressed: () => updateProfile(context, ref,
                          firstNameController: firstNameController,
                          lastNameController: lastNameController,
                          userType: userType),
                      child: whiteInterBold('UPDATE PROFILE DETAILS'))
                ],
              )),
            )),
      ),
    );
  }
}
