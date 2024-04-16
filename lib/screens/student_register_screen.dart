import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/utils/string_util.dart';

import '../providers/loading_provider.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_padding_widgets.dart';
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
    return GestureDetector(
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
                  blackInterBold('USER REGISTER', fontSize: 35),
                  authenticationIcon(context, iconData: Icons.person),
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
