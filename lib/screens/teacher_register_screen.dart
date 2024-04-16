import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/providers/proof_of_enrollment_provider.dart';
import 'package:stenofied/utils/string_util.dart';

import '../providers/loading_provider.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_padding_widgets.dart';
import '../widgets/custom_text_widgets.dart';

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
          appBar: appBarWidget(mayGoBack: true),
          body: stackedLoadingContainer(
              context,
              ref.read(loadingProvider).isLoading,
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: all20Pix(
                        child: Column(
                  children: [
                    blackInterBold('COLLECTOR REGISTER', fontSize: 35),
                    authenticationIcon(context, iconData: Icons.person),
                    const Gap(20),
                    registerFieldsContainer(context, ref,
                        userType: UserTypes.teacher,
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
                        firstNameController: firstNameController,
                        lastNameController: lastNameController),
                  ],
                ))),
              )),
        ),
      ),
    );
  }
}
