import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    Key? key,
    required this.searchTextEditingController,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController searchTextEditingController;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 17.h,left: 4.w,right: 4.w),
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
            color:kWhiteColor,
            border: Border.all(
                color: kTfBorderColor
            ),
            borderRadius: BorderRadius.circular(5.r)
        ),
        child: Row(
          children: [
            Container(
              //height: 40.h,
              width: 50.w,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(5.r)
              ),
              child: Center(
                child: Icon(Icons.search,color: kWhiteColor,),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            FittedBox(
              child: Container(
                  height: 40.h,
                  width: 300.w,
                  child: Center(
                    child: TextField(
                      controller: searchTextEditingController,

                      style: kPoppinsLight300.copyWith(
                          fontSize: 16.sp,
                          letterSpacing: 1,
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dotted,
                        decorationColor: kWhiteColor
                      ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10.h),
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: kPoppinsLight300.copyWith(
                            fontSize: 16.sp,
                            color:kSearchTFHintColor,

                        ),



                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
