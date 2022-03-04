
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';

class LoginRegisterButton extends StatelessWidget {
  const LoginRegisterButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);
  final void Function() onPressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      width: 276.w,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kPrimaryColor),
          ),
          child: Center(child: Text(
            buttonText,
            style: kPoppinsRegular400.copyWith(
                color: kWhiteColor,
                fontSize: 20.sp
            ),))),
    );
  }
}


