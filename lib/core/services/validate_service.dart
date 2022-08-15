import 'package:bot_toast/bot_toast.dart';

class Validate{

  bool verifyEmail(String _email)
  {
     bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email);
      if(emailValid==false)
        {
          BotToast.showText(text: "The email is invalid",duration: Duration(seconds: 3));
        }
     return emailValid;
  }
  bool validateLogin(String email, String password)
  {
    if(email.isEmpty || password.isEmpty)
   {
       BotToast.showText(text: "Warning! One of the TextField is empty",duration: Duration(seconds: 3));
        return false;
   }
    else
      {
        if(verifyEmail(email)==false)
          {
            return false;
          }
        else
          {
            return true;
          }

      }
  }

  bool validateSignup(String email, String password,String confirmPassword, String fullName,String uniId)
  {
    if(email.isEmpty || password.isEmpty|| confirmPassword.isEmpty|| fullName.isEmpty|| uniId.isEmpty)
    {
      BotToast.showText(text: "Warning! One of the TextField is empty",duration: Duration(seconds: 3));
      return false;
    }
    else
    {
      if(verifyEmail(email)==false)
      {
        return false;
      }
      else
      {
        if(password==confirmPassword)
          {
            if(password.length<6 || confirmPassword.length<6)
              {
                BotToast.showText(text: "Password should be at least 6 characters",duration: Duration(seconds: 3));

                return false;
              }
            else
              {
                return true;
              }

          }
        else
          {
            BotToast.showText(text: "Mismatch of both password",duration: Duration(seconds: 3));
            return false;
          }

      }
    }
  }
  bool validateIdea(String title,String desc, int studentLength, int teacherLength,int filesLength)
  {
    bool isValid=false;
    if(title.isEmpty || desc.isEmpty)
      {
        BotToast.showText(text: "Please fill in Text Field",duration: Duration(seconds: 3));
        isValid=false;
      }
    else
      {
        if(teacherLength==0)
        {
          BotToast.showText(text: "Please select at least 1 teacher",duration: Duration(seconds: 3));
          isValid=false;
        }
        else
          {
            isValid=true;
          }

      }

    return isValid;

  }

  bool validateEvent(String title, String address, String description, String dateTime)
  {
    if(title.isEmpty || address.isEmpty || description.isEmpty)
      {
        BotToast.showText(text: 'One of the text field is empty');
        return false;
      }
    else if(dateTime.isEmpty)
      {
        BotToast.showText(text: 'Please pick date and time');
        return false;
      }
    else
      {
        return true;
      }
  }

}