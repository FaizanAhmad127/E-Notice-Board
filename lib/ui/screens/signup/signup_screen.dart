import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/ui/custom_widgets/custom_password_tf/custom_password_tf.dart';
import 'package:notice_board/ui/custom_widgets/custom_user_tf/custom_user_tf.dart';
import 'package:notice_board/ui/custom_widgets/login_register_button/login_register_button.dart';
import 'package:notice_board/ui/screens/login/login_screen.dart';
import 'package:notice_board/ui/screens/signup/signup_screen_vm.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';


class SignupScreen extends StatelessWidget {
   SignupScreen({Key? key}) : super(key: key);
  final TextEditingController emailTextEditingController=TextEditingController();
   final TextEditingController uniIdTextEditingController=TextEditingController();
   final TextEditingController fullNameTextEditingController=TextEditingController();
   final TextEditingController passwordTextEditingController=TextEditingController();
   final TextEditingController confirmPasswordTextEditingController=TextEditingController();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child:  ChangeNotifierProvider(
            create: (context) =>SignupScreenVM(),
            builder: (context, viewModel) {
              return SizedBox(
                  height: 497.h,
                  width: 309.w,
                child:  Card(
                color: kPostBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
              ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 24.h,
                    left: 14.w,
                    bottom: 42.h,
                    right: 19.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                    "SIGN UP",
                    style: kPoppinsRegular400.copyWith(
                        color: kPrimaryColor,
                        fontSize: 30.sp
                    ),
                  ),
                  Text(
                    "Let's help to meet up your task",
                    style: kPoppinsLight300.copyWith(
                        color: kPrimaryColor,
                        height: 1.sp,
                        fontSize: 16.sp
                    ),),
                      SizedBox(
                        height: 17.h,
                      ),
                      CustomUserTF(
                        textEditingController: emailTextEditingController,
                        hintText: "Enter your email",
                        icon: Icon(
                          Icons.alarm,
                          color: kWhiteColor,
                        ),
                      ),
                    SizedBox(
                      height: 10.h,
                    ),
                      CustomUserTF(
                        textEditingController: uniIdTextEditingController,
                        hintText: "Enter University ID",
                        icon: Icon(
                          Icons.account_circle,
                          color: kWhiteColor,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomUserTF(
                        textEditingController: fullNameTextEditingController,
                        hintText: "Enter Full Name",
                        icon: Icon(
                          Icons.account_circle,
                          color: kWhiteColor,
                        ),
                      ),
                      SizedBox(
                        height: 11.h,
                      ),
                      CustomPasswordTF(
                        textEditingController: passwordTextEditingController,
                        hintText: "Enter Password",
                      ),
                      SizedBox(
                        height: 11.h,
                      ),
                      CustomPasswordTF(
                        textEditingController: confirmPasswordTextEditingController,
                        hintText: "Confirm Password",
                      ),
                      SizedBox(
                        height: 26.h,
                      ),
                      LoginRegisterButton(
                        buttonText: "REGISTER",
                        onPressed: ()
                        {

                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Center(
                        child: SizedBox(
                          height: 23.h,
                          child: Wrap(
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: kPoppinsLight300.copyWith(
                                      fontSize: 16.sp,
                                      color: kDateColor
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pushReplacement(context, PageTransition(
                                        duration: Duration(milliseconds: 500),
                                        type: PageTransitionType.leftToRightWithFade, child: LoginScreen(
                                    )));
                                  },
                                  child: Text(
                                    "LOGIN ",
                                    style: kPoppinsLight300.copyWith(
                                      fontSize: 16.sp,

                                    ),
                                  ),
                                ),
                              ]


                          ),
                        ),
                      )
                    ],
                  ),
                ),),
          );
    },
        ),
      ),
    ));
  }
}
