import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/ui/custom_widgets/bottom_sheet/bottom_sheet_widget.dart';
import 'package:notice_board/ui/screens/student/add_idea-screen/add_idea_screen.dart';
import 'package:notice_board/ui/screens/view_details_screen/view_details_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/strings.dart';
import '../../../core/models/idea/file_model.dart';
import '../../custom_widgets/bottom_sheet/dropdown_picker_widget.dart';
import '../../custom_widgets/bottom_sheet/form_submit_button_widget.dart';
import '../../custom_widgets/custom_user_tf/custom_user_tf.dart';

class ViewDetailsScreen extends StatefulWidget {
  const ViewDetailsScreen({required this.ideaId, this.currentUser = "",Key? key}) : super(key: key);
final String ideaId;
final String currentUser;
  @override
  State<ViewDetailsScreen> createState() => _ViewDetailsScreenState();
}

class _ViewDetailsScreenState extends State<ViewDetailsScreen> {
   late String ideaId;
   late String currentUser='';
  final TextEditingController titleController=TextEditingController() ;
  String ?groupValue='';

  @override
  void initState()
  {
    super.initState();
   ideaId=widget.ideaId;
   currentUser=widget.currentUser;

  }
  List<Widget> studentListView(List<UserSignupModel> studentsList) {
    List<Widget> widgetList = [];
    for (var student in studentsList) {
      widgetList.add(Padding(
        padding: EdgeInsets.only(right: 15.w),
        child: SizedBox(
          width: 100.w,
          height: 150.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: student.profilePicture == ""
                    ? FittedBox(
                  child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: dummyPersonimage,
                        fit: BoxFit.fill,
                        height: 50.h,
                        width: 50.h,
                      ),),
                )
                    : FittedBox(
                  child: ClipOval(
                    child: FittedBox(
                      child: CachedNetworkImage(
                        imageUrl: student.profilePicture ?? "",
                        fit: BoxFit.fill,
                        height: 50.h,
                        width: 50.h,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    student.fullName ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: kPoppinsMedium500.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      student.occupation ?? "",
                      style: kPoppinsRegular400.copyWith(
                          fontSize: 11.sp, color: kDateColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return widgetList;
  }

  List<Widget> filesListView(List<FileModel> files, ViewDetailsScreenVM vm) {
    List<Widget> widgetList = [];
    for (var file in files) {
      widgetList.add(GestureDetector(
        onTap: () {
          vm.downloadFile(file.fileUrl);
        },
        child: SizedBox(
          width: 0.8.sw,
          height: 20.h,
          child: Align(
            alignment: Alignment.topLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(file.fileName,
                style: kPoppinsMedium500.copyWith(
                    color: Colors.blue
                ),),
            ),
          ),
        ),
      ));
    }

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ViewDetailsScreenVM(ideaId),
      builder: (context, viewModel) {
        return Consumer<ViewDetailsScreenVM>(
          builder: (context, vm, child) {
            return Scaffold(
              backgroundColor: kWhiteColor,

              appBar: AppBar(
                elevation: 0,
                backgroundColor: kWhiteColor,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, color: kBlackColor,),
                ),
                actions: currentUser == "coordinator" ?
                [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: ()async{
                              await showModalBottomSheet(context: context, builder: (context)
                              {
                                return BottomSheetWidget(
                                  title: 'Are you sure?',
                                  bottomChild: FormSubmitButtonsWidget(
                                    confirmButtonOnPress: ()async{
                                      await vm.deleteIdea().whenComplete(() => Navigator.pop(context));
                                      Navigator.pop(context);

                                    },
                                    confirmButtonText: 'Yes',
                                    dangerButtonText: 'No, cancel the process',
                                    dangerButtonOnPress: ()=>Navigator.pop(context),
                                  ),
                                );
                              });
                            },
                            child: Text('Delete',
                                style: kPoppinsMedium500.copyWith(
                                    color: kRejectedColor,
                                    fontSize: 15
                                )),
                          ),
                        ],
                      ),
                    ),
                  )
                ]
                    : [],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
                child: vm.ideaModel == null
                    ? const Center(
                  child: Text("Nothing to show yet"),
                )
                    : ListView(
                  shrinkWrap: true,
                  children: [
                    Center(
                      child: RichText(text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Title: ${vm.ideaModel!.ideaTitle}",
                            style: kPoppinsSemiBold600.copyWith(
                                fontSize: 22.sp, letterSpacing: 1.3),
                          ),
                          if( currentUser == "coordinator" )
                            TextSpan(text: 'Edit',
                              recognizer: TapGestureRecognizer() ..onTap = ()  async{
                                titleController.text=vm.ideaModel!.ideaTitle;
                                await showModalBottomSheet(context: context,
                                    isScrollControlled: true,
                                    builder: (context)
                                    {
                                      return BottomSheetWidget(
                                        fullHeight: true,
                                        title: 'Choose title',
                                        bottomChild: FormSubmitButtonsWidget(
                                          confirmButtonOnPress: ()async{
                                            await vm.setTitle(titleController.text);
                                            Navigator.pop(context);

                                          },
                                          confirmButtonText: 'Submit',

                                        ),
                                        child: SizedBox(
                                          width: 0.8.sw,
                                          child: CustomUserTF(
                                            hintText: 'Title',
                                            textEditingController:
                                            titleController,
                                            icon: Icon(Icons.abc,color: kWhiteColor,),
                                          ),
                                        ),
                                      );
                                    });
                              } ,
                              style: kPoppinsMedium500.copyWith(
                                  color: Colors.blue,
                                  fontSize: 15
                              ),
                            ),
                        ],
                      )),

                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Text(
                          "Supervisor: ${vm.userSignupModel == null
                              ? "Not Assigned Yet"
                              : vm.userSignupModel!.fullName}",
                          style: kPoppinsMedium500.copyWith(
                            fontSize: 17.sp,
                          ),
                        )),
                        if( currentUser == "coordinator" )
                        Expanded(child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: ()async
                            {
                              Map<String,Object> map={};
                              for (var element in vm.listOfTeachers) {
                                map[element.fullName??'']=element.uid??'';
                              }

                              await showModalBottomSheet(context: context,
                                  isScrollControlled: true,
                                  builder: (context)
                                  {
                                    ScrollController scrollController=ScrollController()  ;
                                    return DropdownPickerContentWidget(
                                      title: 'Choose supervisor',
                                      options: map,
                                      value: map[vm.userSignupModel?.fullName??''],
                                      onChanged: (val)async{
                                        if(val!=vm.userSignupModel?.uid)
                                          {
                                            await vm.changeSupervisor(val.toString());
                                          }

                                      },
                                    );
                                  });
                            },
                            child: Text('Choose',
                            style: kPoppinsSemiBold600.copyWith(
                              color: Colors.blue,

                            ),),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Students Details :",
                      style: kPoppinsMedium500.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 100.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: studentListView(vm.listOfStudents),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Project Details :",
                      style: kPoppinsMedium500.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    SizedBox(
                      height: 100.h,
                      child: SingleChildScrollView(
                        child: Text(
                          vm.ideaModel!.ideaDescription,
                          style: kPoppinsLight300.copyWith(
                              fontSize: 12.sp,
                              color: kDateColor,
                              wordSpacing: 1.2,
                              letterSpacing: 1
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Uploaded Files :",
                      style: kPoppinsMedium500.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    SizedBox(
                      height: 100.h,
                      child: vm.listOfFiles.isEmpty
                          ? const Center(
                          child: FittedBox(
                            child: Text("Uploaded files will appear here"),
                          ))
                          : ListView(
                        children: filesListView(vm.ideaModel!.filesList, vm),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

