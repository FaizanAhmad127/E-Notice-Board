import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/ui/custom_widgets/custom_multiselect_dropdown.dart';
import 'package:notice_board/ui/screens/marks_screen/marks_screen.dart';
import 'package:notice_board/ui/screens/student/student_home_screen/student_home_screen.dart';
import 'package:notice_board/ui/screens/teacher/teacher_result_screen/teacher_marks_screen.dart';
import 'package:notice_board/ui/screens/teacher/teacher_result_screen/teacher_result_screen_VM.dart';
import 'package:provider/provider.dart';

import '../../../custom_widgets/login_register_button/login_register_button.dart';

class TeacherResultScreen extends StatelessWidget {
  const TeacherResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>TeacherResultScreenVM(),
      builder: (context,viewModel)
      {
        return Consumer<TeacherResultScreenVM>(
            builder: (context,vm,child)
            {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding: EdgeInsets.only(
                    left: 0.05.sw,
                    right: 0.05.sw,
                    top: 0.03.sh,
                    bottom: 0.01.sh,
                  ),
                  child: Column(

                    children: [
                      Expanded(
                          flex:10,
                          child: ListView(
                        children: [
                          GestureDetector(
                            onTap: ()
                            {
                              NavigationService().navigatePush(context, MarksScreen());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FittedBox(
                                  child: Text('Check Result',style: kPoppinsSemiBold600.copyWith(
                                    color: Colors.blueAccent,
                                    fontSize: 15.sp,
                                  ),),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.blueAccent,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,

                          ),
                          vm.groups.length==0?
                              Center(
                                child: Text(''' You didn't accepted any idea yet and isn't a part of committee'''),
                              ):
                          SizedBox(
                            height: 410.h,
                            child: ListView.builder(
                                itemCount: vm.groups.length,
                                itemBuilder: (context,index){
                              return Padding(
                                padding: EdgeInsets.only(bottom: 0.02.sh),
                                child: Container(
                                  height: 130.h,
                                  padding: EdgeInsets.only(
                                    top: 10.h,
                                    bottom: 10.h,
                                    left: 10.h
                                  ),
                                  decoration: BoxDecoration(
                                    color: kDateColor,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Column(
                                    children: [

                                      Expanded(child: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text('Group: ${index+1}',
                                                  style: kPoppinsMedium500.copyWith(
                                                      fontSize: 15.sp
                                                  ),),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                              onTap: (){
                                                NavigationService().navigatePush(context, TeacherMarksScreen());
                                              },
                                              child: AcceptedRejectedButton(text: 'Give Marks', color: Colors.blueAccent)
                                          )
                                        ],
                                      )),
                                      Expanded(child: Align(
                                        alignment: Alignment.topLeft,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text('Students:',
                                            style: kPoppinsMedium500.copyWith(
                                                fontSize: 12.sp
                                            ),),
                                        ),
                                      )),
                                      Expanded(
                                        flex: 1,
                                          child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: vm.groups[index].length,
                                          itemBuilder: (context,indx)
                                      {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 10.w),
                                          child: Container(
                                            height: 60.h,
                                            decoration: BoxDecoration(
                                              color: kFinPenPressedColor,
                                              borderRadius: BorderRadius.circular(5.r)
                                            ),
                                            padding: EdgeInsets.all(8),
                                            child: Text('${vm.groups[index][indx].fullName}'),
                                          ),
                                        );
                                      })),

                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      )),

                    ],
                  ),
                ),
              );
            });

      },);
  }
}
