import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/services/date_time_service.dart';
import 'package:notice_board/ui/custom_widgets/custom_post_card/custom_post_card_vm.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/strings.dart';
import '../../screens/student/student_home_screen/student_home_screen.dart';

class CustomPostCard extends StatelessWidget {
  CustomPostCard({Key? key, required this.button, required this.ideaModel})
      : super(key: key);
  Widget button;
  final IdeaModel ideaModel;
  late String _dateTimeText;

  @override
  Widget build(BuildContext context) {
    _dateTimeText = DateTimeService().getDMY(timeStamp: ideaModel.timestamp);
    return ChangeNotifierProvider(
      create: (context) => CustomPostCardVM(ideaModel.ideaOwner),
      builder: (context, viewmodel) {
        return Consumer<CustomPostCardVM>(
          builder: (context, vm, child) {
            return SizedBox(
              // height: 150.h,
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                elevation: 1,
                color: kPostBackgroundColor,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 5.h, left: 15.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // you can enter title after the double comma and before the dollar sign
                                "${ideaModel.ideaTitle}",
                                // overflow: TextOverflow.ellipsis,
                                style: kPoppinsMedium500.copyWith(
                                  fontSize: 20.sp,
                                ),
                              ),
                            ],
                          )),
                          SizedBox(width: 10),
                          Align(
                            alignment: Alignment.topRight,
                            child: button,
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: SingleChildScrollView(
                              child: Text(
                                ideaModel.ideaDescription,
                                textAlign: TextAlign.start,
                                maxLines: 6,
                                style: kPoppinsLight300.copyWith(
                                    fontSize: 12.sp, color: kDateColor),
                              ),
                            ),
                          ),
                          Expanded(flex: 1, child: Container())
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: vm.pictureUrl.isEmpty
                                      ? ClipOval(
                                          child:  CachedNetworkImage(
                                            imageUrl: dummyPersonimage,
                                            fit: BoxFit.fill,
                                            height: 50.h,
                                            width: 50.h,
                                          ),
                                        )
                                      : ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: vm.pictureUrl,
                                            fit: BoxFit.fill,
                                            height: 40.h,
                                            width: 40.h,
                                          ),
                                        )),
                              SizedBox(
                                width: 10.w,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: FittedBox(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          vm.getUserName,
                                          style: kPoppinsMedium500.copyWith(
                                              fontSize: 17.sp),
                                        ), Text(
                                          vm.getUserID,
                                          style: kPoppinsRegular400.copyWith(
                                              fontSize: 15.sp),
                                        ),
                                        Text(
                                          _dateTimeText,
                                          style: kPoppinsLight300.copyWith(
                                            fontSize: 12.sp,
                                            color: kDateColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          //
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
