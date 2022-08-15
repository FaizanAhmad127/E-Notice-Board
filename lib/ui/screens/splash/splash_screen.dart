import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 227.h,
              width: 200.w,
              child: const FittedBox(
                child: Image(
                  image: AssetImage("assets/images/city_uni_logo.png"),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              "CITY UNIVERSITY",
              style: kPoppinsRegular400.copyWith(
                  color: kWhiteColor,
                  fontSize: 35.sp,
                  wordSpacing: 5.sp
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "OF SCIENCE & INFORMATION TECHNOLOGY, PESHAWAR",
              style: kPoppinsLight300.copyWith(
                  color: kWhiteColor,
                  fontSize: 12.sp,
                  wordSpacing: 1.sp
              ),
            ),
          ],

        ),
      ),
    );


  }
}
