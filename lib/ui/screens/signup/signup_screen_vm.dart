import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';
import 'package:page_transition/page_transition.dart';

import '../../../core/services/user_authentication/user_auth_service.dart';
import '../../../core/services/validate_service.dart';
import '../login/login_screen.dart';

class SignupScreenVM extends ChangeNotifier
{
  int _groupValue = 0;

  final UserAuthService _userAuthService=GetIt.I.get<UserAuthService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  void signup(BuildContext context,String email,String password,String confirmPassword, String fullName,String universityId)async
  {
    if(Validate().validateSignup(email, password,confirmPassword,fullName,universityId))
    {

        await _userAuthService.userSignup(email, password).then((uid)  async {
          if(uid.isEmpty)
          {
            BotToast.showText(text: "Unable to signup",duration: const Duration(seconds: 3));
          }
          else
          {
            UserSignupModel userSignupModel=UserSignupModel(email, universityId, fullName, uid);
            _userProfileService.createProfileDocument(userType: userType(), userSignupModel: userSignupModel);

            BotToast.showText(text: "Signed Up",duration: const Duration(seconds: 3));
            Navigator.pushReplacement(context, PageTransition(
                duration: const Duration(milliseconds: 700),
                type: PageTransitionType.leftToRightWithFade, child: LoginScreen(
            )));
          }

        });

    }


  }






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