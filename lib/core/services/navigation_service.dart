import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class NavigationService{

  void navigatePushReplacement(BuildContext context, Widget widget)
  {
    Navigator.pushReplacement(context, PageTransition(
        duration: const Duration(milliseconds: 700),
        type: PageTransitionType.leftToRightWithFade, child: widget));
  }
  void navigatePush(BuildContext context, Widget widget)
  {
    Navigator.push(context, PageTransition(
        duration: const Duration(milliseconds: 700),
        type: PageTransitionType.leftToRightWithFade, child: widget));
  }

}