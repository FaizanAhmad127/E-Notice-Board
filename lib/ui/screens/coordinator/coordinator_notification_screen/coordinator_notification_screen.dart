import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/notification/student_idea_status_model.dart';
import 'package:notice_board/core/services/date_time_service.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/notification/signup_request_model.dart';
import 'coordinator_notification_screen_vm.dart';

class CoordinatorNotificationScreen extends StatelessWidget {
  CoordinatorNotificationScreen({Key? key}) : super(key: key);

  final  DateTimeService _dateTimeService=DateTimeService();

  Widget notificationCard(SignupRequestModel requestModel,CoordinatorNotificationScreenVM vm, int index)
  {
    return SizedBox(
      height: 110.h,
      width: 414.w,
      child: Card(
        color: kPostBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(top: 19.h,left: 14.w,bottom: 23.w,right: 3.w),
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
                        requestModel.fullName!.substring(0,1),
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
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "${requestModel.fullName} has requested to join",
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
                          child: Text("Tag:  ${requestModel.occupation}",
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
                          child: Text(_dateTimeService.timeDifference(requestModel.timeStamp??1),
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
                     child: Row(
                       children: [
                         GestureDetector(
                           onTap: ()async{
                             await vm.setApproval(requestModel.email??"", "no",index);

                           },
                           child: Icon(
                             Icons.cancel_outlined,
                             size: 25.r,
                           ),
                         ),
                         SizedBox(
                           width: 10.w,
                         ),
                         GestureDetector(
                           onTap: ()async{
                            await vm.setApproval(requestModel.email??"", "yes",index);
                           },
                           child: Icon(
                             Icons.check_circle,
                             size: 25.r,
                           ),
                         )
                       ],
                     ),
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
      create: (context)=>CoordinatorNotificationScreenVM(),
      builder: (context,viewModel)
      {
        return Consumer<CoordinatorNotificationScreenVM>(
            builder: (context,vm,child){
              return Scaffold(
                backgroundColor: kWhiteColor,
                body: SizedBox(
                  height: 1.sh,
                  width: 1.sw,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.h,bottom: 5.h,right: 5.w,left: 5.w),
                    child: vm.listOfRequests.isEmpty?
                    Center(child: Text("Nothing to show yet",
                      style: kPoppinsMedium500.copyWith(
                          color: kBlackColor
                      ),),)
                    :ListView.builder(
                        itemCount: vm.listOfRequests.length,
                        itemBuilder: (context,index)
                        {
                          return notificationCard(vm.listOfRequests[index],vm,index);
                        })
                  ),
                ),
              );
            });
      },
    );
  }
}
