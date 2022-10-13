import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/ui/custom_widgets/login_register_button/login_register_button.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_home_screen/coordinator_home_screen.dart';
import 'package:notice_board/ui/screens/teacher/teacher_result_screen/teacher_marks_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/user_authentication/user_signup_model.dart';
import '../../../custom_widgets/custom_user_tf/custom_user_tf.dart';

class TeacherMarksScreen extends StatelessWidget {
  TeacherMarksScreen({required this.group, required this.idea, Key? key})
      : super(key: key);
  final TextEditingController msgTextEditingController=TextEditingController();
  List<UserSignupModel> group = [];
  IdeaModel? idea;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => TeacherMarksScreenVM(group: group, idea: idea),
        builder: (context, viewModel) {
          return Consumer<TeacherMarksScreenVM>(
            builder: (context, vm, child) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Stack(
                  children: [
                    Positioned(
                      bottom: 0.06.sh,
                      top: 0.001.sh,
                      left: 0.04.sw,
                      right: 0.04.sw,
                      child: NestedScrollView(
                          headerSliverBuilder: (BuildContext context, bool i) {
                            return [
                              SliverAppBar(
                                pinned: true,
                                backgroundColor: Colors.white60,
                                leading: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.arrow_back,
                                      size: 30, color: Colors.black),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 0.2.sh,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 0.08.sw),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Your Status',
                                            style: kPoppinsBold700.copyWith(
                                                fontSize: 20.sp),
                                          ),
                                        )),
                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Supervisor: ${vm.isSupervisor == true ? 'YES' : 'NO'}',
                                            style: kPoppinsMedium500.copyWith(
                                                fontSize: 16.sp),
                                          ),
                                        )),
                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Committee Member: ${vm.isCommitteeMember == true ? 'YES' : 'NO'}',
                                            style: kPoppinsMedium500.copyWith(
                                                fontSize: 16.sp),
                                          ),
                                        )),
                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Conviner Member: ${vm.isConvenerMember == true ? 'YES' : 'NO'}',
                                            style: kPoppinsMedium500.copyWith(
                                                fontSize: 16.sp),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ///DropDown Button
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 0.04.sh,
                                    left: 0.03.sw
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Select Exam',
                                        style: kPoppinsSemiBold600.copyWith(
                                            fontSize: 18.sp),
                                      ),
                                      SizedBox(
                                        width: 0.04.sw,
                                      ),
                                      DropdownButton<String>(
                                          value: vm.selectedDropDownListItem,
                                          items: vm.dropDownListItems
                                              .map((String value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            vm.setSelectedDropDownListItem =
                                                value.toString();
                                          })
                                    ],
                                  ),
                                ),
                              ),

                            ];
                          },
                          body:

                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 0.03.sh,
                                  left: 0.03.sw,
                                  right:0.03.sw
                              ),
                              child:
                               Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: vm.group.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return  Container(
                                            padding: EdgeInsets.only(top: 0.02.sh, ),
                                            color: Colors.white54,
                                            child:  Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            '${vm.group[index].fullName?.toUpperCase()}',
                                                            style: kPoppinsMedium500
                                                                .copyWith(
                                                                fontSize: 17.sp),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            'University ID: ${vm.group[index].universityId}',
                                                            style: kPoppinsExtraLight200
                                                                .copyWith(
                                                                fontSize: 12.sp),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                vm.selectedDropDownListItem ==
                                                    'FYP-1 VIVA' ||
                                                    vm.selectedDropDownListItem ==
                                                        'FYP-2 VIVA'
                                                    ? Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 0.03.sh,
                                                    bottom: 0.03.sh,
                                                  ),
                                                  child: MarksTF(
                                                    fyp1or2: vm.selectedDropDownListItem,
                                                    group: group,
                                                    vm: vm,
                                                    onChanged: (tfValue) {
                                                      if (tfValue == null) {
                                                        vm.marks[index] = 101;
                                                      } else {
                                                        //print("index is $index");
                                                        vm.marks[index] = tfValue;
                                                        vm.setMarksListMap(
                                                            vm.selectedDropDownListItem,
                                                            tfValue,
                                                            group[index].uid ?? '');
                                                      }
                                                    },
                                                  ),
                                                ): Column(
                                                  children: [
                                                    getMarkingUI(
                                                      selectedItem: vm.selectedDropDownListItem,
                                                      callback: (intValue)
                                                      {
                                                        vm.setMarksListMap(
                                                            vm.selectedDropDownListItem,
                                                            intValue.toDouble(),
                                                            group[index].uid ?? '');
                                                      },

                                                    ),

                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                    if(vm.selectedDropDownListItem=="OBE2" && vm.isConvenerMember)
                                  Text(
                                    'Project Decision',
                                    style: kPoppinsSemiBold600.copyWith(
                                        fontSize: 18.sp),
                                  ),
                                  if(vm.selectedDropDownListItem=="OBE2" && vm.isConvenerMember)
                                  SizedBox(
                                    width: 0.04.sw,
                                  ),
                                  if(vm.selectedDropDownListItem=="OBE2" && vm.isConvenerMember)
                                  DropdownButton<String>(
                                    value: vm.selectedDecisionDropDownListItem, //selected
                                    style: TextStyle(color: Theme.of(context).accentColor,fontSize: 26),
                                    onChanged: ( value) {
                                      vm.setSelectedDecisionDropDownListItem =
                                          value.toString();
                                    },
                                    items: <String>['Accept','Conditionally accept','Reappear','Reject']
                                        .map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  if(vm.selectedDropDownListItem=="OBE2" && vm.isConvenerMember)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Emailuser(
                                        textEditingController: msgTextEditingController,
                                        hintText: "Enter Remarks",
                                        icon: Icon(
                                          Icons.message,
                                          color: kWhiteColor,
                                        ),
                                        validator: (value) {
                                          return null;
                                        },
                                      )
                                    ],
                                  ),


                              ],
                            )



                            ),
                      ),
                    ),
                   // OBE2
                    Positioned(
                      bottom: 0.01.sh,
                      child: UnconstrainedBox(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 0.05.sw,
                            right: 0.05.sw,
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              print(vm.marks);
                              if (vm.selectedDropDownListItem == 'FYP-1 VIVA') {
                                if (vm.marks
                                    .any((value) => value > 50 || value < 0)) {
                                  BotToast.showText(text: 'FYP-1 range 0-50');
                                } else {
                                  await vm.submitMarks(msgTextEditingController.text).then((value) {

                                    vm.getNoOfStudents();

                                  });

                                }
                              } else if (vm.selectedDropDownListItem ==
                                  'FYP-2 VIVA') {
                                if (vm.marks
                                    .any((value) => value > 100 || value < 0)) {
                                  BotToast.showText(text: 'FYP2 range 0-100');
                                } else {
                                  await vm.submitMarks(msgTextEditingController.text).then((value) {
                                    vm.getNoOfStudents();

                                  });
                                }
                              } else {
                                await vm.submitMarks(msgTextEditingController.text).then((value) {
                                  vm.getNoOfStudents();

                                });
                              }

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(10.r)),
                              width: 0.9.sw,
                              height: 0.06.sh,
                              alignment: Alignment.bottomCenter,
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'SUBMIT',
                                    style: kPoppinsSemiBold600.copyWith(
                                        fontSize: 20, color: kWhiteColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MarksTF extends StatelessWidget {
  MarksTF(
      {Key? key,
      required this.group,
      required this.vm,
        required this.fyp1or2,
      required this.onChanged})
      : super(key: key);

  final List<UserSignupModel> group;
  final TeacherMarksScreenVM vm;
  Function(double?) onChanged;
  String fyp1or2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Marks',
            style: kPoppinsSemiBold600.copyWith(fontSize: 15.sp),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Expanded(
          flex: 3,
          child: TextField(
            onChanged: (value) {
              if (value.isEmpty) {
                onChanged(null);
              } else {
                onChanged(double.parse(value));
              }
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: 'Type marks here',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: kPrimaryColor,
                      width: 2,
                    ))),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Expanded(
          child: Text(
            'Out of ${fyp1or2=='FYP-1 VIVA'?50:100}',
            style: kPoppinsSemiBold600.copyWith(fontSize: 13.sp,
            color: kTfFillColor),
          ),
        ),

      ],
    );
  }
}


