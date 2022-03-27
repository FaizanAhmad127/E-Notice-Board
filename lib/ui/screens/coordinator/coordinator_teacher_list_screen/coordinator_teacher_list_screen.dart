import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_teacher_list_screen/coordinator_teacher_list_screen_vm.dart';
import 'package:notice_board/ui/screens/student/student_teacherList_screen/student_teacherList_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';
import '../../../custom_widgets/custom_search_field/custom_search_field.dart';


class CoordinatorTeacherListScreen extends StatelessWidget {
  const CoordinatorTeacherListScreen({Key? key}) : super(key: key);

  Widget getItem(UserSignupModel teacher) {
    return SizedBox(
        width: double.infinity,
        height: 80.h,
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              bottom: 10.h,
            ),
            child: Row(
              children: [
                Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Stack(
                          children: [
                            teacher.profilePicture==""? ClipOval(
                              child: Container(
                                color: Colors.grey,
                                height: 50.h,
                                width: 50.h,
                              ),
                            ):
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: teacher.profilePicture ?? "",
                                fit: BoxFit.fill,
                                height: 50.h,
                                width: 50.h,
                              ),
                            ),
                            teacher.onlineStatus=="offline"?
                            const SizedBox():
                            Positioned(
                              bottom: 1.h,
                              right: 5.w,
                              child: CircleAvatar(
                                backgroundColor: kAcceptedColor,
                                radius: 7.r,
                              ),)
                          ],
                        )
                    )
                ),

                Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child:
                              Text(teacher.fullName??"",
                                style: kPoppinsSemiBold600.copyWith(
                                    fontSize: 20.sp
                                ),),),
                          ),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child:
                              Text(teacher.occupation??"",
                                style: kPoppinsLight300.copyWith(
                                    fontSize: 15.sp,
                                    color: kDateColor
                                ),),),
                          )
                        ],
                      ),
                    )),

              ],
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CoordinatorTeacherListScreenVM(),
      builder: (context, viewModel) {
        return Scaffold(
          backgroundColor: kWhiteColor,
          body: SingleChildScrollView(
            child: Consumer<CoordinatorTeacherListScreenVM>(
              builder: (context, vm, child) {
                return Column(
                  children: [

                    // Search box
                    custom_search_field(
                        searchTextEditingController: vm.searchController,
                      hintText: "Search by name",),
                    SizedBox(
                      height: 16.h,
                    ),
                    vm.getSearchList.isEmpty ?
                    Center(child: const Text("Nothing to show")) :
                    Padding(
                      padding: EdgeInsets.only(left: 4.w, right: 4.w),
                      child: SizedBox(
                          height: 0.7.sh,
                          child: ListView.builder(
                              itemCount: vm.getSearchList.length,
                              itemBuilder: (context, index) {
                                UserSignupModel teacher = vm
                                    .getSearchList[index];
                                return getItem(teacher);
                              })
                      ),
                    )

                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

