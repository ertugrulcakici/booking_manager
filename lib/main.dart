import 'package:bookingmanager/core/services/cache/cache_service.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/firebase_options.dart';
import 'package:bookingmanager/product/constants/app_constants.dart';
import 'package:bookingmanager/view/auth/splash/splash_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheService.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: const [AppConstants.enLocale, AppConstants.trLocale],
      path: AppConstants.pathLocale,
      saveLocale: true,
      fallbackLocale: AppConstants.enLocale,
      useOnlyLangCode: true,
      child: const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ScreenUtilInit(
        designSize:
            const Size(AppConstants.designWidth, AppConstants.designHeight),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          navigatorKey: NavigationService.navigatorKey,
          title: 'Booking Manager',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.blue,
          ),
          home: const SplashView(),
        ),
      ),
    );
  }
}
