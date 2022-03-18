import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/ui/custom_widgets/custom_password_tf/custom_password_tf.dart';
import 'package:notice_board/ui/custom_widgets/custom_user_tf/custom_user_tf.dart';
import 'package:notice_board/ui/custom_widgets/login_register_button/login_register_button.dart';
import 'package:notice_board/ui/screens/login/login_screen_vm.dart';
import 'package:notice_board/ui/screens/signup/signup_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  TextEditingController passwordTextEditingController=TextEditingController();
  TextEditingController emailTextEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
              create: (context) =>LoginScreenVM(),
              builder: (context, viewModel) {
                return SizedBox(
                  height: 359.h,
                  width: 309.w,
                  child: Card(
                    color: kPostBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 14.w,top: 19.h,right: 19.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                child: Text(
                                  "LOGIN",
                                  style: kPoppinsRegular400.copyWith(
                                      color: kPrimaryColor,
                                      fontSize: 30.sp
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Welcome to Portal",
                                  style: kPoppinsLight300.copyWith(
                                      color: kPrimaryColor,
                                      height: 1.sp,
                                      fontSize: 18.sp
                                  ),
                                ),
                              ),
                            ),
                          ),
                         
                          //UNIVERSITY ID TEXTFIELD
                          Expanded(
                            child: CustomUserTF(
                              textEditingController: emailTextEditingController,
                              hintText: "Enter your email",
                              icon: Icon(
                                Icons.account_circle,
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),

                          //PASSWORD TEXTFIELD
                          Expanded(
                            child: CustomPasswordTF(
                              textEditingController: passwordTextEditingController,
                              hintText: "Enter Password",
                            ),
                          ),
                          SizedBox(
                            height: 27.h,
                          ),

                          //LOGIN BUTTON
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: LoginRegisterButton(
                                buttonText: "LOG IN",
                                onPressed: ()
                                {

                                  Provider.of<LoginScreenVM>(context,listen:false).
                                  login(emailTextEditingController.text,
                                      passwordTextEditingController.text,context);
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),

                          //ROW CONTAINING TOGGLE AND FORGOT PASSWORD
                          Expanded(
                            child: SizedBox(
                              width: 1.sw,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: FittedBox(
                                              child: Text("Keep Logged In",
                                                style: kPoppinsLight300.copyWith(
                                                  fontSize: 10.sp,
                                                  color: kPrimaryColor,
                                                ),),
                                            ),
                                          ),
                                          //Toggle Switch
                                          Expanded(
                                            child: FittedBox(
                                              child: SizedBox(
                                                height: 30, //set desired REAL HEIGHT
                                                width: 35, //set desired REAL WIDTH
                                                child: Transform.scale(
                                                  transformHitTests: false,
                                                  scale: 0.32.r,
                                                  child: CupertinoSwitch(
                                                    value: Provider.of<LoginScreenVM>(context).getIsToggled,
                                                    onChanged: (value) {
                                                      Provider.of<LoginScreenVM>(context,listen: false).setIsToggled=value;
                                                    },
                                                    trackColor: kNavDisabledColor,
                                                    thumbColor: kPrimaryColor,
                                                    activeColor: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: FittedBox(

                                        child: Text("Forgot Password",
                                          style: kPoppinsLight300.copyWith(
                                            fontSize: 10.sp,
                                            color: kPrimaryColor,
                                          ),),
                                      ),
                                    ),
                                  ),
                                ],

                              ),
                            ),
                          ),


                          //NOT A MEMBER SIGNIN
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Center(
                                child: SizedBox(
                                  height: 23.h,
                                  width:170.w,
                                  child: Wrap(
                                      children: [
                                        Text(
                                          "Not a Member? ",
                                          style: kPoppinsLight300.copyWith(
                                              fontSize: 15.sp,
                                              color: kDateColor
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pushReplacement(context, PageTransition(
                                                duration: Duration(milliseconds: 500),
                                                type: PageTransitionType.leftToRightWithFade, child: SignupScreen(
                                            )));
                                          },
                                          child: Text(
                                            "SIGN IN",
                                            style: kPoppinsLight300.copyWith(
                                              fontSize: 15.sp,

                                            ),
                                          ),
                                        ),
                                      ]


                                  ),
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                );
              }

          ),
        ),
      ),
    );

  }
}
