import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/ui/custom_widgets/custom_password_tf/custom_password_tf.dart';
import 'package:notice_board/ui/custom_widgets/custom_user_tf/custom_user_tf.dart';
import 'package:notice_board/ui/custom_widgets/login_register_button/login_register_button.dart';
import 'package:notice_board/ui/screens/changepassword/change_password_screen_vm.dart';
import 'package:notice_board/ui/screens/login/login_screen.dart';
import 'package:notice_board/ui/screens/signup/signup_screen_vm.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';


class ChangePasswordScreen extends StatelessWidget {
   ChangePasswordScreen({Key? key}) : super(key: key);
  final TextEditingController emailTextEditingController=TextEditingController();
   final TextEditingController uniIdTextEditingController=TextEditingController();
   final TextEditingController fullNameTextEditingController=TextEditingController();
   final TextEditingController passwordTextEditingController=TextEditingController();
   final TextEditingController newPasswordTextEditingController=TextEditingController();
   final TextEditingController confirmPasswordTextEditingController=TextEditingController();

final formKey =GlobalKey<FormState>();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child:  ChangeNotifierProvider(
            create: (context) =>ChangePasswordScreenVM(),

            builder: (context, viewModel) {
              return SizedBox(
                  height: 457.h,
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          child: Text(
                          "Change Password",
                          style: kPoppinsRegular400.copyWith(
                              color: kPrimaryColor,
                              fontSize: 25.sp
                          ),
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
                              hintText: "Enter Old Password",
                            
                              validator: (value) {
                              if(value!.length<6){
                                return 'Invalid Password';
                              }
                              return null;
                            },
                            ), 
                            
                          ),
                        ),

                        const Expanded(
                            child: SizedBox()),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: CustomPasswordTF(
                              textEditingController: newPasswordTextEditingController,
                              hintText: "Enter New Password",

                              validator: (value) {
                              if(value!.length<6){
                                return 'Invalid Password';
                              }
                              return null;
                            },
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
                               validator: (value) {
                              if(passwordTextEditingController.text!=confirmPasswordTextEditingController.text){
                                return ' Password do not match!!';
                              }
                              return null;
                            },
                            ),
                          ),
                        ),
                        const Expanded(
                            child: SizedBox()),
                        //USER TYPE RADIO BUTTON
                        const Expanded(
                            child: SizedBox()),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: LoginRegisterButton(
                              buttonText: "Change",
                              onPressed: ()
                              {
                                if(formKey.currentState!.validate()) {
                                Provider.of<ChangePasswordScreenVM>(context,listen: false).changePassword(
                                    context,
                                    newPasswordTextEditingController.text,
                                    passwordTextEditingController.text,
                                    confirmPasswordTextEditingController.text,

                                );}
                              },
                            ),
                          ),
                        ),
                        const Expanded(
                            child: SizedBox()),
                      ],
                    ),
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
              groupValue: Provider.of<ChangePasswordScreenVM>(context).getGroupValue,
              onChanged: (int ?newValue) {
                Provider.of<ChangePasswordScreenVM>(context,listen: false).setGroupValue=newValue!;
              },
            ),
          ),
        )
      ]

  );

}
}



