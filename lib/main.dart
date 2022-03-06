import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/services/user_authentication/user_auth_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';
import 'package:notice_board/ui/screens/login/login_screen.dart';
import 'package:notice_board/ui/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/student_root_screen.dart';
import 'core/constants/colors.dart';



GetIt locator = GetIt.instance;

void setupSingletons() async {
  locator.registerLazySingleton<UserAuthService>(() => UserAuthService());
  locator.registerLazySingleton<UserProfileService>(() => UserProfileService());
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  setupSingletons();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _fbApp= Future.delayed(Duration(seconds: 5)).then((value) {
    return Firebase.initializeApp();
  });


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
   minTextAdapt: true,
      designSize:  const Size(414,640) ,//414x707 figma size,
      builder:()=> MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Notice Board',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: kPrimaryColor,

        ),
        home: FutureBuilder(
          future: _fbApp,
          builder: (context,snapshot)
          {
            if(snapshot.hasData)
            {
              return LoginScreen();
            }
            else
            {
              return SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
