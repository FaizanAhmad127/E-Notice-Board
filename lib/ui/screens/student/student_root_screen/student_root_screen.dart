import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/ui/screens/student/student_home_screen/student_home_screen.dart';
import 'package:notice_board/ui/screens/student/student_notification_screen/student_notification_screen.dart';

class StudentRootScreen extends StatelessWidget {
  const StudentRootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
          children: [
            StudentHomeScreen(),
            StudentNotificationScreen(),
            Center(child: Text("Tab 3"),),
            Center(child: Text("Tab 4"),),

          ],
        ),
      ),
    );
  }
}
