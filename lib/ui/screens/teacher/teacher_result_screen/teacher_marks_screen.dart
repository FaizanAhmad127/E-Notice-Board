import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/ui/screens/teacher/teacher_result_screen/teacher_marks_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/user_authentication/user_signup_model.dart';

class TeacherMarksScreen extends StatelessWidget {
   TeacherMarksScreen({required this.group,Key? key}) : super(key: key);
   List<UserSignupModel> group=[];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context)=>TeacherMarksScreenVM(group: group),
        builder: (context,viewModel)
        {
          return Consumer<TeacherMarksScreenVM>(
            builder: (context,vm,child)
            {
              return Scaffold(
                backgroundColor: Colors.white,
                body: NestedScrollView(
                  headerSliverBuilder: (BuildContext context,bool i)
                    {
                      return [
                        SliverAppBar(
                          pinned: true,
                          backgroundColor: Colors.white60,
                          leading: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.black
                            ),
                          ),
                        ),

                        ///DropDown Button
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(0.04.sh),
                            child: Row(
                              children: [
                                Text('Select Exam',style: kPoppinsSemiBold600.copyWith(
                                    fontSize: 18.sp
                                ),),
                                SizedBox(width: 0.04.sw,),
                                DropdownButton<String>(
                                    value: vm.selectedDropDownListItem,
                                    items: vm.dropDownListItems.map((String value) {
                                      return DropdownMenuItem(
                                        value: value,

                                        child: Text(value),
                                      );
                                    }).toList(), onChanged: (value){
                                  vm.setSelectedDropDownListItem=value.toString();
                                })
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                  body: Padding(
                    padding: EdgeInsets.all(0.04.sh),
                    child: ListView.builder(
                        itemCount: vm.group.length,
                        itemBuilder: (context,index){
                          return Container(
                            color: Colors.white54,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text('${vm.group[index].fullName}',
                                            style: kPoppinsMedium500.copyWith(
                                                fontSize: 17.sp
                                            ),),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text('University ID: ${vm.group[index].universityId}',
                                            style: kPoppinsExtraLight200.copyWith(
                                                fontSize: 12.sp
                                            ),),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                               RadioButton(
                                 vm: vm,
                                 user: group[index],
                                 callback: (value)
                                 {
                                   vm.setMarksListMap(vm.selectedDropDownListItem, value, group[index].uid??'');
                                 },
                               )

                              ],
                            ),
                          );
                        }),
                  )
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RadioButton extends StatelessWidget {
   RadioButton({
     required this.vm,
     required this.user,
     required this.callback,
    Key? key,
  }) : super(key: key);
   Function(int) callback;
  UserSignupModel user;
  TeacherMarksScreenVM vm;
  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> marksMap=vm.marksListMap.entries.where((element) => element.key==user.uid).first.value;

    return Column(
      children: [
        Row(
          children: [
            Radio(
              value: 0,
              groupValue: marksMap['marks']as int,
              onChanged: (int? value) {
                callback(value??0);
              },
            ),
            Text('UnAcceptable')
          ],
        ),
        Row(
          children: [
            Radio(
              value: 4,
              groupValue: marksMap['marks']as int,
              onChanged: (int? value) {
                callback(value??0);
              },
            ),
            Text('Just Acceptable')
          ],
        ),
        Row(
          children: [
            Radio(
              value: 8,
              groupValue: marksMap['marks']as int,
              onChanged: (int? value) {
                callback(value??0);
              },
            ),
            Text('Basic')
          ],
        ),
        Row(
          children: [
            Radio(
              value: 12,
              groupValue: marksMap['marks']as int,
              onChanged: (int? value) {
                callback(value??0);
              },
            ),
            Text('Good')
          ],
        ),
        Row(
          children: [
            Radio(
              value: 16,
              groupValue: marksMap['marks']as int,
              onChanged: (int? value) {
                callback(value??0);
              },
            ),
            Text('Excellent')
          ],
        ),
      ],
    );
  }
}
