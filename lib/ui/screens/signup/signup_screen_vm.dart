import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/models/notification/signup_request_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/core/services/notification/signup_request_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';
import 'package:notice_board/ui/screens/login/login_screen.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/student_root_screen/student_root_screen.dart';
import '../../../core/services/user_authentication/user_auth_service.dart';
import '../../../core/services/validate_service.dart';

class SignupScreenVM extends ChangeNotifier
{
  int _groupValue = 0;

  //GetIt is a package used to create singleton design pattern.
  final UserAuthService _userAuthService=GetIt.I.get<UserAuthService>();

  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();

  final SignupRequestService _requestService=GetIt.I.get<SignupRequestService>();

  void signup(BuildContext context,String email,String password,String confirmPassword, String fullName,String universityId)async
  {
    int dateTime=(DateTime.now().millisecondsSinceEpoch);

    try {
      if (Validate().validateSignup(
          email, password, confirmPassword, fullName, universityId))
      {
        await _userAuthService.userSignup(email, password).then((uid) async {

          if (uid.isEmpty) {
            BotToast.showText(
                text: "Unable to signup. The email is already registered",
                duration: const Duration(seconds: 3));
          }

          else {

            UserSignupModel userSignupModel = UserSignupModel(
                email, universityId, fullName, uid,_groupValue==0?"student":"teacher");

            _userProfileService.createProfileDocument(
                userType: userType(), userSignupModel: userSignupModel).then((value){

             SignupRequestModel requestModel=SignupRequestModel(
                 fullName, userType(), dateTime, uid, universityId,email)  ;

             _requestService.createSignupRequestDocument(email, requestModel).then((value){

               BotToast.showText(
                   text: "Signup request sent to Coordinator", duration: const Duration(seconds: 4));

               NavigationService().navigatePushReplacement(context, LoginScreen());

             });


            });
          }
        });
      }
    }
    catch(error)
    {
      BotToast.showText(text: "$error");
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