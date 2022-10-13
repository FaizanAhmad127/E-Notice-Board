import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/models/notification/signup_request_model.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/core/services/notification/signup_request_service.dart';
import 'package:notice_board/ui/screens/login/login_screen.dart';
import 'package:page_transition/page_transition.dart';
import '../../../core/services/user_authentication/user_auth_service.dart';
import '../../../core/services/validate_service.dart';

class ChangePasswordScreenVM extends ChangeNotifier
{
  int _groupValue = 0;

  //GetIt is a package used to create singleton design pattern.
  final UserAuthService _userAuthService=GetIt.I.get<UserAuthService>();

  final SignupRequestService _requestService=GetIt.I.get<SignupRequestService>();

  void changePassword(BuildContext context,String newPassword,String password,String confirmPassword)async
  {
    int dateTime=(DateTime.now().millisecondsSinceEpoch);

    try {
      if (Validate().validateChangePassword(
          newPassword, password, confirmPassword))
      {
        _changePassword(password,newPassword,context);
      }
    }
    catch(error)
    {
      BotToast.showText(text: "$error");
    }


  }

  void _changePassword(String currentPassword, String newPassword, BuildContext context) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user?.email?.toString()??"", password: currentPassword);

    user?.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        //Success, do something
        BotToast.showText(text: "Password changed successfully",duration: Duration(seconds: 3));
        Navigator.pushReplacement(context, PageTransition(
            duration: Duration(milliseconds: 500),
            type: PageTransitionType.leftToRightWithFade, child: LoginScreen(
        )));
      }).catchError((error) {
        //Error, show something
      });
    }).catchError((err) {

    });}






  int get getGroupValue=>_groupValue;
  
  set setGroupValue(int a)
  {
    _groupValue=a;
    notifyListeners();
  }

  String userType()
  {
    String userType="";
    if(getGroupValue==0)
      {
        userType="student";
      }
    if(getGroupValue==1)
    {
      userType= "teacher";
    }
    return userType;
  }
}