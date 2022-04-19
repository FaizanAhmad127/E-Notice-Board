import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/notification/teacher_notification_model.dart';
import 'package:flutter/material.dart';
class TeacherNotificationService{
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final Logger _logger=Logger();

  Future setTeacherNotification(List<String> teacherUid, TeacherNotificationModel notificationModel)async
  {
    BotToast.showLoading();
    try{
      await Future.forEach(teacherUid, (String uid)async {
        await _firebaseFirestore.collection("teacher").doc(uid)
            .collection("notification").doc(notificationModel.timeStamp.toString()).
        set(notificationModel.toJson(),SetOptions(merge: true));
      });

    }
    catch(error)
    {
      _logger.e("error at setTeacherNotification/TeacherNotificationService.dart");
    }
    BotToast.closeAllLoading();
  }

  Future setIsRejectedStatus(String teacherUid,String timeStamp,String status)async
  {
    
    try
        {
          await _firebaseFirestore.collection("teacher").doc(teacherUid).collection("notification")
              .doc(timeStamp).set({
            'status':status
          },SetOptions(merge: true));
        }
    catch(error)
    {
      _logger.e("error at setIsRejectedStatus/TeacherNotificationService.dart");
    }
  }
}