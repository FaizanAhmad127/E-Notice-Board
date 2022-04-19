import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/ui/custom_widgets/login_register_button/login_register_button.dart';
import 'package:notice_board/ui/screens/student/add_idea-screen/add_idea_screen_vm.dart';
import 'package:notice_board/ui/custom_widgets/custom_multiselect_dropdown.dart';
import 'package:notice_board/ui/screens/student/student_home_screen/student_home_screen.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/student_root_screen/student_root_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/navigation_service.dart';

class AddIdeaScreen extends StatelessWidget {
  AddIdeaScreen({Key? key}) : super(key: key);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<Widget> listItems(List<PlatformFile> files) {
    List<Widget> items = [];
    for (var file in files) {
      items.add(Align(
        alignment: Alignment.topLeft,
        child: FittedBox(fit: BoxFit.scaleDown, child: Text(file.name)),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddIdeaScreenVM(),
      builder: (context, viewModel) {
        return Consumer<AddIdeaScreenVM>(
          builder: (context, vm, child) {
            return SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: kWhiteColor,
                body: Padding(
                  padding:
                      EdgeInsets.only(
                        left: 0.05.sw,
                        right: 0.05.sw,
                        top: 0.035.sh,
                        bottom: 0.01.sh,
                      ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Expanded(
                  flex: 10,
                      child: ListView(
                          shrinkWrap: true,
                          children: [

                          CustomLabeledTextfield(
                          onUpdate: (s) {
                  vm.setTitleValue = s;
                  },
                      maxLines: 1,
                      titleController: titleController,
                      labelText: "Project Title",
                      hintText: "Enter Title Here",
                  ),
                  SizedBox(
                      height: 15.h,
                  ),
                  CustomLabeledTextfield(
                      onUpdate: (s) {
                        vm.setDescriptionValue = s;
                      },
                      maxLines: 5,
                      titleController: descriptionController,
                      labelText: "Project Description",
                      hintText: "Enter Description Here",
                  ),
                  CustomMultiselectDropDown(
                        selectedList: (selectedlist) {
                          if (selectedlist.length == 3) {
                            BotToast.showText(
                                text: "That's it, Only 3 team members");
                          }
                          vm.setSelectedStudentsList = selectedlist;
                        },
                        userModelList: vm.listOfStudents,
                        limit: 3,
                        labelText: "Select Students"),
                  CustomMultiselectDropDown(
                        selectedList: (selectedlist) {

                          if (selectedlist.length == 4) {
                            BotToast.showText(
                                text: "That's it, Only 4 teachers");
                          }
                          vm.setSelectedTeachersList = selectedlist;
                        },
                        userModelList: vm.listOfTeachers,
                        limit: 4,
                        labelText: "Select Teachers"),
                  SizedBox(
                      height: 15.h,
                  ),
                  SizedBox(
                        height: 20.h,
                        width: 276.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              "IDEA TYPE : ",
                              style: kPoppinsRegular400.copyWith(
                                  fontSize: 15.sp),
                            ),
                            _myRadioButton(
                                title: "PROJECT",
                                value: 0,
                                context: context,
                                vm: vm
                              // onChanged: (newValue) => setState(() => _groupValue = newValue),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            _myRadioButton(
                              title: "RESEARCH",
                              value: 1,
                              context: context,
                              vm: vm,
                              //onChanged: (newValue) => setState(() => _groupValue = newValue),
                            ),
                          ],
                        )),
                  SizedBox(
                      height: 15.h,
                  ),
                  const Text("Select File/s"),
                  SizedBox(
                      height: 10.h,
                  ),
                  GestureDetector(
                      onTap: () async {
                        await vm.pickFiles();
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.library_add_rounded,
                            size: 40.r,
                          )),
                  ),
                  Container(
                      height: 100.h,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.r),
                        child: ListView(
                            children: listItems(vm.pickedFilesList).isEmpty
                            ? [
                            const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text("Selected files will show here"))
                            ]
                                : listItems(vm.pickedFilesList),
                      ),
                  ),),
                ],
              ),
                    ),
            Expanded(
            flex: 1,
              child: Row(
              children: [
              Expanded(

              child: LoginRegisterButton(onPressed: (){
            NavigationService().navigatePushReplacement(context,  StudentRootScreen());

            }, buttonText: "Back"),
              ),
              SizedBox(width: 20.w,),
              Expanded(
              child: LoginRegisterButton(onPressed: ()async{
              await vm.post(context);
              }, buttonText: "SUBMIT"),
              ),
              ],
              ),
            )
                    ],
                  )
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CustomLabeledTextfield extends StatelessWidget {
  CustomLabeledTextfield({
    Key? key,
    required this.titleController,
    required this.labelText,
    required this.hintText,
    required this.maxLines,
    required this.onUpdate,
  }) : super(key: key);

  final TextEditingController titleController;
  final String labelText;
  final String hintText;
  final int maxLines;
  Function(String s) onUpdate;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: titleController,
      maxLines: maxLines,
      onChanged: (value) {
        onUpdate(value);
      },
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: kPrimaryColor, width: 1.5)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: kPrimaryColor, width: 1.5)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: kPrimaryColor, width: 1.5))),
    );
  }
}

Widget _myRadioButton(
    {required String title,
    required int value,
    required BuildContext context,
    required AddIdeaScreenVM vm}) {
  return Row(children: [
    Text(
      title,
      style: kPoppinsRegular400.copyWith(
        fontSize: 14.sp,
      ),
    ),
    Container(
      width: 25.w,
      child: Transform.scale(
        scale: 0.75.r,
        child: Radio(
          activeColor: kPrimaryColor,
          value: value,
          groupValue: vm.groupValue,
          onChanged: (int? newValue) {
            vm.setGroupValue = newValue!;
          },
        ),
      ),
    )
  ]);
}
