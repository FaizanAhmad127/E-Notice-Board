import 'package:bot_toast/bot_toast.dart';

class VerifyEmailService{

  bool verifyEmail(String _email)
  {
     bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email);
      return emailValid;
  }
  bool isTextFieldEmpty(String data)
  {
    if(data.isEmpty)
{
  BotToast.showText(text: "Warning! One of the TextField is empty",duration: Duration(seconds: 3));
  return true;
}
    else
      {
        return false;
      }
  }
}