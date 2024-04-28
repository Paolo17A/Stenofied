import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/providers/proof_of_enrollment_provider.dart';
import 'package:stenofied/utils/string_util.dart';

import '../providers/loading_provider.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_text_widgets.dart';

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
            appBar: appBarWidget(mayGoBack: true),
            body: stackedLoadingContainer(
              context,
              ref.read(loadingProvider).isLoading,
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(ImagePaths.studentUser, scale: 0.9),
                            blackInterBold('STUDENT', fontSize: 35)
                          ]),
                      const Gap(20),
                      registerFieldsContainer(context, ref,
                          userType: UserTypes.student,
                          emailController: emailController,
                          passwordController: passwordController,
                          confirmPasswordController: confirmPasswordController,
                          firstNameController: firstNameController,
                          lastNameController: lastNameController),
                    ],
                  ))),
            )),
      ),
    );
  }
}
