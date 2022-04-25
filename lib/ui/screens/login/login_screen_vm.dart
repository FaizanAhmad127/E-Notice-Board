import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/services/notification/signup_request_service.dart';
import 'package:notice_board/core/services/shared_pref_service.dart';
import 'package:notice_board/core/services/user_authentication/user_auth_service.dart';
import 'package:notice_board/core/services/validate_service.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_root_screen/coordinator_root_screen/coordinator_root_screen.dart';
import 'package:notice_board/ui/screens/teacher/teacher_root_screen/teacher_root_screen/teacher_root_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../student/student_root_screen/student_root_screen/student_root_screen.dart';

class LoginScreenVM extends ChangeNotifier{

  late bool _isToggled;
  late UserAuthService _userAuthService;
  late SignupRequestService _requestService;
  late SharedPref _sharedPref;
  final Logger _logger=Logger();

  //this is the constructor and used to initialize the properties of a class
  LoginScreenVM()
  {
   try {
      _isToggled = false;
      _userAuthService = GetIt.I.get<UserAuthService>();
     _requestService = GetIt.I.get<SignupRequestService>();

      _sharedPref = GetIt.I.get<SharedPref>();
    }
    catch(error)
    {
      BotToast.showText(text: "$error");
    }
  }
  String isUserLoggedIn()
  {
    String userType="";
    try{
      if(_userAuthService.isUserLoggedIn().isNotEmpty &&
          _sharedPref.retrieveBool("session")==true)
        {
          userType=_sharedPref.retrieveString("userType")??"";
        }
      else
        {
          userType="";
        }

    }
    catch(e)
    {
      userType="";
    }
    return userType;
  }

  //this method is used to store the session of a user so he
  //won't login next time.
  void storeUserSession(String userType)
  {
    if(getIsToggled==true)
      {
        _sharedPref.storeBool("session", true);
        _sharedPref.storeString('userType', userType);
      }
    else
      {
        _sharedPref.storeBool("session", false);
        _sharedPref.storeString('userType', userType);
      }
  }

  //this method will perform the login tasks.
  void login(String email,String password,BuildContext context)async
  {
    if(Validate().validateLogin(email,password))
    {
      try
          {
            await _requestService.getSignupRequestDocument(email).then((requestModel) {
              if(requestModel!.isApproved=="yes")
              {
                 _userAuthService.userLogin(email, password).then((uid) {
                  if(uid.isEmpty)
                    {
                      BotToast.showText(text: "Unable to login. Please check your email and password",duration: Duration(seconds: 3));
                    }
                  else
                    {

                      storeUserSession(requestModel.occupation??"");
                      BotToast.showText(text: "Logged In",duration: const Duration(seconds: 3));
                      Navigator.pushReplacement(context, PageTransition(
                          duration: const Duration(milliseconds: 700),
                          type: PageTransitionType.leftToRightWithFade, child: getUserType(requestModel.occupation??"")??const SizedBox()));
                    }

                });
              }
              else
              {
                BotToast.showText(text: "Your signup request is not yet approved",duration: Duration(seconds: 3));
              }
            });
          }
        catch(error)
       {
         _logger.e("error at login/LoginScreenVM.dart $error");
       }

      }
    }
   Widget? getUserType(String userType)
   {
     Widget? user;
     if(userType=="student")
       {
         user=const StudentRootScreen();
       }
     else if(userType=="teacher")
       {
         user=const TeacherRootScreen();
       }
     else if(userType=="coordinator")
       {
         user=const CoordinatorRootScreen();
       }
     return user;
   }


  bool get getIsToggled=>_isToggled;
  set setIsToggled(bool a)
  {
    _isToggled=a;
    notifyListeners();
  }
}