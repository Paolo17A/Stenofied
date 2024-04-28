import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/providers/proof_of_enrollment_provider.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/string_util.dart';

import '../utils/color_util.dart';
import '../utils/navigator_util.dart';
import 'custom_button_widgets.dart';
import 'custom_padding_widgets.dart';
import 'custom_text_field_widget.dart';
import 'custom_text_widgets.dart';

Widget stackedLoadingContainer(
    BuildContext context, bool isLoading, Widget child) {
  return Stack(children: [
    child,
    if (isLoading)
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withOpacity(0.5),
          child: const Center(child: CircularProgressIndicator()))
  ]);
}

Widget switchedLoadingContainer(bool isLoading, Widget child) {
  return isLoading ? const Center(child: CircularProgressIndicator()) : child;
}

Widget authenticationIcon(BuildContext context, {required IconData iconData}) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: CustomColors.ketchup),
      child: Transform.scale(
          scale: 5, child: Icon(iconData, color: Colors.white)));
}

Widget loginFieldsContainer(BuildContext context, WidgetRef ref,
    {required String userType,
    required TextEditingController emailController,
    required TextEditingController passwordController}) {
  return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: CustomColors.ketchup, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(children: [whiteInterBold('Log-In', fontSize: 32)]),
          emailAddressTextField(emailController: emailController),
          passwordTextField(
              label: 'Password', passwordController: passwordController),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            forgotPasswordButton(
                onPress: () => Navigator.of(context)
                    .pushNamed(NavigatorRoutes.forgotPassword))
          ]),
          loginButton(
              onPress: () => logInUser(context, ref,
                  emailController: emailController,
                  passwordController: passwordController)),
          dontHaveAccountButton(
              onPress: () => Navigator.of(context)
                  .pushNamed(NavigatorRoutes.selectUserType))
        ],
      ));
}

Widget registerFieldsContainer(BuildContext context, WidgetRef ref,
    {required String userType,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController}) {
  return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: CustomColors.ketchup, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          emailAddressTextField(emailController: emailController),
          passwordTextField(
              label: 'Password', passwordController: passwordController),
          passwordTextField(
              label: 'Confirm Password',
              passwordController: confirmPasswordController),
          const Gap(20),
          regularTextField(
              label: 'First Name', textController: firstNameController),
          regularTextField(
              label: 'Last Name', textController: lastNameController),
          proofOfEnrollmentUploadWidget(context, ref, userType: userType),
          registerButton(
              onPress: () => registerNewUser(context, ref,
                  userType: userType,
                  emailController: emailController,
                  passwordController: passwordController,
                  confirmPasswordController: confirmPasswordController,
                  firstNameController: firstNameController,
                  lastNameController: lastNameController)),
        ],
      ));
}

Widget emailAddressTextField({required TextEditingController emailController}) {
  return all10Pix(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        whiteInterBold('Email Address', fontSize: 18),
        CustomTextField(
            text: 'Email Address',
            controller: emailController,
            textInputType: TextInputType.emailAddress,
            displayPrefixIcon: const Icon(Icons.email)),
      ],
    ),
  );
}

Widget passwordTextField(
    {required String label,
    required TextEditingController passwordController}) {
  return all10Pix(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      whiteInterBold(label, fontSize: 18),
      CustomTextField(
          text: label,
          controller: passwordController,
          textInputType: TextInputType.visiblePassword,
          displayPrefixIcon: const Icon(Icons.lock)),
    ],
  ));
}

Widget regularTextField(
    {required String label, required TextEditingController textController}) {
  return all10Pix(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      whiteInterBold(label, fontSize: 18),
      CustomTextField(
          text: label,
          controller: textController,
          textInputType: TextInputType.name,
          displayPrefixIcon: null),
    ],
  ));
}

Widget proofOfEnrollmentUploadWidget(BuildContext context, WidgetRef ref,
    {required String userType}) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      children: [
        Row(children: [
          whiteInterBold(
              'Proof of ${userType == UserTypes.student ? 'Enrollment' : 'Employment'}',
              fontSize: 18)
        ]),
        if (ref.read(proofOfEnrollmentProvider).proofOfEnrollmentFile != null)
          Image.file(ref.read(proofOfEnrollmentProvider).proofOfEnrollmentFile!,
              width: MediaQuery.of(context).size.width * 0.3),
        ElevatedButton(
            onPressed: () =>
                ref.read(proofOfEnrollmentProvider).setProofOfEmployment(),
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.parchment),
            child: blackInterBold(
                'UPLOAD PROOF\ OF ${userType == UserTypes.student ? 'ENROLLMENT' : 'EMPLOYMENT'}',
                fontSize: 12))
      ],
    ),
  );
}

Widget welcomeWidgets(
    {required String userType, required String profileImageURL}) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      children: [
        all10Pix(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            buildProfileImageWidget(
                profileImageURL: profileImageURL, radius: 40),
            blackInterBold('WELCOME,\n$userType', fontSize: 28)
          ]),
        ),
      ],
    ),
  );
}

Widget buildProfileImageWidget(
    {required String profileImageURL, double radius = 30}) {
  return Column(children: [
    profileImageURL.isNotEmpty
        ? CircleAvatar(
            radius: radius, backgroundImage: NetworkImage(profileImageURL))
        : CircleAvatar(
            radius: radius,
            backgroundColor: CustomColors.ketchup,
            child: Icon(
              Icons.person,
              size: radius * 1.5,
              color: Colors.white,
            )),
  ]);
}

Widget userRecordEntry(
    {required DocumentSnapshot userDoc,
    required Function onTap,
    bool displayVerificationStatus = false}) {
  final userData = userDoc.data() as Map<dynamic, dynamic>;
  String formattedName =
      '${userData[UserFields.firstName]} ${userData[UserFields.lastName]}';
  String profileImageURL = userData[UserFields.profileImageURL];
  bool adminApproved = userData[UserFields.accountVerified];
  return GestureDetector(
    onTap: () => onTap(),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
            color: CustomColors.blush,
            border: Border.all(color: CustomColors.ketchup, width: 1)),
        height: 60,
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          buildProfileImageWidget(profileImageURL: profileImageURL, radius: 20),
          const Gap(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              blackInterBold(formattedName, fontSize: 16),
              if (displayVerificationStatus)
                blackInterRegular('Account Verified: $adminApproved',
                    fontSize: 12)
            ],
          )
        ]),
      ),
    ),
  );
}

Widget userNameContainer(String formattedName) {
  return vertical20Pix(
    child: SizedBox(
      height: 50,
      child: Center(
        child: all10Pix(
          child: Row(
            children: [interText(formattedName, fontSize: 20)],
          ),
        ),
      ),
    ),
  );
}
