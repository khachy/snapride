import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:snapride/providers/auth_provider.dart';
import 'package:snapride/providers/basic_provider.dart';
import 'package:snapride/screens/starters/splash_screen.dart';
import 'package:snapride/utils/themes/app_colors.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) {
          return BasicProvider();
        },
      ),
      ChangeNotifierProvider(
        create: (_) {
          return AuthenticationProvider();
        },
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SnapRide',
        theme: ThemeData(
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: WidgetStateTextStyle.resolveWith(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return TextStyle(
                    fontSize: 14,
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  );
                } else {
                  return TextStyle(
                    fontSize: 14,
                    color: AppColors.kGreyColor,
                  );
                }
              },
            ),
          ),
          useMaterial3: true,
          fontFamily: 'Euclid Circular B',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
