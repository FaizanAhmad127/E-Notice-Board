import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
class ListItem extends StatelessWidget {
  const ListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116.h,
      width: 124.w,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 86.w,
                    height:22.h ,
                    color: kAcceptedColor,
                    child: Center(
                      child: FittedBox(
                        child: Text("Approved",
                          style: kPoppinsMedium500.copyWith(
                              fontSize: 15.sp,
                              color: kWhiteColor
                          ),),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 7,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 13.h,horizontal: 7.w),
                    child: Column(
                      children: [
                        Expanded(
                          child: FittedBox(child:
                          Text("E-Notice Board",
                            style: kPoppinsMedium500.copyWith(
                              fontSize: 15.sp,
                            ),),),
                        ),
                        Expanded(
                          child: FittedBox(child:
                          Text("3 March, 2022",
                            style: kPoppinsLight300.copyWith(
                              fontSize: 12.sp,
                            ),),),
                        ),
                        Expanded(
                          child: FittedBox(child:
                          Text("Teacher: Ali Khan",
                            style: kPoppinsMedium500.copyWith(
                              fontSize: 10.sp,
                            ),),),
                        ),


                      ],
                    ),
                  )
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FittedBox(
                      child:
                  Container(
                    height: 5.h,
                    width: 124.w,
                    color: kPrimaryColor,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
