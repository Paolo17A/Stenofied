import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/loading_provider.dart';
import '../providers/user_data_provider.dart';
import '../utils/future_util.dart';
import '../utils/navigator_util.dart';
import '../utils/string_util.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_padding_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class StudentProfileScreen extends ConsumerStatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  ConsumerState<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends ConsumerState<StudentProfileScreen> {
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
            SnackBar(content: Text('Error getting user profile: $error')));
        ref.read(loadingProvider.notifier).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      appBar: appBarWidget(mayGoBack: true, actions: [
        IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(NavigatorRoutes.editProfile),
            icon: Icon(Icons.edit))
      ]),
      drawer: appDrawer(context, ref, userType: UserTypes.student),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: all20Pix(
                  child: Column(
                children: [
                  buildProfileImageWidget(
                      profileImageURL:
                          ref.read(userDataProvider).profileImageURL,
                      radius: MediaQuery.of(context).size.width * 0.15),
                  all10Pix(child: blackInterBold(formattedName, fontSize: 20)),
                  if (ref.read(userDataProvider).profileImageURL.isNotEmpty)
                    ElevatedButton(
                        onPressed: () => removeProfilePicture(context, ref),
                        child: whiteInterBold('REMOVE PROFILE PICTURE')),
                  ElevatedButton(
                      onPressed: () => uploadProfilePicture(context, ref),
                      child: whiteInterBold('UPLOAD PROFILE PICTURE'))
                ],
              )),
            ),
          )),
    );
  }
}
