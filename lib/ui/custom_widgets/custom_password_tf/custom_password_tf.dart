import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/ui/custom_widgets/custom_password_tf/custom_password_tf_vm.dart';
import 'package:provider/provider.dart';

class CustomPasswordTF extends StatelessWidget {
  const CustomPasswordTF({
    Key? key,
    required this.hintText, required this.textEditingController,
  }) : super(key: key);

  final String hintText;
  final TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>CustomPasswordTfVM(),
      builder: (context,viewModel)
      {
        return  Container(
          height: 40.h,
          width: 276.w,
          decoration: BoxDecoration(
              color: kTfFillColor,
              borderRadius: BorderRadius.circular(5.r)
          ),
          child: Row(
            children: [
              Container(
                height: 40.h,
                width: 50.w,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(5.r)
                ),
                child: Center(
                  child: Icon(
                    Icons.lock,
                    color: kWhiteColor,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Container(
                  height: 40.h,
                  width: 206.w,
                  child: TextField(
                    obscureText: Provider.of<CustomPasswordTfVM>(context).getIsObscure,
                    controller: textEditingController,
                    style: kPoppinsLight300.copyWith(
                        fontSize: 14.sp,
                        letterSpacing: 1
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: kPoppinsLight300.copyWith(
                        fontSize: 14.sp,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: ()
                        {
                          if(Provider.of<CustomPasswordTfVM>(context,listen: false).getIsObscure==false)
                            {
                              Provider.of<CustomPasswordTfVM>(context,listen: false).setIsObscure=true;
                            }
                          else
                            {
                              Provider.of<CustomPasswordTfVM>(context,listen: false).setIsObscure=false;
                            }
                        },
                        child: Provider.of<CustomPasswordTfVM>(context).getIsObscure==false?Icon(
                          Icons.visibility,
                          size: 22.r,

                        ):Icon(
                          Icons.visibility_off,
                          size: 22.r,

                        ),
                      ),


                    ),
                  ))
            ],
          ),
        );
      },
    );
  }
}