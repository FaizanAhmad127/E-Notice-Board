import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/notification/student_idea_status_model.dart';
import 'package:notice_board/core/services/date_time_service.dart';
import 'package:notice_board/ui/screens/student/student_notification_screen/student_notification_screen_vm.dart';
import 'package:provider/provider.dart';

class StudentNotificationScreen extends StatelessWidget {
   StudentNotificationScreen({Key? key}) : super(key: key);

  final  DateTimeService _dateTimeService=DateTimeService();

  Widget notificationCard(StudentIdeaStatusModel ideaStatusModel)
  {
    return SizedBox(
      height: 110.h,
      width: 414.w,
      child: Card(
        color: kPostBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(top: 19.h,left: 14.w,bottom: 23.w,right: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    backgroundColor: kAvatarBackgroundColor,
                    radius: 30.r,
                    child: FittedBox(
                      child: Text(
                        ideaStatusModel.teacherName!.substring(0,1),
                        style: kPoppinsMedium500.copyWith(
                          fontSize: 30.sp,
                          color: kWhiteColor
                        ),
                      ),
                    ),

                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: FittedBox(
                          child: Text(
                            ideaStatusModel.ideaTitle??"Title missing",
                            style: kPoppinsMedium500.copyWith(
                              fontSize: 21.sp,
                              color: kBlackColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          child: Text("By ${ideaStatusModel.teacherName??""}",
                            style: kPoppinsLight300.copyWith(
                              fontSize: 16.sp,
                              color: kBlackColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          child: Text(_dateTimeService.timeDifference(ideaStatusModel.timeStamp??1),
                            style: kPoppinsLight300.copyWith(
                              fontSize: 12.sp,
                              color: kDateColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child:
                  Align(
                    alignment: Alignment.center,
                    child: FittedBox(

                      child: Text(ideaStatusModel.status=="rejected"?"Rejected":"Accepted",
                        style: kPoppinsMedium500.copyWith(
                            fontSize: 14.sp,
                            color: ideaStatusModel.status=="accepted"?kAcceptedColor:kRejectedColor,
                        ),),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>StudentNotificationScreenVM(),
      builder: (context,viewModel)
      {
        return Consumer<StudentNotificationScreenVM>(
            builder: (context,vm,child){
          return Scaffold(
            backgroundColor: kWhiteColor,
            body: SizedBox(
              height: 1.sh,
              width: 1.sw,
              child: Padding(
                padding: EdgeInsets.only(top: 5.h,bottom: 5.h,right: 5.w,left: 5.w),
                child: ListView.builder(
                    itemCount: vm.getIdeasList.length,
                    itemBuilder: (context,index)
                    {
                      return vm.getIdeasList.isEmpty?
                          Center(child: Text("Nothing to show yet"),)
                      :notificationCard(vm.getIdeasList[index]);
                    }),
              ),
            ),
          );
        });
      },
    );
  }
}
