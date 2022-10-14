import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class NavigationService{

  Future navigatePushReplacement(BuildContext context, Widget widget)async
  {
    await Navigator.pushReplacement(context, PageTransition(
        duration: const Duration(milliseconds: 700),
        type: PageTransitionType.leftToRightWithFade, child: widget));
  }
  Future navigatePush(BuildContext context, Widget widget)async
  {
    await Navigator.push(context, PageTransition(
        duration: const Duration(milliseconds: 700),
        type: PageTransitionType.leftToRightWithFade, child: widget));
  }

}