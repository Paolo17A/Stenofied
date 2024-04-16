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

class TeacherProfileScreen extends ConsumerStatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  ConsumerState<TeacherProfileScreen> createState() =>
      _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends ConsumerState<TeacherProfileScreen> {
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
      appBar: appBarWidget(mayGoBack: true, actions: [
        IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(NavigatorRoutes.editProfile),
            icon: Icon(Icons.edit))
      ]),
      drawer: appDrawer(context, ref, userType: UserTypes.teacher),
      body: switchedLoadingContainer(
          ref.read(loadingProvider).isLoading,
          SingleChildScrollView(
            child: all20Pix(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildProfileImageWidget(
                        profileImageURL:
                            ref.read(userDataProvider).profileImageURL,
                        radius: MediaQuery.of(context).size.width * 0.2),
                    Column(
                      children: [
                        if (ref
                            .read(userDataProvider)
                            .profileImageURL
                            .isNotEmpty)
                          ElevatedButton(
                              onPressed: () =>
                                  removeProfilePicture(context, ref),
                              child: whiteInterBold('REMOVE\nPROFILE PICTURE')),
                        ElevatedButton(
                            onPressed: () => uploadProfilePicture(context, ref),
                            child: whiteInterBold('UPLOAD\nPROFILE PICTURE'))
                      ],
                    )
                  ],
                ),
                all10Pix(child: blackInterBold(formattedName, fontSize: 20)),
              ],
            )),
          )),
    );
  }
}
