import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/ui/custom_widgets/custom_multiselect_dropdown.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_result_screen/coordinator_result_screen_vm.dart';
import 'package:notice_board/ui/screens/marks_screen/marks_screen.dart';
import 'package:provider/provider.dart';

import '../../../custom_widgets/login_register_button/login_register_button.dart';

class CoordinatorResultScreen extends StatelessWidget {
  const CoordinatorResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>CoordinatorResultScreenVm(),
    builder: (context,viewModel)
    {
      return Consumer<CoordinatorResultScreenVm>(
          builder: (context,vm,child)
      {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.only(
              left: 0.05.sw,
              right: 0.05.sw,
              top: 0.035.sh,
              bottom: 0.01.sh,
            ),
            child: Column(

              children: [
                Expanded(
                    flex:10,child: ListView(
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
                      height: 40.h,
                    ),
                    Row(children: [
                      FittedBox(
                        child: Text('Select Teacher For Committee',
                          style: kPoppinsLight300.copyWith(
                              color: kDateColor,
                              fontSize: 15.sp
                          ),),
                      )
                    ],),
                    CustomMultiselectDropDown(
                        selectedList: (selectedlist) {

                          if (selectedlist.length == 5) {
                            BotToast.showText(
                                text: "That's it, Only 4 teachers");
                          }
                          vm.setSelectedTeachersList = selectedlist;
                        },
                        userModelList: vm.listOfTeachers,
                        limit: 5,
                        labelText: "Select Teachers"),
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child:
                          Text('List of teachers in committee: '),)
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                        height: 100.h,
                        child: vm.listOfCommitteeTeachers.length>0?ListView.builder(
                        itemCount: vm.listOfCommitteeTeachers.length,
                        itemBuilder: (context,index)
                        {
                          return SizedBox(
                            height: 20.h,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                child: Text('${index+1} .  ${vm.listOfCommitteeTeachers[index].fullName??""}',
                                style: kPoppinsMedium500.copyWith(
                                  fontSize: 20.sp
                                ),),
                              ),
                            ),
                          );
                        }
                    ):FittedBox(
                          fit: BoxFit.scaleDown,
                            child:Text('Teachers Name will appear here',
                            style: kPoppinsMedium500,)
                        )
                    )
                  ],
                )),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(

                        child: LoginRegisterButton(onPressed: (){
                         Navigator.pop(context);
                        }, buttonText: "Back"),
                      ),
                      SizedBox(width: 20.w,),
                      Expanded(
                        child: LoginRegisterButton(onPressed: ()async{
                         await vm.setCommitteeTeacher();
                        }, buttonText: "SUBMIT"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );;
      });

    },);
  }
}