class getMarkingUI extends StatefulWidget {
   getMarkingUI({Key? key,required this.selectedItem,required this.callback}) : super(key: key);

  String selectedItem;
  Function(int) callback;

  @override
  State<getMarkingUI> createState() => _getMarkingUIState();
}

class _getMarkingUIState extends State<getMarkingUI> {

  List<String> OBE2=['Problem identification and objectives','Methodology','Work plan','Presentation'];
  List<String> OBE3=['CONTENT','Adherence','Presentation','Viva'];
  List<String> OBE4=['CONTENT','Adherence to work plan','Coherence with group','Viva'];

  late List<int> OBEMarks;



  List<Widget> getColumn()
  {
   List<String> items=[];
   if(widget.selectedItem=='OBE2')
     {
       items=OBE2;
     }
   else if(widget.selectedItem=='OBE3')
   {
     items=OBE3;
   }
   else if(widget.selectedItem=='OBE4')
   {
     items=OBE4;
   }
    return List.generate(items.length, (index1) {
      return Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Container(
            margin: EdgeInsets.only(top: 10.0),
            decoration:
            BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
            child: ExpansionTile(
              iconColor: Colors.grey,
              title:
              Text(items[index1],
                  style: kPoppinsRegular400.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  )),
              children: [
                RadioButton(
                    currentValue:OBEMarks[index1],
                    callback: (intValue)
                {
                  int totalMarks=0;
                  OBEMarks[index1]=intValue;
                  OBEMarks.forEach((element) { totalMarks=totalMarks+element;});
                  widget.callback(totalMarks);
                     setState(() {

                     });
                })
              ],
            ),
          ),
        );
    });
  }
  @override
  void initState() {
    super.initState();
    OBEMarks=[0,0,0,0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
      [
       Column(children: getColumn(),),
      ]
    );
  }
}


