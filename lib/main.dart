import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/models/notification/teacher_notification_model.dart';
import 'package:notice_board/core/services/notification/signup_request_service.dart';
import 'package:notice_board/core/services/shared_pref_service.dart';
import 'package:notice_board/core/services/user_authentication/user_auth_service.dart';
import 'package:notice_board/core/services/user_documents/student_idea_service.dart';
import 'package:notice_board/core/services/user_documents/teacher_notification_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';
import 'package:notice_board/ui/screens/login/login_screen.dart';
import 'package:notice_board/ui/screens/login/login_screen_vm.dart';
import 'package:notice_board/ui/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/student_root_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/colors.dart';



GetIt locator = GetIt.instance;


Future setupSingletons()  async{
  locator.registerLazySingleton<UserAuthService>(() => UserAuthService());
  locator.registerLazySingleton<UserProfileService>(() => UserProfileService());
  locator.registerLazySingleton(() => StudentIdeaService());
  locator.registerLazySingleton(() => TeacherNotificationService());
  locator.registerLazySingleton(() => SignupRequestService());
 locator.registerSingletonAsync<SharedPref>(() async {
    final pref = await SharedPreferences.getInstance();
    return SharedPref(pref: pref);
  });





}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupSingletons();
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
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        title: 'E-Notice Board',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: kPrimaryColor,

        ),
        home: ChangeNotifierProvider(
          create: (context)=>LoginScreenVM(),
          builder: (context,v)
          {
            return FutureBuilder(
              future: _fbApp,
              builder: (context,snapshot)
              {
                if(snapshot.hasData)
                {
                 return Provider.of<LoginScreenVM>(context).isUserLoggedIn()?
                  StudentRootScreen():
                LoginScreen();
                }
                else
                {
                return SplashScreen();
                }
              },
            );
          },
        )

        ),
      );

  }
}
