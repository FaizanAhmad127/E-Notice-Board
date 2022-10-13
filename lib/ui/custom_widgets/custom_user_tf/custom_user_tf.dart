import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/services/validate_service.dart';

class CustomUserTF extends StatelessWidget {
  const CustomUserTF(
      {Key? key,
      this.textInputType = TextInputType.text,
      required this.hintText,
      required this.textEditingController,
      required this.icon,
      required this.validator,})
      : super(key: key);
  final String hintText;
  final TextEditingController textEditingController;
  final Icon icon;
  final TextInputType textInputType;

  final String?  Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        height: 40.h,
        width: 276.w,
        decoration: BoxDecoration(
            color: kTfFillColor, borderRadius: BorderRadius.circular(5.r)),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 50.w,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(5.r)),
              child: Center(
                child: icon,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Container(
                height: 40.h,
                width: 206.w,
                child: TextField(
                  controller: textEditingController,
                  style: kPoppinsLight300.copyWith(
                      fontSize: 14.sp, letterSpacing: 1),
                  keyboardType: textInputType,
                  // inputFormatters: [
                  //               FilteringTextInputFormatter.allow(
                  //                   RegExp('[a-zA-Z]')),
                  //             ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: kPoppinsLight300.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class Nameuser extends StatelessWidget {
   Nameuser(
      {Key? key,
      this.textInputType = TextInputType.text,
      required this.hintText,
      required this.textEditingController,
      required this.icon,required this.validator})
      : super(key: key);
  final String hintText;
  final TextEditingController textEditingController;
  final Icon icon;
  final TextInputType textInputType;
  
  final String?  Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        height: 40.h,
        width: 276.w,
        decoration: BoxDecoration(
            color: kTfFillColor, borderRadius: BorderRadius.circular(5.r)),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 50.w,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(5.r)),
              child: Center(
                child: icon,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Container(
                height: 40.h,
                width: 206.w,
                child: TextField(
                  controller: textEditingController,
                  style: kPoppinsLight300.copyWith(
                      fontSize: 14.sp, letterSpacing: 1),
                  keyboardType: textInputType,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: kPoppinsLight300.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class Emailuser extends StatelessWidget {
  const Emailuser(
      {Key? key,
      this.textInputType = TextInputType.emailAddress,
      required this.hintText,
      required this.textEditingController,
      required this.icon,
      required this.validator,
      })
      : super(key: key);
  final String hintText;
  final TextEditingController textEditingController;
  final Icon icon;
  final TextInputType textInputType;
  final String?  Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
   
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        height: 40.h,
        width: 276.w,
        decoration: BoxDecoration(
            color: kTfFillColor, borderRadius: BorderRadius.circular(5.r)),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 50.w,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(5.r)),
              child: Center(
                child: icon,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Container(
                height: 40.h,
                width: 206.w,
                child: TextFormField(
                  validator: validator,
                  controller: textEditingController,
                  style: kPoppinsLight300.copyWith(
                      fontSize: 14.sp, letterSpacing: 1),
                  keyboardType: textInputType,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp(('[[a-z0-9]@gmail.com],[a-z0-9]@yahoo.com],[a-z0-9]@twitter.com],]'))),
                  // ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: kPoppinsLight300.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
