import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/widgets/navigator_rail_widget.dart';

import '../../providers/loading_provider.dart';
import '../../providers/user_data_provider.dart';
import '../../utils/future_util.dart';
import '../../utils/navigator_util.dart';
import '../../utils/string_util.dart';
import '../../widgets/app_drawer_widget.dart';
import '../../widgets/custom_miscellaneous_widgets.dart';
import '../../widgets/custom_padding_widgets.dart';
import '../../widgets/custom_text_widgets.dart';

class StudentProfileScreen extends ConsumerStatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  ConsumerState<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends ConsumerState<StudentProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String formattedName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);

        final userDoc = await UsersCollectionUtil.getCurrentUserDoc();
        final userData = userDoc.data() as Map<dynamic, dynamic>;
        formattedName =
            '${userData[UserFields.firstName]} ${userData[UserFields.lastName]}';
        ref
            .read(userDataProvider)
            .setProfileImage(userData[UserFields.profileImageURL]);
        ref.read(loadingProvider.notifier).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting user profile: $error')));
        ref.read(loadingProvider.notifier).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      key: scaffoldKey,
      drawer: studentAppDrawer(context, ref,
          currentPath: NavigatorRoutes.studentProfile),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              studentRail(context, scaffoldKey,
                  selectedIndex: 4,
                  currentPath: NavigatorRoutes.studentProfile),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: all20Pix(
                    child: Column(
                  children: [
                    buildProfileImageWidget(
                        profileImageURL:
                            ref.read(userDataProvider).profileImageURL,
                        radius: MediaQuery.of(context).size.width * 0.15),
                    all10Pix(
                        child: blackAndadaProBold(formattedName, fontSize: 20)),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(NavigatorRoutes.editProfile),
                        child: whiteAndadaProBold('EDIT PROFILE'))
                  ],
                )),
              ),
            ],
          )),
    );
  }
}
