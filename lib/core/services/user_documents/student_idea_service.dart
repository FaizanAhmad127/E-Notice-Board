import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:flutter/material.dart';

class StudentIdeaService
{
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final Logger _logger=Logger();

  Future postIdea({required IdeaModel ideaModel,required int ideaId})async
  {
    BotToast.showLoading();
    try
    {
      await _firebaseFirestore.collection("post").doc(ideaId.toString()).
    set(ideaModel.toJson(),SetOptions(merge:  true,
      ));
    }
    catch(error)
    {
      _logger.e("error at postIdea services/StudentIdeaService.dart");
    }
    BotToast.closeAllLoading();

  }
  Future addIdeaIdToStudent(String ideaId,String uid)async
  {
    BotToast.showLoading();
    try
    {
      //first fetch the existing list of ideas
      await _firebaseFirestore.collection("student").doc(uid).get().
      then((docSnap) {
        //now append the list with new idea id
        List<String> ideaList=List<String>.from(docSnap.get('ideaList'));
        ideaList.add(ideaId);
        _firebaseFirestore.collection("student").doc(uid).set({
          'available':"no",
          'ideaList':ideaList
        },SetOptions(merge: true));
      });
    }

    catch(error)
    {
      _logger.e("error at addIdeaIdToStudent services/StudentIdeaService.dart $error");
    }
    BotToast.closeAllLoading();
  }


  Future addIdeaIdToTeacher(String ideaId,String uid)async
  {
    BotToast.showLoading();
    try
    {
      //first fetch the existing list of ideas
      await _firebaseFirestore.collection("teacher").doc(uid).get().
      then((docSnap) {
        //now append the list with new idea id
        List<String> ideaList=List<String>.from(docSnap.get('ideaList'));
        ideaList.add(ideaId);
        _firebaseFirestore.collection("teacher").doc(uid).set({
          'ideaList':ideaList
        },SetOptions(merge: true));
      });
    }
    catch(error)
    {
      _logger.e("error at addIdeaIdToTeacher services/StudentIdeaService.dart $error");
    }
    BotToast.closeAllLoading();
  }
}


