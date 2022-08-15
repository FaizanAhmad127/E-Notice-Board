import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/notification/student_idea_status_model.dart';
import 'package:notice_board/core/models/notification/teacher_notification_model.dart';
import 'package:notice_board/core/services/date_time_service.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/ui/screens/student/student_notification_screen/student_notification_screen_vm.dart';
import 'package:notice_board/ui/screens/teacher/teacher_notification_screen/teacher_notification_screen_vm.dart';
import 'package:notice_board/ui/screens/view_details_screen/view_details_screen.dart';
import 'package:provider/provider.dart';

class TeacherNotificationScreen extends StatelessWidget {
   TeacherNotificationScreen({Key? key}) : super(key: key);

  final  DateTimeService _dateTimeService=DateTimeService();

  Widget notificationCard(TeacherNotificationModel ideaStatusModel,BuildContext context,TeacherNotificationScreenVM vm)
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
                        ideaStatusModel.ideaTitle!.substring(0,1),
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
                            ideaStatusModel.ideaTitle??"Title missing",
                            style: kPoppinsMedium500.copyWith(
                              fontSize: 18.sp,
                              color: kBlackColor,
                              letterSpacing: -0.4
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          child: RichText(
                            text: TextSpan(
                                text: "Idea Type : ",
                                  style: kPoppinsMedium500.copyWith(
                                    fontSize: 16.sp,
                                    color: kBlackColor,

                                ),
                              children: [
                                TextSpan(
                                    text:ideaStatusModel.ideaType??"",
                                  style: kPoppinsLight300.copyWith(
                                    fontSize: 16.sp,
                                    color: kBlackColor,
                                  ),
                                ),


                              ]
                            ),
                          ),
                        )
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
              /// tick cross and view details
              ideaStatusModel.status=="pending"?
              Expanded(
                  child: Column(
                children: [
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
                                  await vm.setNotificationStatus( "rejected",ideaStatusModel);
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
                                  await vm.setNotificationStatus("accepted",ideaStatusModel);
                                },
                                child: Icon(
                                  Icons.check_circle,
                                  size: 25.r,
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  SizedBox(height: 10.h,),
                  Expanded(
                      child: GestureDetector(
                        onTap: (){
                          NavigationService().navigatePush(context, ViewDetailsScreen(ideaId: ideaStatusModel.ideaId??""));
                        },
                        child: FittedBox(
                          child: Text("View Details",style: kPoppinsMedium500.copyWith(
                              fontSize: 17.sp,
                              color: Colors.blueAccent
                          ),),
                        ),
                      )),

                ],
              ))
                  :ideaStatusModel.status=="accepted"
                  ?Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text("Accepted",style: kPoppinsRegular400.copyWith(
                        fontSize: 15.sp,
                        color: kAcceptedColor
                      ),),

                    ),
                  ))
                  :Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text("Rejected",style: kPoppinsRegular400.copyWith(
                          fontSize: 15.sp,
                          color: kRejectedColor
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
      create: (context)=>TeacherNotificationScreenVM(),
      builder: (context,viewModel)
      {
        return Consumer<TeacherNotificationScreenVM>(
            builder: (context,vm,child){
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: kWhiteColor,
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: kPrimaryColor,
                bottom: TabBar(
                  indicatorColor: kAcceptedColor,
                  labelStyle: kPoppinsMedium500.copyWith(
                    fontSize: 15
                  ),
                    unselectedLabelStyle: kPoppinsRegular400.copyWith(
                      fontSize: 13
                    ),
                    tabs: [
                  Text('General'),
                  Text('Events'),
                ]),
              ),
              body: TabBarView(children: [
                SizedBox(
                  height: 1.sh,
                  width: 1.sw,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.h,bottom: 5.h,right: 5.w,left: 5.w),
                    child: vm.getIdeasList.isEmpty?
                    const Center(child: Text("Nothing to show yet"),)
                        :ListView.builder(
                        itemCount: vm.getIdeasList.length,
                        itemBuilder: (context,index)
                        {
                          return notificationCard(vm.getIdeasList[index],context,vm);
                        }),
                  ),
                ),
                ///
                /// View Events
                ///
                Padding(padding: EdgeInsets.all(15),
                  child: vm.getListOfEvents.isEmpty?
                  Center(
                    child: Text('List of events will appear here'),
                  ):
                  ListView.builder(
                      itemCount: vm.getListOfEvents.length,
                      itemBuilder: (context,index)
                      {
                        return Container(
                          margin: EdgeInsets.only(
                              bottom: 0.02.sh
                          ),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: kPrimaryColor
                              )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      vm.getListOfEvents[index].title??'',
                                      style: kPoppinsSemiBold600.copyWith(
                                          fontSize: 18
                                      ),),
                                  ),

                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Text('Date: ',
                                    style: kPoppinsMedium500.copyWith(
                                        fontSize: 14
                                    ),),
                                  Text(DateTimeService().getDate(vm.getListOfEvents[index].dateTime??'')),
                                  SizedBox(width: 40,),
                                  Text('Time: ',
                                    style:kPoppinsMedium500.copyWith(
                                        fontSize: 14
                                    ),),
                                  Text(DateTimeService().getTime(vm.getListOfEvents[index].dateTime??'')),

                                ],
                              ),
                              const SizedBox(height: 6,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Venue:    ',
                                    style: kPoppinsMedium500.copyWith(
                                        fontSize: 14
                                    ),),
                                  Expanded(
                                      child: Text(vm.getListOfEvents[index].location??'')),


                                ],
                              ),
                              const SizedBox(height: 6,),
                              Text('Details of an event: ',
                                style: kPoppinsMedium500.copyWith(
                                    fontSize: 14
                                ),),
                              Text(vm.getListOfEvents[index].description??'',
                                textAlign: TextAlign.justify,
                                style: kPoppinsRegular400.copyWith(

                                ),),
                            ],
                          ),
                        );
                      }),)
              ])
            ),
          );
        });
      },
    );
  }
}
