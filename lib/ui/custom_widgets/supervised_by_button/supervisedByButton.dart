import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
class SupervisedByButton extends StatelessWidget {
  const SupervisedByButton({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      width: 100.w,
      child: ElevatedButton(
        onPressed: ()
        {

        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w)),
          backgroundColor: MaterialStateProperty.all(kSupervisedByColor),
        ),
        child: FittedBox(
            fit: BoxFit.cover,
            child: Column(
              children: [
                Text(
                    "Supervised by",
                  style: kPoppinsLight300.copyWith(
                    fontSize: 12.sp,
                    color: kWhiteColor,
                  ),
                ),
                Text(
                  "Qazi Haseeb",
                  style: kPoppinsMedium500.copyWith(
                    fontSize: 15.sp,
                    color: kWhiteColor,
                  ),
                )
              ],

            )),
      ),
    );
  }
}

