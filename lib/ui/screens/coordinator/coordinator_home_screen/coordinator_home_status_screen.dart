import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/enums/enums.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_home_screen/pending_screen/coordinator_pending_screen.dart';
import 'package:notice_board/ui/screens/student/student_Project_Status_Screen/finished_screen/finished_screen.dart';
import 'package:notice_board/ui/screens/student/student_Project_Status_Screen/pending_screen/pending_screen.dart';
import 'package:notice_board/ui/screens/student/student_Project_Status_Screen/student_project_status_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/navigation_service.dart';
import '../coordinator_event_screen/coordinator_event_screen.dart';
import 'coordinator_project_status_screen_vm.dart';
import 'finished_screen/coordinator_finished_screen.dart';

class CoordinatorProjectStatusScreen extends StatelessWidget {
   CoordinatorProjectStatusScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context)=>CoordinatorProjectStatusScreenVM(),
      builder:(context,viewModel)
      {
        return  Scaffold(
          backgroundColor: kWhiteColor,
          floatingActionButton: SizedBox(
            width: 0.22.sw,
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ))
              ),
              onPressed: ()
              {
                NavigationService().navigatePush(context, CoordinatorEventScreen());
              }, child: Row(
              children: [
                Expanded(child: Icon(Icons.add,color: kWhiteColor,)),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: FittedBox(
                    child: Text('Notice',style: kPoppinsRegular400.copyWith(
                        color: kWhiteColor,
                        fontSize: 15
                    ),),
                  ),
                ),
                SizedBox(width: 2,)
              ],
            ),

            ),
          ),
          body: Consumer<CoordinatorProjectStatusScreenVM>(
            builder: (context,viewModel,child)
            {
              return SingleChildScrollView(
                child: SizedBox(
                  height: 0.9.sh,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                      onTap:(){
                                        viewModel.setStatus=projectStatus.finished;
                          },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: kTfBorderColor
                                          )
                                        ),
                                        elevation: viewModel.getStatus==projectStatus.finished?
                                        10:0,
                                        margin: EdgeInsets.zero,
                                        color: viewModel.getStatus==projectStatus.finished?
                                        kFinPenPressedColor:kWhiteColor,
                                        child: Center(
                                          child: Text(
                                            "Finished",
                                            style: kPoppinsMedium500.copyWith(
                                              fontSize: 21.sp,

                                            ),),
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    child: GestureDetector(
                                      onTap:(){
                                        viewModel.setStatus=projectStatus.pending;
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: kTfBorderColor
                                            )
                                        ),
                                        elevation: viewModel.getStatus==projectStatus.pending?
                                        10:0,
                                        shadowColor: kPrimaryColor,
                                        margin: EdgeInsets.zero,
                                        color: viewModel.getStatus==projectStatus.pending?
                                        kFinPenPressedColor:kWhiteColor,
                                        child: Center(
                                          child: Text(
                                            "Pending",
                                            style: kPoppinsMedium500.copyWith(
                                              fontSize: 21.sp,

                                            ),),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 11,
                          child: viewModel.getStatus==projectStatus.finished?
                          CoordinatorFinishedScreen():CoordinatorPendingScreen(),

                      )

                    ],
                  ),
                ),
              );
            },

          ),
        );
      }

    );
  }
}
