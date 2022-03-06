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
                  height: 400.h,
                  width: 309.w,
                  child: Card(
                    color: kPostBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 14.w,top: 19.h,right: 19.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LOGIN",
                            style: kPoppinsRegular400.copyWith(
                                color: kPrimaryColor,
                                fontSize: 30.sp
                            ),
                          ),
                          Text(
                            "Welcome to Portal",
                            style: kPoppinsLight300.copyWith(
                                color: kPrimaryColor,
                                height: 1.sp,
                                fontSize: 18.sp
                            ),
                          ),
                          SizedBox(
                            height: 14.h,
                          ),

                          //UNIVERSITY ID TEXTFIELD
                          CustomUserTF(
                            textEditingController: emailTextEditingController,
                            hintText: "Enter your email",
                            icon: Icon(
                              Icons.account_circle,
                              color: kWhiteColor,
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),

                          //PASSWORD TEXTFIELD
                          CustomPasswordTF(
                            textEditingController: passwordTextEditingController,
                            hintText: "Enter Password",
                          ),
                          SizedBox(
                            height: 27.h,
                          ),

                          //LOGIN BUTTON
                          LoginRegisterButton(
                            buttonText: "LOG IN",
                            onPressed: ()
                            {

                              Provider.of<LoginScreenVM>(context).
                              login(emailTextEditingController.text,
                                  passwordTextEditingController.text);
                            },
                          ),
                          SizedBox(
                            height: 6.h,
                          ),

                          //ROW CONTAINING TOGGLE AND FORGOT PASSWORD
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("Keep Logged In",
                                    style: kPoppinsLight300.copyWith(
                                      fontSize: 10.sp,
                                      color: kPrimaryColor,
                                    ),),
                                  //Toggle Switch
                                  Container(
                                    height: 30, //set desired REAL HEIGHT
                                    width: 35, //set desired REAL WIDTH
                                    child: Transform.scale(
                                      transformHitTests: false,
                                      scale: .35,
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
                                ],
                              ),
                              Text("Forgot Password",
                                style: kPoppinsLight300.copyWith(
                                  fontSize: 10.sp,
                                  color: kPrimaryColor,
                                ),),
                            ],

                          ),

                          //USER TYPE RADIO BUTTON
                          SizedBox(
                              height: 20.h,
                              width: 276.w,
                              child:Row(
                                children: <Widget>[
                                  _myRadioButton(
                                      title: "Student",
                                      value: 0,
                                      context: context
                                    // onChanged: (newValue) => setState(() => _groupValue = newValue),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  _myRadioButton(
                                      title: "Teacher",
                                      value: 1,
                                      context: context
                                    //onChanged: (newValue) => setState(() => _groupValue = newValue),
                                  ),
                                ],
                              )
                          ),
                          SizedBox(
                            height: 15.h,
                          ),

                          //NOT A MEMBER SIGNIN
                          Center(
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
  Widget _myRadioButton({required String title, required int value,required BuildContext context}) {
    return Row(
      children:[
        Text(
          title,
        style: kPoppinsRegular400.copyWith(
          fontSize: 14.sp,
        ),),
        Container(
          width: 25.w,
          child: Transform.scale(
            scale: 0.75.r,
            child: Radio(
              activeColor: kPrimaryColor,
              value: value,
              groupValue: Provider.of<LoginScreenVM>(context).getGroupValue,
              onChanged: (int ?newValue) {
                Provider.of<LoginScreenVM>(context,listen: false).setGroupValue=newValue!;
              },
            ),
          ),
        )
      ]

    );



  }
}
