import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/providers/proof_of_enrollment_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';

import '../../providers/loading_provider.dart';
import '../../utils/future_util.dart';
import '../../widgets/custom_button_widgets.dart';
import '../../widgets/custom_miscellaneous_widgets.dart';

class TeacherRegisterScreen extends ConsumerStatefulWidget {
  const TeacherRegisterScreen({super.key});

  @override
  ConsumerState<TeacherRegisterScreen> createState() =>
      _TeacherRegisterScreenState();
}

class _TeacherRegisterScreenState extends ConsumerState<TeacherRegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    ref.watch(proofOfEnrollmentProvider);
    return PopScope(
      onPopInvoked: (didPop) =>
          ref.read(proofOfEnrollmentProvider).resetProofOfEmployment(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent),
            backgroundColor: CustomColors.ketchup,
            body: stackedLoadingContainer(
              context,
              ref.read(loadingProvider).isLoading,
              Stack(
                children: [
                  Positioned(
                      bottom: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(300, 100),
                                topRight: Radius.elliptical(300, 100))),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          registerFieldsContainer(context, ref,
                              userType: UserTypes.student,
                              emailController: emailController,
                              passwordController: passwordController,
                              confirmPasswordController:
                                  confirmPasswordController,
                              firstNameController: firstNameController,
                              lastNameController: lastNameController),
                          all20Pix(
                            child: proofOfEnrollmentUploadWidget(context, ref,
                                userType: UserTypes.teacher),
                          ),
                          registerButton(
                              onPress: () =>
                                  UsersCollectionUtil.registerNewUser(
                                      context, ref,
                                      userType: UserTypes.teacher,
                                      emailController: emailController,
                                      passwordController: passwordController,
                                      confirmPasswordController:
                                          confirmPasswordController,
                                      firstNameController: firstNameController,
                                      lastNameController: lastNameController)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
