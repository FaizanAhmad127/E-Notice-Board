import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/ui/screens/view_details_screen/view_details_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../core/models/idea/file_model.dart';

class ViewDetailsScreen extends StatelessWidget {
  const ViewDetailsScreen({required this.ideaId, Key? key}) : super(key: key);

  final String ideaId;

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
                          child: Container(
                          color: Colors.grey,
                          height: 50.h,
                          width: 50.h,
                        )),
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

  List<Widget> filesListView(List<FileModel> files,ViewDetailsScreenVM vm)
  {
  List<Widget> widgetList = [];
  for (var file in files) {
    widgetList.add( GestureDetector(
      onTap: (){
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
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
                child: vm.ideaModel == null
                    ? const Center(
                        child: Text("Nothing to show yet"),
                      )
                    : ListView(
                        children: [
                          Center(
                            child: Text(
                              "Title: ${vm.ideaModel!.ideaTitle}",
                              style: kPoppinsSemiBold600.copyWith(
                                  fontSize: 24.sp, letterSpacing: 1.5),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            "Supervisor: ${vm.userSignupModel == null ? "Not Assigned Yet" : vm.userSignupModel!.fullName}",
                            style: kPoppinsMedium500.copyWith(
                              fontSize: 18.sp,
                            ),
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
                             ?const Center(
                                child:FittedBox(
                              child: Text("Uploaded files will appear here"),
                            ))
                            :ListView(
                              children: filesListView(vm.ideaModel!.filesList,vm),
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
