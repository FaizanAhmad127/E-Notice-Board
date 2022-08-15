import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_committee_screen/coordinator_committee_screen.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_home_screen/coordinator_home_screen.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_result_screen/coordinator_result_screen.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_root_screen/coordinator_drawer_screen/coordinator_drawer_screen.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_root_screen/coordinator_drawer_screen/coordinator_drawer_screen_vm.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_student_list_screen/coordinator_student_list_screen.dart';
import 'package:notice_board/ui/screens/student/student_Project_Status_Screen/student_project_status_screen.dart';
import 'package:notice_board/ui/screens/student/student_home_screen/student_home_screen.dart';
import 'package:notice_board/ui/screens/student/student_notification_screen/student_notification_screen.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/student_drawer_screen/student_drawer_screen.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/student_root_screen/student_root_screen_vm.dart';
import 'package:notice_board/ui/screens/student/student_teacherList_screen/student_teacherList_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/user_documents/user_profile_service.dart';
import '../../coordinator_notification_screen/coordinator_notification_screen.dart';
import '../../coordinator_teacher_list_screen/coordinator_teacher_list_screen.dart';

class CoordinatorRootScreen extends StatefulWidget {
  const CoordinatorRootScreen({Key? key}) : super(key: key);

  @override
  State<CoordinatorRootScreen> createState() => _CoordinatorRootScreenState();
}

class _CoordinatorRootScreenState extends State<CoordinatorRootScreen> with
    SingleTickerProviderStateMixin, WidgetsBindingObserver{
  late TabController controller;

  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  Future setUserOnlineStatus(String status)async
  {
    await _userProfileService.postOnlineStatus("coordinator",
        _firebaseAuth.currentUser!.uid, status);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setUserOnlineStatus("online");
    controller=TabController(length: 4, vsync: this);
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
      create: (context)=>CoordinatorDrawerScreenVM(),
      builder: (context,viewModel)
      {
        return Scaffold(
          resizeToAvoidBottomInset: false,

          drawer:  CoordinatorDrawerScreen(),
          appBar: AppBar(
            backgroundColor: kPrimaryColor,

            actions: [
              GestureDetector(
                onTap: (){
                  NavigationService().navigatePush(context, CoordinatorCommitteeScreen());
                },
                child: const Icon(
                    FontAwesomeIcons.clipboardCheck
                ),
              ),SizedBox(width: 15.w,),
            ],
            bottom: PreferredSize(
              preferredSize:  Size(1.sw, 25.0),
              child: TabBar(
                controller: controller,
                indicatorColor: kBlackColor,
                tabs:   [
                  Column(
                    children: [
                      Icon(
                          Icons.home_rounded
                      ),
                      Text('Home')
                    ],
                  ),
                  Column(
                    children: const [
                      Icon(
                          Icons.people_alt
                      ),
                      Text('Teachers')
                    ],
                  ),
                  Column(
                    children: const [
                      FaIcon(FontAwesomeIcons.graduationCap),
                      Text('Students')
                    ],
                  ),
                  Column(
                    children: const [
                      Icon(
                          Icons.notifications,
                      ),
                      FittedBox(child: Text('Notifications')),
                    ],
                  )

                ],
              ),
            ),

          ),
          body: TabBarView(
            controller: controller,
            children: [
              CoordinatorHomeScreen(),
              CoordinatorTeacherListScreen(),
              CoordinatorStudentListScreen(),
              CoordinatorNotificationScreen(),

            ],
          ),
        );
      },
    );
  }
}
