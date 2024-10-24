import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../providers/loading_provider.dart';
import '../../utils/color_util.dart';
import '../../utils/delete_entry_dialog_util.dart';
import '../../utils/future_util.dart';
import '../../utils/navigator_util.dart';
import '../../utils/string_util.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/custom_miscellaneous_widgets.dart';
import '../../widgets/custom_padding_widgets.dart';
import '../../widgets/custom_text_widgets.dart';

class AdminSelectedStudentScreen extends ConsumerStatefulWidget {
  final String userID;
  const AdminSelectedStudentScreen({super.key, required this.userID});

  @override
  ConsumerState<AdminSelectedStudentScreen> createState() =>
      _AdminStudentUserScreenState();
}

class _AdminStudentUserScreenState
    extends ConsumerState<AdminSelectedStudentScreen> {
  String formattedName = '';
  String profileImageURL = '';
  String proofOfEnrollment = '';
  String assignedSectionName = '';
  bool accountVerified = false;
  List<DocumentSnapshot> exerciseResultDocs = [];
  List<DocumentSnapshot> quizResultDocs = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        final user = await UsersCollectionUtil.getThisUserDoc(widget.userID);
        final userData = user.data() as Map<dynamic, dynamic>;
        formattedName =
            '${userData[UserFields.firstName]} ${userData[UserFields.lastName]}';
        profileImageURL = userData[UserFields.profileImageURL];
        accountVerified = userData[UserFields.accountVerified];
        proofOfEnrollment = userData[UserFields.proofOfEnrollment];
        String sectionID = userData[UserFields.sectionID];
        if (sectionID.isNotEmpty) {
          final section =
              await SectionsCollectionUtil.getThisSectionDoc(sectionID);
          final sectionData = section.data() as Map<dynamic, dynamic>;
          assignedSectionName = sectionData[SectionFields.name];
        }
        //  Get student results
        exerciseResultDocs =
            await ExercisesCollectionUtil.getStudentExerciseResultDocs(
                widget.userID);
        exerciseResultDocs = exerciseResultDocs.where((element) {
          final exerciseResultData = element.data() as Map<dynamic, dynamic>;
          return exerciseResultData[ExerciseResultFields.isGraded];
        }).toList();
        exerciseResultDocs.sort((a, b) {
          final aMap = a.data() as Map<dynamic, dynamic>;
          int aIndex = aMap[ExerciseResultFields.exerciseIndex];
          final bMap = b.data() as Map<dynamic, dynamic>;
          int bIndex = bMap[ExerciseResultFields.exerciseIndex];

          return aIndex.compareTo(bIndex);
        });
        quizResultDocs =
            await QuizzesCollectionUtil.getStudentQuizResultDocs(widget.userID);
        quizResultDocs = quizResultDocs.where((element) {
          final quizResultData = element.data() as Map<dynamic, dynamic>;
          return quizResultData[QuizResultFields.isGraded];
        }).toList();
        quizResultDocs.sort((a, b) {
          final aMap = a.data() as Map<dynamic, dynamic>;
          int aIndex = aMap[QuizResultFields.quizIndex];
          final bMap = b.data() as Map<dynamic, dynamic>;
          int bIndex = bMap[QuizResultFields.quizIndex];

          return aIndex.compareTo(bIndex);
        });
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error getting selected user data: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      appBar: appBarWidget(mayGoBack: true, actions: [
        TextButton(
            onPressed: () => showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(content: Image.network(proofOfEnrollment))),
            child: blackAndadaProRegular('VIEW CERTIFICATE OF\nREGISTRATION',
                textAlign: TextAlign.right))
      ]),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: all20Pix(
                  child: Column(
                children: [
                  _studentProfileDetails(),
                  Divider(color: CustomColors.ketchup),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_exerciseResults(), _quizResults()])
                ],
              )),
            ),
          )),
    );
  }

  Widget _studentProfileDetails() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(12),
      child: Column(children: [
        blackCinzelBold('Student Profile', fontSize: 40),
        all10Pix(
            child: buildProfileImageWidget(
                profileImageURL: profileImageURL,
                radius: MediaQuery.of(context).size.width * 0.2)),
        blackCinzelRegular(formattedName, fontSize: 20),
        blackCinzelRegular(
            'Section: ${assignedSectionName.isNotEmpty ? assignedSectionName : 'N/A'}',
            fontSize: 20),
        interText('Account Verified: ${accountVerified ? 'YES' : 'NO'}'),
        Gap(5),
        if (!accountVerified) _verificationWidgets(),
      ]),
    );
  }

  Widget _verificationWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () => UsersCollectionUtil.approveThisUser(context, ref,
                userType: UserTypes.student, userID: widget.userID),
            child: whiteAndadaProBold('VERIFY\n STUDENT')),
        ElevatedButton(
            onPressed: () => displayDeleteEntryDialog(context,
                message:
                    'Are you sure you wish to deny this student\'s verification?',
                deleteWord: 'Deny',
                deleteEntry: () => UsersCollectionUtil.denyThisUser(
                    context, ref,
                    userType: UserTypes.teacher, userID: widget.userID)),
            child: whiteAndadaProBold('DENY\nSTUDENT')),
      ],
    );
  }

  Widget _exerciseResults() {
    return vertical20Pix(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: CustomColors.ketchup),
      padding: EdgeInsets.all(12),
      child: Column(children: [
        Image.asset(ImagePaths.tropic, height: 100, fit: BoxFit.fill),
        Gap(12),
        whiteAndadaProBold('EXERCISE RESULTS', fontSize: 16),
        exerciseResultDocs.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return exerciseResultEntry(exerciseResultDocs[index]);
                },
                itemCount: exerciseResultDocs.length)
            : vertical20Pix(
                child: whiteAndadaProBold('NO EXERCISE RESULTS AVAILABLE',
                    fontSize: 20))
      ]),
    ));
  }

  Widget _quizResults() {
    return vertical20Pix(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: CustomColors.ketchup),
      padding: EdgeInsets.all(12),
      child: Column(children: [
        Image.asset(ImagePaths.writing, height: 100, fit: BoxFit.fill),
        Gap(12),
        whiteAndadaProBold('QUIZ RESULTS', fontSize: 16),
        quizResultDocs.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return quizResultEntry(quizResultDocs[index]);
                },
                itemCount: quizResultDocs.length)
            : vertical20Pix(
                child: whiteAndadaProBold('NO EXERCISE RESULTS AVAILABLE',
                    fontSize: 20))
      ]),
    ));
  }

  Widget exerciseResultEntry(DocumentSnapshot exerciseResultDoc) {
    final exerciseResultData =
        exerciseResultDoc.data() as Map<dynamic, dynamic>;
    int exerciseIndex = exerciseResultData[ExerciseResultFields.exerciseIndex];
    List<dynamic> exerciseResults =
        exerciseResultData[ExerciseResultFields.exerciseResults];
    num totalAccuracy = 0;
    num averageAccuracy = 0;
    for (var result in exerciseResults) {
      totalAccuracy += result[EntryFields.accuracy];
    }
    averageAccuracy = totalAccuracy / averageAccuracy;
    return InkWell(
      onTap: () => NavigatorRoutes.selectedExerciseResult(context,
          exerciseResultID: exerciseResultDoc.id),
      child: vertical10Pix(
        child: Container(
          color: CustomColors.blush,
          padding: EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whiteAndadaProBold('Exercise: $exerciseIndex'),
              whiteAndadaProRegular(
                  'Average Score: ${(averageAccuracy * 100).toStringAsFixed(2)}')
            ],
          ),
        ),
      ),
    );
  }

  Widget quizResultEntry(DocumentSnapshot quizResultDoc) {
    final quizResultData = quizResultDoc.data() as Map<dynamic, dynamic>;
    int quizIndex = quizResultData[QuizResultFields.quizIndex];
    List<dynamic> quizResults = quizResultData[QuizResultFields.quizResults];
    //int score = 0;
    num totalAccuracy = 0;
    num averageAccuracy = 0;
    for (var result in quizResults) {
      totalAccuracy += result[EntryFields.accuracy];
      //if (result[EntryFields.isCorrect]) score++;
    }
    averageAccuracy = totalAccuracy / quizResults.length;
    return InkWell(
      onTap: () => NavigatorRoutes.selectedQuizResult(context,
          quizResultID: quizResultDoc.id),
      child: vertical10Pix(
        child: Container(
          color: CustomColors.blush,
          padding: EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whiteAndadaProBold('Quiz: $quizIndex'),
              whiteAndadaProRegular(
                  'Average Score: ${(averageAccuracy * 100).toStringAsFixed(2)}')
            ],
          ),
        ),
      ),
    );
  }
}
