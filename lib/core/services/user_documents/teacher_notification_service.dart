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
         for(String uid in teacherUid)
          {
            await _firebaseFirestore.collection("teacher").doc(uid)
              .collection("notification").add(notificationModel.toJson());
          }

    }
    catch(error)
    {
      _logger.e("error at setTeacherNotification services/TeacherNotificationService.dart");
    }
    BotToast.closeAllLoading();
  }
}