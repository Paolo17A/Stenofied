import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stenofied/utils/navigator_util.dart';
import 'package:stenofied/utils/theme_util.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: Stenofied()));
}

class Stenofied extends StatelessWidget {
  const Stenofied({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Stenofied',
        theme: themeData,
        routes: routes,
        initialRoute: NavigatorRoutes.welcome);
  }
}
