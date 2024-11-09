// ignore_for_file: unnecessary_cast

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stenofied/models/tracing_model.dart';
import 'package:stenofied/providers/current_exercise_provider.dart';
import 'package:stenofied/providers/current_quiz_provider.dart';
import 'package:stenofied/providers/notes_provider.dart';
import 'package:stenofied/providers/proof_of_enrollment_provider.dart';
import 'package:stenofied/providers/sections_provider.dart';

import '../providers/loading_provider.dart';
import '../providers/user_data_provider.dart';
import 'navigator_util.dart';
import 'string_util.dart';

//==============================================================================
//USERS=========================================================================
//==============================================================================
class UsersCollectionUtil {
  static bool hasLoggedInUser() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static Future registerNewUser(BuildContext context, WidgetRef ref,
      {required String userType,
      required TextEditingController emailController,
      required TextEditingController passwordController,
      required TextEditingController confirmPasswordController,
      required TextEditingController firstNameController,
      required TextEditingController lastNameController}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty ||
          firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty) {
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Please fill up all given fields.')));
        return;
      }
      if (!emailController.text.contains('@') ||
          !emailController.text.contains('.com')) {
        scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text('Please input a valid email address')));
        return;
      }
      if (passwordController.text != confirmPasswordController.text) {
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('The passwords do not match')));
        return;
      }
      if (passwordController.text.length < 6) {
        scaffoldMessenger.showSnackBar(const SnackBar(
            content:
                Text('The password must be at least six characters long')));
        return;
      }

      if (ref.read(proofOfEnrollmentProvider).proofOfEnrollmentFile == null) {
        scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text('Please upload a proof of enrollment image.')));
        return;
      }
      //  Create user with Firebase Auth
      ref.read(loadingProvider.notifier).toggleLoading(true);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text);

      //  Create new document is Firestore database
      await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        UserFields.email: emailController.text.trim(),
        UserFields.password: passwordController.text,
        UserFields.firstName: firstNameController.text.trim(),
        UserFields.lastName: lastNameController.text.trim(),
        UserFields.userType: userType,
        UserFields.profileImageURL: '',
        UserFields.sectionID: '',
        UserFields.accountVerified: false,
        UserFields.currentLessonIndex: 1,
      });

      //  Upload proof of employment to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child(StorageFields.proofOfEnrollments)
          .child(FirebaseAuth.instance.currentUser!.uid);
      final uploadTask = storageRef
          .putFile(ref.read(proofOfEnrollmentProvider).proofOfEnrollmentFile!);
      final taskSnapshot = await uploadTask;
      final String downloadURL = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        UserFields.proofOfEnrollment: downloadURL,
      });

      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Successfully registered new user.')));
      await FirebaseAuth.instance.signOut();
      ref.read(proofOfEnrollmentProvider).resetProofOfEmployment();

      ref.read(loadingProvider.notifier).toggleLoading(false);

      navigator.pushReplacementNamed(NavigatorRoutes.login);
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error registering new user: $error')));
      ref.read(loadingProvider.notifier).toggleLoading(false);
    }
  }

  static Future logInUser(BuildContext context, WidgetRef ref,
      {required TextEditingController emailController,
      required TextEditingController passwordController}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Please fill up all given fields.')));
        return;
      }
      FocusScope.of(context).unfocus();
      ref.read(loadingProvider.notifier).toggleLoading(true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      final userDoc = await getCurrentUserDoc();
      final userData = userDoc.data() as Map<dynamic, dynamic>;

      //  reset the password in firebase in case client reset it using an email link.
      if (userData[UserFields.password] != passwordController.text) {
        await FirebaseFirestore.instance
            .collection(Collections.users)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({UserFields.password: passwordController.text});
      }

      if (userData[UserFields.accountVerified] == false) {
        scaffoldMessenger.showSnackBar(SnackBar(
            content:
                Text('Your account has not yet been verified by the admin.')));
        ref.read(loadingProvider.notifier).toggleLoading(false);
        return;
      }

      if (userData[UserFields.sectionID].toString().isEmpty) {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(
                'Your have not yet been assigned to a section by the admin.')));
        ref.read(loadingProvider.notifier).toggleLoading(false);
        return;
      }
      ref.read(loadingProvider.notifier).toggleLoading(false);
      ref
          .read(userDataProvider)
          .setProfileImage(userData[UserFields.profileImageURL]);
      ref.read(userDataProvider).setUserType(userData[UserFields.userType]);
      emailController.clear();
      passwordController.clear();
      if (userData[UserFields.userType] == UserTypes.student) {
        ref.read(userDataProvider).setSectionID(userData[UserFields.sectionID]);

        ref
            .read(userDataProvider)
            .setLessonIndex(userData[UserFields.currentLessonIndex]);
        navigator.pushNamed(NavigatorRoutes.studentHome);
      } else if (userData[UserFields.userType] == UserTypes.teacher) {
        ref.read(userDataProvider).setSectionID(userData[UserFields.sectionID]);
        navigator.pushNamed(NavigatorRoutes.teacherHome);
      }
      if (userData[UserFields.userType] == UserTypes.admin) {
        navigator.pushNamed(NavigatorRoutes.adminHome);
      }
    } catch (error) {
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text('Error logging in: $error')));
      ref.read(loadingProvider.notifier).toggleLoading(false);
    }
  }

  static Future sendResetPasswordEmail(BuildContext context, WidgetRef ref,
      {required TextEditingController emailController}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    if (!emailController.text.contains('@') ||
        !emailController.text.contains('.com')) {
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Please input a valid email address.')));
      return;
    }
    try {
      ref.read(loadingProvider.notifier).toggleLoading(true);
      final filteredUsers = await FirebaseFirestore.instance
          .collection(Collections.users)
          .where(UserFields.email, isEqualTo: emailController.text.trim())
          .get();

      if (filteredUsers.docs.isEmpty) {
        scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text('There is no user with that email address.')));
        ref.read(loadingProvider.notifier).toggleLoading(false);
        return;
      }
      if (filteredUsers.docs.first.data()[UserFields.userType] ==
          UserTypes.admin) {
        scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text('This feature is for users and collectors only.')));
        ref.read(loadingProvider.notifier).toggleLoading(false);
        return;
      }
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      ref.read(loadingProvider.notifier).toggleLoading(false);
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Successfully sent password reset email!')));
      navigator.pop();
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content: Text('Error sending password reset email: $error')));
      ref.read(loadingProvider.notifier).toggleLoading(false);
    }
  }

  static Future approveThisUser(BuildContext context, WidgetRef ref,
      {required String userID, required String userType}) async {
    try {
      ref.read(loadingProvider).toggleLoading(true);
      FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(userID)
          .update({UserFields.accountVerified: true});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully approved this user.')));
      Navigator.of(context).pop();
      if (userType == UserTypes.student) {
        Navigator.of(context)
            .pushReplacementNamed(NavigatorRoutes.adminViewStudents);
      } else if (userType == UserTypes.teacher) {
        Navigator.of(context)
            .pushReplacementNamed(NavigatorRoutes.adminViewTeachers);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error approving this user: $error')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }

  static Future denyThisUser(BuildContext context, WidgetRef ref,
      {required String userID, required String userType}) async {
    try {
      ref.read(loadingProvider).toggleLoading(true);

      //  Store admin's current data locally then sign out
      final currentUser = await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final currentUserData = currentUser.data() as Map<dynamic, dynamic>;
      String userEmail = currentUserData[UserFields.email];
      String userPassword = currentUserData[UserFields.password];
      await FirebaseAuth.instance.signOut();

      //  Log-in to the collector account to be deleted
      final collector = await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(userID)
          .get();
      final collectorData = collector.data() as Map<dynamic, dynamic>;
      String collectorEmail = collectorData[UserFields.email];
      String collectorPassword = collectorData[UserFields.password];
      final collectorToDelete = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: collectorEmail, password: collectorPassword);
      await collectorToDelete.user!.delete();

      //  Log-back in to admin account
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);

      //  Delete collector entry from Firebase Storage
      await FirebaseStorage.instance
          .ref()
          .child(StorageFields.proofOfEnrollments)
          .child(userID)
          .delete();

      //  Delete collector document from users Firestore collection
      await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(userID)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully denied this collector.')));
      Navigator.of(context).pop();
      if (userType == UserTypes.student) {
        Navigator.of(context)
            .pushReplacementNamed(NavigatorRoutes.adminViewStudents);
      } else if (userType == UserTypes.teacher) {
        Navigator.of(context)
            .pushReplacementNamed(NavigatorRoutes.adminViewTeachers);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error denying this collector: $error')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }

  static Future uploadProfilePicture(
      BuildContext context, WidgetRef ref) async {
    try {
      ImagePicker imagePicker = ImagePicker();
      final selectedXFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (selectedXFile == null) {
        return;
      }
      //  Upload proof of employment to Firebase Storage
      ref.read(loadingProvider).toggleLoading(true);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child(StorageFields.profilePics)
          .child(FirebaseAuth.instance.currentUser!.uid);
      final uploadTask = storageRef.putFile(File(selectedXFile.path));
      final taskSnapshot = await uploadTask;
      final String downloadURL = await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({UserFields.profileImageURL: downloadURL});
      ref.read(userDataProvider).setProfileImage(downloadURL);
      ref.read(loadingProvider).toggleLoading(false);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error uploading new profile picture: $error')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }

  static Future removeProfilePicture(
      BuildContext context, WidgetRef ref) async {
    try {
      //  Remove profile pic from cloud storage
      ref.read(loadingProvider).toggleLoading(true);
      await FirebaseStorage.instance
          .ref()
          .child(StorageFields.profilePics)
          .child(FirebaseAuth.instance.currentUser!.uid)
          .delete();

      //Set profileImageURL paramter to ''
      await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({UserFields.profileImageURL: ''});
      ref.read(userDataProvider).setProfileImage('');
      ref.read(loadingProvider).toggleLoading(false);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error uploading new profile picture: $error')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }

  static Future updateProfile(BuildContext context, WidgetRef ref,
      {required TextEditingController firstNameController,
      required TextEditingController lastNameController,
      required String userType}) async {
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill up all given fields.')));
      return;
    }
    try {
      ref.read(loadingProvider).toggleLoading(true);
      await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        UserFields.firstName: firstNameController.text.trim(),
        UserFields.lastName: lastNameController.text.trim()
      });
      ref.read(loadingProvider).toggleLoading(false);
      Navigator.of(context).pop();
      if (userType == UserTypes.student) {
        Navigator.of(context).pushReplacementNamed(NavigatorRoutes.studentHome);
      } else if (userType == UserTypes.teacher) {
        Navigator.of(context).pushReplacementNamed(NavigatorRoutes.teacherHome);
      } else if (userType == UserTypes.admin) {
        Navigator.of(context).pushReplacementNamed(NavigatorRoutes.adminHome);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error updating profile: ${error.toString()}')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }

  static Future<DocumentSnapshot> getCurrentUserDoc() async {
    return await getThisUserDoc(FirebaseAuth.instance.currentUser!.uid);
  }

  static Future<String> getCurrentUserType() async {
    final userDoc = await getCurrentUserDoc();
    final userData = userDoc.data() as Map<dynamic, dynamic>;
    return userData[UserFields.userType];
  }

  static Future<DocumentSnapshot> getThisUserDoc(String userID) async {
    return await FirebaseFirestore.instance
        .collection(Collections.users)
        .doc(userID)
        .get();
  }

  static Future<List<DocumentSnapshot>> getAllStudentDocs() async {
    final users = await FirebaseFirestore.instance
        .collection(Collections.users)
        .where(UserFields.userType, isEqualTo: UserTypes.student)
        .get();
    return users.docs.map((user) => user as DocumentSnapshot).toList();
  }

  static Future<List<DocumentSnapshot>> getAllTeacherDocs() async {
    final users = await FirebaseFirestore.instance
        .collection(Collections.users)
        .where(UserFields.userType, isEqualTo: UserTypes.teacher)
        .get();
    return users.docs.map((user) => user as DocumentSnapshot).toList();
  }

  static Future<List<DocumentSnapshot>> getSectionStudentDocs(
      String sectionID) async {
    final students = await FirebaseFirestore.instance
        .collection(Collections.users)
        .where(UserFields.userType, isEqualTo: UserTypes.student)
        .where(UserFields.sectionID, isEqualTo: sectionID)
        .get();
    return students.docs.map((student) => student as DocumentSnapshot).toList();
  }

  static Future<List<DocumentSnapshot>> getSectionTeacherDoc(
      String sectionID) async {
    final teachers = await FirebaseFirestore.instance
        .collection(Collections.users)
        .where(UserFields.userType, isEqualTo: UserTypes.teacher)
        .where(UserFields.sectionID, isEqualTo: sectionID)
        .get();
    return teachers.docs.map((teacher) => teacher as DocumentSnapshot).toList();
  }

  static Future<List<DocumentSnapshot>> getStudentsWithNoSectionDocs() async {
    final students = await FirebaseFirestore.instance
        .collection(Collections.users)
        .where(UserFields.userType, isEqualTo: UserTypes.student)
        .where(UserFields.sectionID, isEqualTo: '')
        .get();
    return students.docs.map((student) => student as DocumentSnapshot).toList();
  }

  static Future<List<DocumentSnapshot>> getAvailableTeacherDocs() async {
    final teachers = await FirebaseFirestore.instance
        .collection(Collections.users)
        .where(UserFields.userType, isEqualTo: UserTypes.teacher)
        .where(UserFields.sectionID, isEqualTo: '')
        .get();
    return teachers.docs.map((student) => student as DocumentSnapshot).toList();
  }
}

//==============================================================================
//SECTIONS======================================================================
//==============================================================================
class SectionsCollectionUtil {
  static Future<List<DocumentSnapshot>> getAllSectionDocs() async {
    final sections =
        await FirebaseFirestore.instance.collection(Collections.sections).get();
    return sections.docs.map((user) => user as DocumentSnapshot).toList();
  }

  static Future<DocumentSnapshot> getThisSectionDoc(String sectionID) async {
    return await FirebaseFirestore.instance
        .collection(Collections.sections)
        .doc(sectionID)
        .get();
  }

  static Future addNewSection(BuildContext context, WidgetRef ref,
      {required TextEditingController nameController}) async {
    if (nameController.text.isEmpty || nameController.text.trim().length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Please input a valid section name that is at least two characters long')));
      return;
    }
    try {
      ref.read(loadingProvider).toggleLoading(true);
      await FirebaseFirestore.instance.collection(Collections.sections).add({
        SectionFields.name: nameController.text.trim(),
        SectionFields.teacherIDs: [],
        SectionFields.studentIDs: []
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully added new section.')));
      ref.read(loadingProvider).toggleLoading(false);
      Navigator.of(context).pop();
      Navigator.of(context)
          .pushReplacementNamed(NavigatorRoutes.adminViewSections);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding new section: $error')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }

  static Future editThisSection(BuildContext context, WidgetRef ref,
      {required String sectionID,
      required TextEditingController nameController}) async {
    if (nameController.text.isEmpty || nameController.text.trim().length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Please input a valid section name that is at least two characters long')));
      return;
    }
    try {
      ref.read(loadingProvider).toggleLoading(true);
      await FirebaseFirestore.instance
          .collection(Collections.sections)
          .doc(sectionID)
          .update({SectionFields.name: nameController.text.trim()});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully edited this section.')));
      ref.read(sectionsProvider).setSectionDocs(await getAllSectionDocs());
      ref.read(loadingProvider).toggleLoading(false);
      Navigator.of(context).pop();
      NavigatorRoutes.adminSelectedSection(context, sectionID: sectionID);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error editing this section: $error')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }

  static Future assignUserToSection(BuildContext context, WidgetRef ref,
      {required String sectionID, required userID}) async {
    try {
      ref.read(loadingProvider).toggleLoading(true);

      List<DocumentSnapshot> sectionTeacher =
          await UsersCollectionUtil.getSectionTeacherDoc(sectionID);
      if (sectionTeacher.isNotEmpty) {
        final oldTeacherID = sectionTeacher.first.id;
        await FirebaseFirestore.instance
            .collection(Collections.users)
            .doc(oldTeacherID)
            .update({UserFields.sectionID: ''});
      }
      await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(userID)
          .update({UserFields.sectionID: sectionID});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Successfully assigned user to this section')));
      Navigator.of(context).pop();
      NavigatorRoutes.adminSelectedSection(context,
          sectionID: sectionID, isReplacing: true);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error assigning user to section: $error')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }
}

//==============================================================================
//EXERCISES=====================================================================
//==============================================================================

class ExercisesCollectionUtil {
  static Future submitNewExerciseResult(BuildContext context, WidgetRef ref,
      {required Duration elapsedTime}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      ref.read(loadingProvider).toggleLoading(true);
      final resultReference = await FirebaseFirestore.instance
          .collection(Collections.exerciseResults)
          .add({
        ExerciseResultFields.studentID: FirebaseAuth.instance.currentUser!.uid,
        ExerciseResultFields.exerciseIndex: ref
            .read(currentExerciseProvider)
            .currentExerciseModel!
            .exerciseIndex,
        ExerciseResultFields.isGraded: false,
        ExerciseResultFields.dateAnswered: DateTime.now(),
        ExerciseResultFields.elapsedTime: {
          'hours': elapsedTime.inHours,
          'minutes': elapsedTime.inMinutes % 60,
          'seconds': elapsedTime.inSeconds % 60
        }
      });

      List<Map<dynamic, dynamic>> exerciseResults = [];
      for (var traceImage
          in ref.read(currentExerciseProvider).traceOutputList) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child(StorageFields.exerciseImages)
            .child(resultReference.id)
            .child('${generateRandomHexString(6)}.png');
        final uploadTask = storageRef.putData(traceImage!);
        final taskSnapshot = await uploadTask;
        final String downloadURL = await taskSnapshot.ref.getDownloadURL();
        exerciseResults.add({
          EntryFields.accuracy: 0,
          EntryFields.imageURL: downloadURL,
          EntryFields.feedback: ''
        });
      }

      await FirebaseFirestore.instance
          .collection(Collections.exerciseResults)
          .doc(resultReference.id)
          .update({ExerciseResultFields.exerciseResults: exerciseResults});
      scaffoldMessenger.showSnackBar(SnackBar(
          content: Text('Successfully submitted this tracing exercise')));

      navigator.pop();
      navigator.pushReplacementNamed(NavigatorRoutes.studentExercises);
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error submitting this exercise: $error')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }

  static Future<DocumentSnapshot> getExerciseResultDoc(
      String exerciseResultID) async {
    return await FirebaseFirestore.instance
        .collection(Collections.exerciseResults)
        .doc(exerciseResultID)
        .get();
  }

  static Future<List<DocumentSnapshot>> getStudentExerciseResultDocs(
      String userID) async {
    final results = await FirebaseFirestore.instance
        .collection(Collections.exerciseResults)
        .where(ExerciseResultFields.studentID, isEqualTo: userID)
        .get();
    return results.docs.map((e) => e as DocumentSnapshot).toList();
  }

  static Future<List<DocumentSnapshot>> getUserExerciseResultDocs() async {
    return getStudentExerciseResultDocs(FirebaseAuth.instance.currentUser!.uid);
  }

  static Future gradeExerciseOutput(BuildContext context, WidgetRef ref,
      {required String exerciseResultID,
      required List<dynamic> exerciseResults}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      ref.read(loadingProvider).toggleLoading(true);
      await FirebaseFirestore.instance
          .collection(Collections.exerciseResults)
          .doc(exerciseResultID)
          .update({
        ExerciseResultFields.exerciseResults: exerciseResults,
        ExerciseResultFields.isGraded: true
      });
      scaffoldMessenger.showSnackBar(SnackBar(
          content: Text('Successfully graded this exercise submission.')));
      navigator.pop();
      navigator.pushReplacementNamed(NavigatorRoutes.teacherHome);
      ref.read(loadingProvider).toggleLoading(false);
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content: Text('Error grading this exercise output: $error')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }

  static Future<List<DocumentSnapshot>> getUngradedExerciseSubmissionsInSection(
      List<String> studentIDs) async {
    final exerciseResults = await FirebaseFirestore.instance
        .collection(Collections.exerciseResults)
        .where(ExerciseResultFields.studentID, whereIn: studentIDs)
        .where(ExerciseResultFields.isGraded, isEqualTo: false)
        .get();
    return exerciseResults.docs.map((e) => e as DocumentSnapshot).toList();
  }

  static Future retakeThisExercise(BuildContext context, WidgetRef ref,
      {required String exerciseResultID, required int exerciseIndex}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      ref.read(loadingProvider).toggleLoading(true);
      final images = await FirebaseStorage.instance
          .ref()
          .child(StorageFields.exerciseImages)
          .child(exerciseResultID)
          .listAll();
      for (var image in images.items) {
        await image.delete();
      }
      await FirebaseFirestore.instance
          .collection(Collections.exerciseResults)
          .doc(exerciseResultID)
          .delete();
      scaffoldMessenger.showSnackBar(SnackBar(
          content: Text('Successfully deleted existing exercise submission')));
      ref.read(currentExerciseProvider).resetExerciseProvider();
      ref.read(currentExerciseProvider).setExerciseModel(allExerciseModels
          .where((element) => element.exerciseIndex == exerciseIndex)
          .first);
      navigator.pop();
      navigator.pushReplacementNamed(NavigatorRoutes.studentExercises);
      navigator.pushNamed(NavigatorRoutes.studentTakeExercise);
      ref.read(loadingProvider).toggleLoading(false);
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content:
              Text('error deleting existing exercise submission: $error')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }
}

//==============================================================================
//QUIZZES=======================================================================
//==============================================================================

class QuizzesCollectionUtil {
  static Future<List<DocumentSnapshot>> getStudentQuizResultDocs(
      String userID) async {
    final results = await FirebaseFirestore.instance
        .collection(Collections.quizResults)
        .where(QuizResultFields.studentID, isEqualTo: userID)
        .get();
    return results.docs.map((e) => e as DocumentSnapshot).toList();
  }

  static Future<List<DocumentSnapshot>> getUserQuizResultDocs() async {
    return getStudentQuizResultDocs(FirebaseAuth.instance.currentUser!.uid);
  }

  static Future submitNewQuizResult(BuildContext context, WidgetRef ref,
      {required Duration elapsedTime}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      ref.read(loadingProvider).toggleLoading(true);
      final resultReference = await FirebaseFirestore.instance
          .collection(Collections.quizResults)
          .add({
        QuizResultFields.studentID: FirebaseAuth.instance.currentUser!.uid,
        QuizResultFields.quizIndex:
            ref.read(currentQuizProvider).currentQuizModel!.quizIndex,
        QuizResultFields.isGraded: false,
        QuizResultFields.dateAnswered: DateTime.now(),
        QuizResultFields.elapsedTime: {
          'hours': elapsedTime.inHours,
          'minutes': elapsedTime.inMinutes % 60,
          'seconds': elapsedTime.inSeconds % 60
        }
      });

      List<Map<dynamic, dynamic>> quizResults = [];
      for (var doodleImage in ref.read(currentQuizProvider).doodleOutputList) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child(StorageFields.quizImages)
            .child(resultReference.id)
            .child('${generateRandomHexString(6)}.png');
        final uploadTask = storageRef.putData(doodleImage!);
        final taskSnapshot = await uploadTask;
        final String downloadURL = await taskSnapshot.ref.getDownloadURL();
        quizResults.add({
          EntryFields.accuracy: 0,
          EntryFields.imageURL: downloadURL,
          EntryFields.feedback: ''
        });
      }

      await FirebaseFirestore.instance
          .collection(Collections.quizResults)
          .doc(resultReference.id)
          .update({QuizResultFields.quizResults: quizResults});
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Successfully submitted this quiz.')));

      navigator.pop();
      navigator.pushReplacementNamed(NavigatorRoutes.studentQuizzes);
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error submitting this quiz: $error')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }

  static Future<DocumentSnapshot> getQuizResultDoc(String quizResultID) async {
    return await FirebaseFirestore.instance
        .collection(Collections.quizResults)
        .doc(quizResultID)
        .get();
  }

  static Future<List<DocumentSnapshot>> getUngradedQuizSubmissionsInSection(
      List<String> studentIDs) async {
    final quizResults = await FirebaseFirestore.instance
        .collection(Collections.quizResults)
        .where(QuizResultFields.studentID, whereIn: studentIDs)
        .where(QuizResultFields.isGraded, isEqualTo: false)
        .get();
    return quizResults.docs.map((e) => e as DocumentSnapshot).toList();
  }

  static Future gradeQuizOutput(BuildContext context, WidgetRef ref,
      {required String studentID,
      required String quizResultID,
      required List<dynamic> quizResults}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      ref.read(loadingProvider).toggleLoading(true);
      await FirebaseFirestore.instance
          .collection(Collections.quizResults)
          .doc(quizResultID)
          .update({
        QuizResultFields.quizResults: quizResults,
        QuizResultFields.isGraded: true
      });
      await FirebaseFirestore.instance
          .collection(Collections.users)
          .doc(studentID)
          .update({UserFields.currentLessonIndex: FieldValue.increment(1)});
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Successfully graded this quiz submission.')));
      navigator.pop();
      navigator.pushReplacementNamed(NavigatorRoutes.teacherHome);
      ref.read(loadingProvider).toggleLoading(false);
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error grading this quiz output: $error')));
      ref.read(loadingProvider).toggleLoading(false);
    }
  }
}

//==============================================================================
//NOTES=========================================================================
//==============================================================================
class NotesCollectionUtil {
  static Future<List<DocumentSnapshot>> getCurrentUserNotes() {
    return getAllStudentNotes(FirebaseAuth.instance.currentUser!.uid);
  }

  static Future<List<DocumentSnapshot>> getAllStudentNotes(
      String studentID) async {
    final notes = await FirebaseFirestore.instance
        .collection(Collections.notes)
        .where(NotesFields.studentID, isEqualTo: studentID)
        .get();
    return notes.docs;
  }

  static Future<DocumentSnapshot> getThisNote(String noteID) async {
    return await FirebaseFirestore.instance
        .collection(Collections.notes)
        .doc(noteID)
        .get();
  }

  static Future addNote(BuildContext context, WidgetRef ref,
      {required String title, required String content}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    if (title.isEmpty || content.isEmpty) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Please provide a title and content.')));
      return;
    }
    try {
      ref.read(loadingProvider).toggleLoading(true);
      await FirebaseFirestore.instance.collection(Collections.notes).add({
        NotesFields.title: title,
        NotesFields.content: content,
        NotesFields.dateCreated: DateTime.now(),
        NotesFields.dateModified: DateTime.now(),
        NotesFields.studentID: FirebaseAuth.instance.currentUser!.uid
      });
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Successfully created new note.')));
      ref.read(loadingProvider).toggleLoading(false);
      navigator.pop();
      navigator.pushReplacementNamed(NavigatorRoutes.studentNotes);
    } catch (error) {
      ref.read(loadingProvider).toggleLoading(false);
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error adding new note: $error')));
    }
  }

  static Future editThisNote(BuildContext context, WidgetRef ref,
      {required String noteID,
      required String title,
      required String content}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      ref.read(loadingProvider).toggleLoading(true);
      await FirebaseFirestore.instance
          .collection(Collections.notes)
          .doc(noteID)
          .update({
        NotesFields.title: title,
        NotesFields.content: content,
        NotesFields.dateModified: DateTime.now()
      });
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Successfully edited this note.')));
      ref.read(loadingProvider).toggleLoading(false);
      navigator.pop();
      navigator.pushReplacementNamed(NavigatorRoutes.studentNotes);
    } catch (error) {
      ref.read(loadingProvider).toggleLoading(false);
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error editing this note: $error')));
    }
  }

  static Future deleteThisNote(BuildContext context, WidgetRef ref,
      {required String noteID}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      ref.read(loadingProvider).toggleLoading(true);
      await FirebaseFirestore.instance
          .collection(Collections.notes)
          .doc(noteID)
          .delete();
      ref.read(notesProvider).setNotesDocs(await getCurrentUserNotes());
      ref.read(loadingProvider).toggleLoading(false);
    } catch (error) {
      ref.read(loadingProvider).toggleLoading(false);
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error deleting this note: $error')));
    }
  }
}
