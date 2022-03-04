import 'package:flutter/cupertino.dart';

class LoginScreenVM extends ChangeNotifier{
  int _groupValue = -1;
  bool _isToggled=false;


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