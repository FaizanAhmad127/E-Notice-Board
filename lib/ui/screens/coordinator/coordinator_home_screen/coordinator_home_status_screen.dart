import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/enums/enums.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_home_screen/pending_screen/coordinator_pending_screen.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_home_screen/pending_screen/coordinator_pending_screen_vm.dart';
import 'package:notice_board/ui/screens/student/student_Project_Status_Screen/finished_screen/finished_screen.dart';
import 'package:notice_board/ui/screens/student/student_Project_Status_Screen/pending_screen/pending_screen.dart';
import 'package:notice_board/ui/screens/student/student_Project_Status_Screen/student_project_status_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/navigation_service.dart';
import '../coordinator_event_screen/coordinator_event_screen.dart';
import 'finished_screen/coordinator_finished_screen.dart';
import 'finished_screen/coordinator_finished_screen_vm.dart';



class CoordinatorProjectStatusScreen extends StatefulWidget {
  const CoordinatorProjectStatusScreen({Key? key}) : super(key: key);

  @override
  State<CoordinatorProjectStatusScreen> createState() => _CoordinatorProjectStatusScreenState();
}

class _CoordinatorProjectStatusScreenState extends State<CoordinatorProjectStatusScreen> {

  projectStatus status=projectStatus.finished;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child:MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context)=>CoordinatorFinishedScreenVM()),
              ChangeNotifierProvider(create: (context)=> CoordinatorPendingScreenVM()),
        ],
          builder: (context,widget)
          {
            final finishedVm=Provider.of<CoordinatorFinishedScreenVM>(context,listen: true);
            final pendingVm=Provider.of<CoordinatorPendingScreenVM>(context,listen: true);
            return SizedBox(
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
                                    status=projectStatus.finished;
                                    setState((){});
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: kTfBorderColor
                                        )
                                    ),
                                    elevation: status==projectStatus.finished?
                                    10:0,
                                    margin: EdgeInsets.zero,
                                    color: status==projectStatus.finished?
                                    kFinPenPressedColor:kWhiteColor,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Finished",
                                            style: kPoppinsMedium500.copyWith(
                                              fontSize: 21.sp,

                                            ),),
                                          SizedBox(width: 5.w,),
                                          Text(
                                            finishedVm.getIdeasList.length.toString(),
                                            style: kPoppinsRegular400.copyWith(
                                                fontSize: 19.sp,
                                                color: kAcceptedColor
                                            ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            Expanded(
                                child: GestureDetector(
                                  onTap:(){
                                    status=projectStatus.pending;
                                    setState((){});
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: kTfBorderColor
                                        )
                                    ),
                                    elevation: status==projectStatus.pending?
                                    10:0,
                                    shadowColor: kPrimaryColor,
                                    margin: EdgeInsets.zero,
                                    color: status==projectStatus.pending?
                                    kFinPenPressedColor:kWhiteColor,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Pending",
                                            style: kPoppinsMedium500.copyWith(
                                              fontSize: 21.sp,

                                            ),),
                                          SizedBox(width: 5.w,),
                                          Text(
                                            pendingVm.getIdeasList.length.toString(),
                                            style: kPoppinsRegular400.copyWith(
                                              fontSize: 19.sp,
                                              color: kAcceptedColor

                                            ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 11,
                    child: status==projectStatus.finished?
                    CoordinatorFinishedScreen(vm: finishedVm,):CoordinatorPendingScreen(vm: pendingVm,),

                  )

                ],
              ),
            );
          },

        )

      ),
    );
  }

}

