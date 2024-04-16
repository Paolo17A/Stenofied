import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/utils/color_util.dart';
import 'package:stenofied/utils/future_util.dart';

import '../providers/loading_provider.dart';
import '../utils/navigator_util.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_padding_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class AdminViewStudentsScreen extends ConsumerStatefulWidget {
  const AdminViewStudentsScreen({super.key});

  @override
  ConsumerState<AdminViewStudentsScreen> createState() =>
      _AdminViewStudentsScreenState();
}

class _AdminViewStudentsScreenState
    extends ConsumerState<AdminViewStudentsScreen> {
  List<DocumentSnapshot> studentDocs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        studentDocs = await getAllStudentDocs();
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error getting all user docs')));
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
                blackInterBold('REGISTERED STUDENTS', fontSize: 40),
                Divider(color: CustomColors.turquoise),
                studentEntries()
              ],
            )),
          )),
    );
  }

  Widget studentEntries() {
    return studentDocs.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: studentDocs.length,
            itemBuilder: (context, index) {
              return userRecordEntry(userDoc: studentDocs[index], onTap: () {});
            })
        : all20Pix(
            child: blackInterBold('NO REGISTERED STUDENTS AVAILABLE',
                fontSize: 25));
  }
}
