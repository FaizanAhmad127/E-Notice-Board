import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/services/user_authentication/user_auth_service.dart';
import 'package:notice_board/core/services/validate_service.dart';

class LoginScreenVM extends ChangeNotifier{

  bool _isToggled=false;
  final UserAuthService _userAuthService=GetIt.I.get<UserAuthService>();
  void login(String email,String password)async
  {
    if(Validate().validateLogin(email,password))
    {
        await _userAuthService.userLogin(email, password).then((uid) {
          if(uid.isEmpty)
            {
              BotToast.showText(text: "Unable to login",duration: Duration(seconds: 3));
            }
          else
            {
              BotToast.showText(text: "Logged In",duration: Duration(seconds: 3));
            }

        });
      }
    }



  bool get getIsToggled=>_isToggled;
  set setIsToggled(bool a)
  {
    _isToggled=a;
    notifyListeners();
  }
}