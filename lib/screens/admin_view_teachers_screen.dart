import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/utils/future_util.dart';

import '../providers/loading_provider.dart';
import '../utils/color_util.dart';
import '../utils/navigator_util.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_padding_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class AdminViewTeachersScreen extends ConsumerStatefulWidget {
  const AdminViewTeachersScreen({super.key});

  @override
  ConsumerState<AdminViewTeachersScreen> createState() =>
      _AdminViewTeachersScreenState();
}

class _AdminViewTeachersScreenState
    extends ConsumerState<AdminViewTeachersScreen> {
  List<DocumentSnapshot> teacherDocs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        teacherDocs = await getAllTeacherDocs();
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error getting all teacher docs')));
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, NavigatorRoutes.adminHome);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      appBar: appBarWidget(mayGoBack: true),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SingleChildScrollView(
            child: all20Pix(
                child: Column(
              children: [
                blackInterBold('REGISTERED TEACHERS', fontSize: 40),
                studentEntries()
              ],
            )),
          )),
    );
  }

  Widget studentEntries() {
    return Container(
      decoration: BoxDecoration(
          color: CustomColors.ketchup, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: teacherDocs.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: teacherDocs.length,
              itemBuilder: (context, index) {
                return userRecordEntry(
                    userDoc: teacherDocs[index],
                    onTap: () => NavigatorRoutes.adminSelectedTeacher(context,
                        userID: teacherDocs[index].id),
                    displayVerificationStatus: true);
              })
          : all20Pix(
              child: blackInterBold('NO REGISTERED TEACHERS AVAILABLE',
                  fontSize: 25)),
    );
  }
}
