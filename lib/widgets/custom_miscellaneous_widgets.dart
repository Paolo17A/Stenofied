import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/providers/proof_of_enrollment_provider.dart';
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
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          all10Pix(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 30,
                  decoration: BoxDecoration(
                      color: CustomColors.blush.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.4),
                      InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(NavigatorRoutes.studentRegister),
                          child: blackJosefinSansBold('Sign Up')),
                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        color: CustomColors.ketchup,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: whiteJosefinSansBold('\t\t\tLogin\t\t\t',
                          textAlign: TextAlign.justify, fontSize: 20),
                    )),
              ],
            ),
          ),
          emailAddressTextField(emailController: emailController),
          passwordTextField(
              label: 'Password', passwordController: passwordController),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            forgotPasswordButton(
                onPress: () => Navigator.of(context)
                    .pushNamed(NavigatorRoutes.forgotPassword))
          ]),
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
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(20)),
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
        ],
      ));
}

Widget emailAddressTextField({required TextEditingController emailController}) {
  return all10Pix(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        blackJosefinSansBold('Email Address', fontSize: 18),
        CustomTextField(
            text: 'Email Address',
            fillColor: CustomColors.blush.withOpacity(0.5),
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
      blackJosefinSansBold(label, fontSize: 18),
      CustomTextField(
          text: label,
          controller: passwordController,
          fillColor: CustomColors.blush.withOpacity(0.5),
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
      blackJosefinSansBold(label, fontSize: 18),
      CustomTextField(
          text: label,
          fillColor: CustomColors.blush.withOpacity(0.5),
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
        blackJosefinSansBold('Certificate of Registration', fontSize: 18),
        if (ref.read(proofOfEnrollmentProvider).proofOfEnrollmentFile != null)
          Image.file(ref.read(proofOfEnrollmentProvider).proofOfEnrollmentFile!,
              width: MediaQuery.of(context).size.width * 0.3),
        ElevatedButton(
            onPressed: () =>
                ref.read(proofOfEnrollmentProvider).setProofOfEmployment(),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
            child: whiteJosefinSansBold('UPLOAD HERE', fontSize: 12))
      ],
    ),
  );
}

Widget welcomeWidgets(BuildContext context,
    {required String userType, required String profileImageURL}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.8,
    child: Column(
      children: [
        all10Pix(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            blackJosefinSansBold('WELCOME,\n$userType', fontSize: 28),
            buildProfileImageWidget(
                profileImageURL: profileImageURL, radius: 40),
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
            color: CustomColors.blush, borderRadius: BorderRadius.circular(20)),
        height: 60,
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          buildProfileImageWidget(profileImageURL: profileImageURL, radius: 20),
          const Gap(16),
          Expanded(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                blackAndadaProBold(formattedName, fontSize: 16),
                if (displayVerificationStatus)
                  blackAndadaProRegular(
                      'Account Verified: ${adminApproved == true ? 'YES' : 'NO'}',
                      fontSize: 12)
              ],
            ),
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

Widget snapshotHandler(AsyncSnapshot snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: const CircularProgressIndicator());
  } else if (!snapshot.hasData) {
    return Text('No data found');
  } else if (snapshot.hasError) {
    return Text('Error gettin data: ${snapshot.error.toString()}');
  }
  return Container();
}

Widget safeAreaWithRail(BuildContext context,
    {required Widget railWidget, required Widget mainWidget}) {
  return SafeArea(
      child: Row(children: [
    railWidget,
    SizedBox(width: MediaQuery.of(context).size.width - 50, child: mainWidget)
  ]));
}
