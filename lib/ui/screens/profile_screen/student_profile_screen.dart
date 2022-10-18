import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/ui/screens/profile_screen/student_profile_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/strings.dart';
import '../../../core/models/idea/idea_model.dart';
import '../../../core/models/user_authentication/user_signup_model.dart';
import '../../custom_widgets/bottom_sheet/bottom_sheet_widget.dart';
import '../../custom_widgets/bottom_sheet/form_submit_button_widget.dart';
import '../../custom_widgets/custom_post_card/custom_post_card.dart';
import '../coordinator/coordinator_home_screen/coordinator_home_screen.dart';

class StudentProfileScreen extends StatelessWidget {
  StudentProfileScreen(
      {Key? key, required this.userSignupModel, this.calledByUser = ''})
      : super(key: key);

  UserSignupModel userSignupModel;
  String dummyImageUrl = dummyPersonimage;
  final String calledByUser;

  ImageProvider buildImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return NetworkImage(userSignupModel.profilePicture ?? dummyImageUrl);
    } else {
      return NetworkImage(dummyImageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StudentProfileScreenVm(userSignupModel),
      builder: (context, vm) {
        return Consumer<StudentProfileScreenVm>(
          builder: (context, vm, child) {
            return Scaffold(
              backgroundColor: kWhiteColor,
              appBar: AppBar(
                backgroundColor: kWhiteColor,
                elevation: 0,
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: kBlackColor,
                    )),
                actions: calledByUser == 'coordinator'
                    ? [
                        Center(
                            child: GestureDetector(
                                onTap: ()async{
                                  await showModalBottomSheet(context: context, builder: (context)
                                  {
                                    return BottomSheetWidget(
                                      title: 'Are you sure?',
                                      bottomChild: FormSubmitButtonsWidget(
                                        confirmButtonOnPress: ()async{
                                          await vm.deleteStudent().whenComplete(() => Navigator.pop(context));
                                          Navigator.pop(context);

                                        },
                                        confirmButtonText: 'Yes',
                                        dangerButtonText: 'No, cancel the process',
                                        dangerButtonOnPress: ()=>Navigator.pop(context),
                                      ),
                                    );
                                  });
                                },
                              child: Text(
                          'Delete',
                          style:
                                kPoppinsMedium500.copyWith(color: kRejectedColor),
                        ),
                            )),
                        SizedBox(
                          width: 10.w,
                        )
                      ]
                    : [],
              ),
              body: Padding(
                padding: EdgeInsets.only(
                  left: 0.05.sw,
                  right: 0.05.sw,
                  top: 0.035.sh,
                  bottom: 0.01.sh,
                ),
                child: ListView(
                  children: [
                    Center(
                      child: Container(
                        height: 0.2.sh,
                        width: 0.2.sh,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: buildImage(
                                    userSignupModel.profilePicture))),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 5,
                          child: FittedBox(
                            child: Text(
                              '${userSignupModel.fullName}',
                              style: kPoppinsSemiBold600.copyWith(
                                  letterSpacing: 1.3,
                                  fontSize: 20.sp,
                                  color: kPrimaryColor),
                            ),
                          ),
                        ),
                        Flexible(
                          child: FittedBox(
                            child: Text(
                              ' (Student)',
                              style: kPoppinsSemiBold600.copyWith(
                                  letterSpacing: 1.3,
                                  fontSize: 13.sp,
                                  color: kPrimaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      'List of projects',
                      style: kPoppinsRegular400.copyWith(
                          letterSpacing: 1.3,
                          fontSize: 15.sp,
                          color: kPrimaryColor),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    SizedBox(
                        height: 0.52.sh,
                        child: vm.getIdeasList.isNotEmpty
                            ? ListView.builder(
                                itemCount: vm.getIdeasList.length,
                                itemBuilder: (context, index) {
                                  IdeaModel idea = vm.getIdeasList[index];
                                  return CustomPostCard(
                                    button: AcceptedRejectedButton(
                                      ideaId: vm.getIdeasList[index].ideaId,
                                      color: kFinPenPressedColor,
                                      text: "View Details",
                                    ),
                                    ideaModel: idea,
                                  );
                                })
                            : Text('No project available')),
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
