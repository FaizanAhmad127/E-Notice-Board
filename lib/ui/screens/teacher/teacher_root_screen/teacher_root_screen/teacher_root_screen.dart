import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/ui/screens/chat_screen/chat_screen.dart';
import 'package:notice_board/ui/screens/teacher/teacher_root_screen/teacher_drawer_screen/teacher_drawer_screen.dart';
import 'package:notice_board/ui/screens/teacher/teacher_root_screen/teacher_root_screen/teacher_root_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/user_documents/user_profile_service.dart';
import '../../teacher_home_screen/teacher_home_screen.dart';

class TeacherRootScreen extends StatefulWidget {
   const TeacherRootScreen({Key? key}) : super(key: key);

  @override
  State<TeacherRootScreen> createState() => _TeacherRootScreenState();
}

class _TeacherRootScreenState extends State<TeacherRootScreen> with
SingleTickerProviderStateMixin, WidgetsBindingObserver{
   late TabController controller;

   final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
   final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

   Future setUserOnlineStatus(String status)async
   {
     await _userProfileService.postOnlineStatus("teacher",
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
      create: (context)=>TeacherRootScreenVM(),
      builder: (context,viewModel)
      {
        return Scaffold(
          resizeToAvoidBottomInset: false,

          drawer:  TeacherDrawerScreen(),
          appBar: AppBar(
            backgroundColor: kPrimaryColor,

            actions: [
              GestureDetector(
                onTap: (){
                  NavigationService().navigatePush(context, ChatScreen("teacher",_firebaseAuth.currentUser!.uid));
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
              TeacherHomeScreen(),
              Text("Notifications",style: TextStyle(color: kWhiteColor),),
            Text("business",style: TextStyle(color: kWhiteColor),),
            Text("Student list",style: TextStyle(color: kWhiteColor),),

            ],
          ),
        );
      },
    );
  }
}
