import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
class custom_post_card extends StatelessWidget {
  const custom_post_card({
    Key? key,
    required this.button,
  }) : super(key: key);
 final Widget button;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 173.h,
      child: Card(
        elevation: 1,
        color: kPostBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(top: 10.h,bottom: 5.h,left: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                        flex:3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex:1,
                              child: Align(
                                alignment:Alignment.topLeft,
                                child: CircleAvatar(
                                  radius: 30.r,
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: FittedBox(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "ALI KHAN ",
                                          style: kPoppinsMedium500.copyWith(
                                              fontSize: 20.sp
                                          ),
                                        ),
                                        Text("25 February, 2022",
                                          style: kPoppinsLight300.copyWith(
                                            fontSize: 15.sp,
                                            color: kDateColor,
                                          ),)
                                      ],),
                                  ),
                                ))
                          ],
                        )),
                    //
                    Expanded(
                        flex:1,
                        child: Align(
                            alignment: Alignment.topRight,
                            child: button))
                  ],
                ),
              ),
              Expanded(child: FittedBox(
                child: Text("TITLE: Auto Machine",
                  style: kPoppinsMedium500.copyWith(
                    fontSize: 15.sp,
                  ),),
              )),
              Expanded(
                  flex: 3,
                  child:  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing "
                              +"elit. Aenean sodales, tellus vehicula feugiat vulputate, ante nu"
                              +"lla aliquet arcu, a lobortis lectus lacus vestibulum leo. "+
                              "Crassed accumsan est, nec euismod eros.",
                            textAlign: TextAlign.start,
                            maxLines: 6,
                            style: kPoppinsLight300.copyWith(
                                fontSize: 12.sp,
                                color: kDateColor

                            ),),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container())
                    ],
                  )),

            ],
          ),
        ),
      ),
    );
  }
}