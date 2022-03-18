
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/models/notification/teacher_notification_model.dart';
import 'package:notice_board/core/services/user_documents/student_idea_service.dart';
import 'package:notice_board/core/services/user_documents/teacher_notification_service.dart';

class AddIdeaScreenVM extends ChangeNotifier
{
  final StudentIdeaService _studentIdeaService =GetIt.I.get<StudentIdeaService>();
  final TeacherNotificationService _teacherNotificationService=GetIt.I.get<TeacherNotificationService>();
  late IdeaModel _ideaModel;
  late TeacherNotificationModel _teacherNotificationModel;
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  Future post()async
  {
    int dateTime=(DateTime.now().millisecondsSinceEpoch);
    String uid=_firebaseAuth.currentUser!.uid;

    _ideaModel=IdeaModel(dateTime.toString(), "research", "dog bread",
        "to classify dogs", uid, 4, [], [], [],dateTime);
    _teacherNotificationModel=TeacherNotificationModel("permission", dateTime.toString());

    // posting idea to post collection
    await _studentIdeaService.postIdea(ideaModel: _ideaModel, ideaId: dateTime).
    then((value) {
      //adding idea id to student profile
      _studentIdeaService.addIdeaIdToStudent(dateTime.toString(), uid).then((value){
        //notifying teacher so he/she can accept or reject it.
        _teacherNotificationService.setTeacherNotification([], _teacherNotificationModel);
      });
    });
  }


}