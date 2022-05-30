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

class TeacherMarksScreen extends StatelessWidget {
  TeacherMarksScreen({required this.group, required this.idea, Key? key})
      : super(key: key);
  List<UserSignupModel> group = [];
  IdeaModel idea;

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
                                  height: 0.1.sh,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 0.08.sw),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Your Status',
                                            style: kPoppinsBold700.copyWith(
                                                fontSize: 15.sp),
                                          ),
                                        )),
                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Supervisor: ${vm.isSupervisor == true ? 'YES' : 'NO'}',
                                            style: kPoppinsMedium500.copyWith(
                                                fontSize: 13.sp),
                                          ),
                                        )),
                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Committee Member: ${vm.isCommitteeMember == true ? 'YES' : 'NO'}',
                                            style: kPoppinsMedium500.copyWith(
                                                fontSize: 13.sp),
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
                                  padding: EdgeInsets.all(0.04.sh),
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
                          body: Padding(
                            padding: EdgeInsets.only(
                              top: 0.03.sh,
                              bottom: 0.03.sh,
                              left: 0.03.sw,
                              right:0.03.sw
                            ),
                            child: ListView.builder(
                                itemCount: vm.group.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    color: Colors.white54,
                                    child: Column(
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
                                              )
                                            : RadioButton(
                                                vm: vm,
                                                user: group[index],
                                                callback: (value) {
                                                  vm.setMarksListMap(
                                                      vm.selectedDropDownListItem,
                                                      value,
                                                      group[index].uid ?? '');
                                                },
                                              )
                                      ],
                                    ),
                                  );
                                }),
                          )),
                    ),
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
                                  await vm.submitMarks().then((value) {
                                    vm.marks.removeRange(2, vm.marks.length);

                                  });

                                }
                              } else if (vm.selectedDropDownListItem ==
                                  'FYP-2 VIVA') {
                                if (vm.marks
                                    .any((value) => value > 100 || value < 0)) {
                                  BotToast.showText(text: 'FYP2 range 0-100');
                                } else {
                                  await vm.submitMarks().then((value) {
                                    vm.marks.removeRange(2, vm.marks.length);

                                  });
                                }
                              } else {
                                await vm.submitMarks().then((value) {
                                  vm.marks.removeRange(2, vm.marks.length);

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

class RadioButton extends StatelessWidget {
  RadioButton({
    required this.vm,
    required this.user,
    required this.callback,
    Key? key,
  }) : super(key: key);
  Function(double) callback;
  UserSignupModel user;
  TeacherMarksScreenVM vm;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> marksMap = vm.marksListMap.entries
        .where((element) => element.key == user.uid)
        .first
        .value;

    return Column(
      children: [
        Row(
          children: [
            Radio(
              value: 0.0,
              groupValue: marksMap['marks'] as double,
              onChanged: (double? value) {
                callback(value ?? 0.0);
              },
            ),
            Text('UnAcceptable'),
            Spacer(),
            Text(
              '0 Marks',
              style: kPoppinsExtraLight200.copyWith(color: kDateColor),
            )
          ],
        ),
        Row(
          children: [
            Radio(
              value: 4.0,
              groupValue: marksMap['marks'] as double,
              onChanged: (double? value) {
                callback(value ?? 0.0);
              },
            ),
            Text('Just Acceptable'),
            Spacer(),
            Text(
              '4 Marks',
              style: kPoppinsExtraLight200.copyWith(color: kDateColor),
            )
          ],
        ),
        Row(
          children: [
            Radio(
              value: 8.0,
              groupValue: marksMap['marks'] as double,
              onChanged: (double? value) {
                callback(value ?? 0.0);
              },
            ),
            Text('Basic'),
            Spacer(),
            Text(
              '8 Marks',
              style: kPoppinsExtraLight200.copyWith(color: kDateColor),
            )
          ],
        ),
        Row(
          children: [
            Radio(
              value: 12.0,
              groupValue: marksMap['marks'] as double,
              onChanged: (double? value) {
                callback(value ?? 0.0);
              },
            ),
            Text('Good'),
            Spacer(),
            Text(
              '12 Marks',
              style: kPoppinsExtraLight200.copyWith(color: kDateColor),
            )
          ],
        ),
        Row(
          children: [
            Radio(
              value: 16.0,
              groupValue: marksMap['marks'] as double,
              onChanged: (double? value) {
                callback(value ?? 0.0);
              },
            ),
            Text('Excellent'),
            Spacer(),
            Text(
              '16 Marks',
              style: kPoppinsExtraLight200.copyWith(color: kDateColor),
            )
          ],
        ),
      ],
    );
  }
}
