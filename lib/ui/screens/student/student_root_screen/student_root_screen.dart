import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/ui/screens/student/student_Project_Status_Screen/student_project_status_screen.dart';
import 'package:notice_board/ui/screens/student/student_home_screen/student_home_screen.dart';
import 'package:notice_board/ui/screens/student/student_notification_screen/student_notification_screen.dart';

class StudentRootScreen extends StatefulWidget{
   const StudentRootScreen({Key? key}) : super(key: key);

  @override
  State<StudentRootScreen> createState() => _StudentRootScreenState();
}

class _StudentRootScreenState extends State<StudentRootScreen> with
SingleTickerProviderStateMixin{
   late TabController controller;

   @override
  void initState() {
    super.initState();
    controller=TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(

      ),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: Icon(
          Icons.view_headline_sharp
        ),

        actions: [
          Icon(
            Icons.message_rounded
          ),SizedBox(width: 15.w,),
        ],
        bottom: PreferredSize(
          preferredSize: new Size(1.sw, 20.0),
          child: TabBar(
            controller: controller,
               indicatorColor: kBlackColor,
            tabs: [
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
          Center(child: Text("Tab 4"),),

        ],
      ),
    );
  }
}
