import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/ui/screens/profile_screen/student_profile_screen.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/colors.dart';
import '../../../custom_widgets/custom_search_field/custom_search_field.dart';
import 'coordinator_student_list_screen_vm.dart';


class CoordinatorStudentListScreen extends StatelessWidget {
  const CoordinatorStudentListScreen({Key? key}) : super(key: key);

  Widget getItem(UserSignupModel student,BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: ()
      {
        NavigationService().navigatePush(context,
            StudentProfileScreen( userSignupModel: student));
      },
      child: SizedBox(
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
                              student.profilePicture==""? ClipOval(
                                child: Container(
                                  color: Colors.grey,
                                  height: 50.h,
                                  width: 50.h,
                                ),
                              ):
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: student.profilePicture ?? "",
                                  fit: BoxFit.fill,
                                  height: 50.h,
                                  width: 50.h,
                                ),
                              ),
                              student.onlineStatus=="offline"?
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
                                Text(student.fullName??"",
                                  style: kPoppinsSemiBold600.copyWith(
                                      fontSize: 20.sp
                                  ),),),
                            ),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child:
                                Text(student.occupation??"",
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CoordinatorStudentListScreenVM(),
      builder: (context, viewModel) {
        return Scaffold(
          backgroundColor: kWhiteColor,
          body: SingleChildScrollView(
            child: Consumer<CoordinatorStudentListScreenVM>(
              builder: (context, vm, child) {
                return Column(
                  children: [

                    // Search box
                    CustomSearchField(
                        searchTextEditingController: vm.searchController,
                    hintText: "Search by name",),
                    SizedBox(
                      height: 16.h,
                    ),
                    vm.getSearchList.isEmpty ?
                    const Center(child: Text("Nothing to show")) :
                    Padding(
                      padding: EdgeInsets.only(left: 4.w, right: 4.w),
                      child: SizedBox(
                          height: 0.7.sh,
                          child: ListView.builder(
                              itemCount: vm.getSearchList.length,
                              itemBuilder: (context, index) {
                                UserSignupModel student = vm
                                    .getSearchList[index];
                                return getItem(student,context);
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

