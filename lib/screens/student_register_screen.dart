import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/providers/proof_of_enrollment_provider.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/string_util.dart';

import '../providers/loading_provider.dart';
import '../utils/future_util.dart';
import '../widgets/custom_button_widgets.dart';
import '../widgets/custom_miscellaneous_widgets.dart';

class StudentRegisterScreen extends ConsumerStatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  ConsumerState<StudentRegisterScreen> createState() =>
      _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends ConsumerState<StudentRegisterScreen> {
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
                          proofOfEnrollmentUploadWidget(context, ref,
                              userType: UserTypes.student),
                          registerButton(
                              onPress: () => registerNewUser(context, ref,
                                  userType: UserTypes.student,
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
