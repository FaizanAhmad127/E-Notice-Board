import 'package:flutter/cupertino.dart';
import 'package:notice_board/core/enums/enums.dart';


class CoordinatorProjectStatusScreenVM extends ChangeNotifier
{


  projectStatus status=projectStatus.finished;


  projectStatus get getStatus=>status;

  set setStatus(projectStatus s)
  {
    status=s;
    notifyListeners();
  }

}