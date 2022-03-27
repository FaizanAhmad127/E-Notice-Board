import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/ui/screens/chat_screen/chat_screen.dart';
import 'package:notice_board/ui/screens/student/student_Project_Status_Screen/student_project_status_screen.dart';
import 'package:notice_board/ui/screens/student/student_home_screen/student_home_screen.dart';
import 'package:notice_board/ui/screens/student/student_notification_screen/student_notification_screen.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/student_drawer_screen/student_drawer_screen.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/student_root_screen/student_root_screen_vm.dart';
import 'package:notice_board/ui/screens/student/student_teacherList_screen/student_teacherList_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/user_documents/user_profile_service.dart';

class StudentRootScreen extends StatefulWidget {
   const StudentRootScreen({Key? key}) : super(key: key);

  @override
  State<StudentRootScreen> createState() => _StudentRootScreenState();
}

class _StudentRootScreenState extends State<StudentRootScreen> with
SingleTickerProviderStateMixin, WidgetsBindingObserver{
   late TabController controller;

   final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
   final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

   Future setUserOnlineStatus(String status)async
   {
     await _userProfileService.postOnlineStatus("student",
         _firebaseAuth.currentUser!.uid, status);
   }

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setUserOnlineStatus("online");
    controller=TabController(length: 4, vsync: this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state==AppLifecycleState.resumed)
      {
        setUserOnlineStatus("online");
      }
    else
      {
        setUserOnlineStatus("offline");
      }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>StudentRootScreenVM(),
      builder: (context,viewModel)
      {
        return Scaffold(
          resizeToAvoidBottomInset: false,

          drawer:  StudentDrawerScreen(),
          appBar: AppBar(
            backgroundColor: kPrimaryColor,

            actions: [
              GestureDetector(
                onTap: (){
                  NavigationService().navigatePush(context, ChatScreen("student",_firebaseAuth.currentUser!.uid));
                },
                child: const Icon(
                    Icons.message_rounded
                ),
              ),SizedBox(width: 15.w,),
            ],
            bottom: PreferredSize(
              preferredSize:  Size(1.sw, 20.0),
              child: TabBar(
                controller: controller,
                indicatorColor: kBlackColor,
                tabs: const [
                  Icon(
                      Icons.home_rounded
                  ),
                  Icon(
                      Icons.notifications
                  ),
                  Icon(
                      Icons.business_center
                  ),
                  Icon(
                      Icons.people_alt
                  ),

                ],
              ),
            ),

          ),
          body: TabBarView(
            controller: controller,
            children: [
              StudentHomeScreen(),
              StudentNotificationScreen(),
              StudentProjectStatusScreen(),
              StudentTeacherListScreen(),

            ],
          ),
        );
      },
    );
  }
}
