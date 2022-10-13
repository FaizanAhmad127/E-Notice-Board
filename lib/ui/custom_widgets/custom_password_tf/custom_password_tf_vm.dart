import 'package:flutter/material.dart';

class CustomPasswordTfVM extends ChangeNotifier
{
  bool isObscure=true;

  bool get getIsObscure=>isObscure;

  set setIsObscure(bool a)
  {
    isObscure=a;
    notifyListeners();
  }
}