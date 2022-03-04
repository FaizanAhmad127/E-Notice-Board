import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';

class StudentNotificationScreen extends StatelessWidget {
  const StudentNotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Padding(
      padding: EdgeInsets.only(top: 5.h,bottom: 5.h,right: 5.w,left: 5.w),
          child: ListView.builder(
            itemCount: 4,
              itemBuilder: (context,index)
          {
            return SizedBox(
              height: 110.h,
              width: 414.w,
              child: Card(
                color: kPostBackgroundColor,
                child: Padding(
                  padding: EdgeInsets.only(top: 19.h,left: 14.w,bottom: 23.w,right: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 30.r,

                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: FittedBox(
                                child: Text("Electronic Machines",
                                style: kPoppinsMedium500.copyWith(
                                  fontSize: 21.sp,
                                  color: kBlackColor,
                                ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: FittedBox(
                                child: Text("By Sana Haseeb",
                                  style: kPoppinsLight300.copyWith(
                                    fontSize: 16.sp,
                                    color: kBlackColor,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: FittedBox(
                                child: Text("9 Min ago",
                                  style: kPoppinsLight300.copyWith(
                                    fontSize: 12.sp,
                                    color: kDateColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 1,
                      child:
                  Align(
                    alignment: Alignment.center,
                    child: FittedBox(

                      child: Text("REVIWED",
                      style: kPoppinsMedium500.copyWith(
                        fontSize: 14.sp,
                        color: kAcceptedColor
                      ),),
                    ),
                  ))
                  ],
                ),
                ),
              ),
            );
          }),
      ),
      ),
    );
  }
}
