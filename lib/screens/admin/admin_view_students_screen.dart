import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:stenofied/utils/future_util.dart';
import 'package:stenofied/utils/string_util.dart';
import 'package:stenofied/widgets/custom_text_field_widget.dart';

import '../../providers/loading_provider.dart';
import '../../utils/navigator_util.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/custom_miscellaneous_widgets.dart';
import '../../widgets/custom_padding_widgets.dart';
import '../../widgets/custom_text_widgets.dart';

class AdminViewStudentsScreen extends ConsumerStatefulWidget {
  const AdminViewStudentsScreen({super.key});

  @override
  ConsumerState<AdminViewStudentsScreen> createState() =>
      _AdminViewStudentsScreenState();
}

class _AdminViewStudentsScreenState
    extends ConsumerState<AdminViewStudentsScreen> {
  List<DocumentSnapshot> studentDocs = [];
  List<DocumentSnapshot> filteredStudentDocs = [];

  final searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      String lowerCasedSearchInput = searchController.text.trim().toLowerCase();
      setState(() {
        filteredStudentDocs = studentDocs.where((student) {
          final studentData = student.data() as Map<dynamic, dynamic>;
          String firstName =
              studentData[UserFields.firstName].toString().toLowerCase();
          String lastName =
              studentData[UserFields.lastName].toString().toLowerCase();

          return firstName.contains(lowerCasedSearchInput) ||
              lastName.contains(lowerCasedSearchInput);
        }).toList();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        ref.read(loadingProvider).toggleLoading(true);
        studentDocs = await UsersCollectionUtil.getAllStudentDocs();
        filteredStudentDocs = studentDocs;
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBarWidget(mayGoBack: true),
        body: switchedLoadingContainer(
            ref.read(loadingProvider).isLoading,
            SingleChildScrollView(
              child: all20Pix(
                  child: Column(
                children: [
                  blackCinzelBold('REGISTERED STUDENTS', fontSize: 32),
                  CustomTextField(
                      text: 'Search for a student...',
                      controller: searchController,
                      textInputType: TextInputType.text,
                      displayPrefixIcon: Icon(Icons.search)),
                  Gap(20),
                  studentEntries()
                ],
              )),
            )),
      ),
    );
  }

  Widget studentEntries() {
    return filteredStudentDocs.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: filteredStudentDocs.length,
            itemBuilder: (context, index) {
              return userRecordEntry(
                  userDoc: filteredStudentDocs[index],
                  onTap: () => NavigatorRoutes.adminSelectedStudent(context,
                      userID: filteredStudentDocs[index].id),
                  displayVerificationStatus: true);
            })
        : all20Pix(
            child: blackAndadaProBold('NO STUDENTS FOUND', fontSize: 25));
  }
}
