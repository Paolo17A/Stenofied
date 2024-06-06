import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/widgets/navigator_rail_widget.dart';

import '../providers/loading_provider.dart';
import '../providers/user_data_provider.dart';
import '../utils/future_util.dart';
import '../utils/navigator_util.dart';
import '../utils/string_util.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_padding_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class TeacherProfileScreen extends ConsumerStatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  ConsumerState<TeacherProfileScreen> createState() =>
      _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends ConsumerState<TeacherProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String formattedName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);

        final userDoc = await getCurrentUserDoc();
        final userData = userDoc.data() as Map<dynamic, dynamic>;
        formattedName =
            '${userData[UserFields.firstName]} ${userData[UserFields.lastName]}';
        ref
            .read(userDataProvider)
            .setProfileImage(userData[UserFields.profileImageURL]);
        ref.read(loadingProvider.notifier).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting collector profile: $error')));
        ref.read(loadingProvider.notifier).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      key: scaffoldKey,
      drawer: teacherAppDrawer(context, ref,
          currentPath: NavigatorRoutes.teacherProfile),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              teacherRail(context, scaffoldKey,
                  selectedIndex: 3,
                  currentPath: NavigatorRoutes.teacherProfile),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: SingleChildScrollView(
                  child: all20Pix(
                      child: Column(
                    children: [
                      buildProfileImageWidget(
                          profileImageURL:
                              ref.read(userDataProvider).profileImageURL,
                          radius: MediaQuery.of(context).size.width * 0.2),
                      all10Pix(
                          child: blackJosefinSansBold(formattedName,
                              fontSize: 20)),
                      ElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(NavigatorRoutes.editProfile),
                          child: whiteJosefinSansBold('EDIT PROFILE'))
                    ],
                  )),
                ),
              ),
            ],
          )),
    );
  }
}
