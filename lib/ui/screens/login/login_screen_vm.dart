import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/services/user_authentication/user_auth_service.dart';
import 'package:notice_board/core/services/verify_email_service.dart';

class LoginScreenVM extends ChangeNotifier{
  int _groupValue = -1;
  bool _isToggled=false;
  final UserAuthService _userAuthService=GetIt.I.get<UserAuthService>();
  void login(String email,String password)async
  {
    if(!(VerifyEmailService().isTextFieldEmpty(email)||VerifyEmailService().isTextFieldEmpty(password)))
    {
      if(VerifyEmailService().verifyEmail(email)==true)
      {
        await _userAuthService.userLogin(email, password).whenComplete(() {
          BotToast.showText(text: "Logged In",duration: Duration(seconds: 4));
        });
      }
      else
      {
        BotToast.showText(text: "The email is invalid",duration: Duration(seconds: 4));
      }
    }


  }


  int get getGroupValue=>_groupValue;
  bool get getIsToggled=>_isToggled;

  set setGroupValue(int a)
  {
    _groupValue=a;
    notifyListeners();
  }
  set setIsToggled(bool a)
  {
    _isToggled=a;
    notifyListeners();
  }
}