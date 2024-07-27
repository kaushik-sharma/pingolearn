import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hive/hive.dart';
import 'features/auth/presentation/providers/auth_controller.dart';
import 'router_config/router_config.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/app_theme.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'di.dart' as di;
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dir = await path_provider.getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;

  di.initialize();

  await di.sl<FirebaseRemoteConfig>().setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => di.sl<AuthController>()),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Chat App',
          scaffoldMessengerKey: kScaffoldMessengerKey,
          theme: kTheme,
          routerConfig: router,
        ),
      ),
    );
  }
}
