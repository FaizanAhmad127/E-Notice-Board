import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/ui/screens/login/login_screen.dart';
import 'package:notice_board/ui/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/student_root_screen.dart';
import 'core/constants/colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
              return StudentRootScreen();
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
