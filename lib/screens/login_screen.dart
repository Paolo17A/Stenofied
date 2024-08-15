import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/utils/color_util.dart';

import '../providers/loading_provider.dart';
import '../utils/future_util.dart';
import '../utils/string_util.dart';
import '../widgets/custom_button_widgets.dart';
import '../widgets/custom_miscellaneous_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.elliptical(300, 100),
                                  topRight: Radius.elliptical(300, 100))),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          loginFieldsContainer(context, ref,
                              userType: UserTypes.teacher,
                              emailController: emailController,
                              passwordController: passwordController),
                          loginButton(
                              onPress: () => UsersCollectionUtil.logInUser(
                                  context, ref,
                                  emailController: emailController,
                                  passwordController: passwordController)),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