class RadioButton extends StatefulWidget {
   RadioButton({Key? key,

    required this.callback,
     required this.currentValue,
  }) : super(key: key);
  Function(int) callback;
  int currentValue;
  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {


  late int groupValue;

  @override
  void initState() {
    super.initState();
    groupValue=widget.currentValue;
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          children: [
            Radio(
              value: 0,
              groupValue: groupValue,
              onChanged: (int? value) {
                setState(() {
                  groupValue=0;
                });
                widget.callback(value ?? 0);
              },
            ),
            Text('UnAcceptable'),
            // Spacer(),
            // Text(
            //   '0 Marks',
            //   style: kPoppinsExtraLight200.copyWith(color: kDateColor),
            // )
          ],
        ),
        Row(
          children: [
            Radio(
              value: 1,
              groupValue: groupValue,
              onChanged: (int? value) {
                setState(() {
                  groupValue=1;
                });
                widget.callback(value ?? 0);
              },
            ),
            Text('Just Acceptable'),
            //Spacer(),
            // Text(
            //   '4 Marks',
            //   style: kPoppinsExtraLight200.copyWith(color: kDateColor),
            // )
          ],
        ),
        Row(
          children: [
            Radio(
              value: 2,
              groupValue: groupValue,
              onChanged: (int? value) {
                setState(() {
                  groupValue=2;
                });
                widget.callback(value ?? 0);
              },
            ),
            Text('Basic'),
            // Spacer(),
            // Text(
            //   '8 Marks',
            //   style: kPoppinsExtraLight200.copyWith(color: kDateColor),
            // )
          ],
        ),
        Row(
          children: [
            Radio(
              value: 3,
              groupValue: groupValue,
              onChanged: (int? value) {
                setState(() {
                  groupValue=3;
                });
                widget.callback(value ?? 0);
              },
            ),
            Text('Good'),
            // Spacer(),
            // Text(
            //   '12 Marks',
            //   style: kPoppinsExtraLight200.copyWith(color: kDateColor),
            // )
          ],
        ),
        Row(
          children: [
            Radio(
              value: 4,
              groupValue: groupValue,
              onChanged: (int? value) {
                setState(() {
                  groupValue=4;
                });
                widget.callback(value ?? 0);
              },
            ),
            Text('Excellent'),
            // Spacer(),
            // Text(
            //   '16 Marks',
            //   style: kPoppinsExtraLight200.copyWith(color: kDateColor),
            // )
          ],
        ),
      ],
    );
  }


}

