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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: FittedBox(
                          child: Text(
                          "SIGN UP",
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
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "Let's help to meet up your task",
                          style: kPoppinsLight300.copyWith(
                              color: kPrimaryColor,
                              height: 1.sp,
                              fontSize: 16.sp
                          ),),
                      ),
                    ),
                  ),
                      const Expanded(
                          child: SizedBox()),
                      Expanded(
                        child: CustomUserTF(
                          textEditingController: emailTextEditingController,
                          hintText: "Enter your email",
                          icon: Icon(
                            Icons.alarm,
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                    const Expanded(
                        child: SizedBox(
                        )),
                      Expanded(
                        child: CustomUserTF(
                          textInputType: TextInputType.number,
                          textEditingController: uniIdTextEditingController,
                          hintText: "Enter University ID",
                          icon: Icon(
                            Icons.account_circle,
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                      const Expanded(
                          child: SizedBox()),
                      Expanded(
                        child: CustomUserTF(
                          textEditingController: fullNameTextEditingController,
                          hintText: "Enter Full Name",
                          icon: Icon(
                            Icons.account_circle,
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                      const Expanded(
                          child: SizedBox()),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: CustomPasswordTF(
                            textEditingController: passwordTextEditingController,
                            hintText: "Enter Password",
                          ),
                        ),
                      ),
                      const Expanded(
                          child: SizedBox()),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: CustomPasswordTF(
                            textEditingController: confirmPasswordTextEditingController,
                            hintText: "Confirm Password",
                          ),
                        ),
                      ),
                      const Expanded(
                          child: SizedBox()),
                      //USER TYPE RADIO BUTTON
                      Expanded(
                        child: FittedBox(
                          child: SizedBox(
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
                        ),
                      ),
                      const Expanded(
                          child: SizedBox()),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: LoginRegisterButton(
                            buttonText: "REGISTER",
                            onPressed: ()
                            {
                              Provider.of<SignupScreenVM>(context,listen: false).signup(
                                  context,
                                  emailTextEditingController.text,
                                  passwordTextEditingController.text,
                                  confirmPasswordTextEditingController.text,
                                  fullNameTextEditingController.text,
                                  uniIdTextEditingController.text);
                            },
                          ),
                        ),
                      ),
                      const Expanded(
                          child: SizedBox()),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Center(
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
              groupValue: Provider.of<SignupScreenVM>(context).getGroupValue,
              onChanged: (int ?newValue) {
                Provider.of<SignupScreenVM>(context,listen: false).setGroupValue=newValue!;
              },
            ),
          ),
        )
      ]

  );



}
}



