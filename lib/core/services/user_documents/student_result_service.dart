import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/result/marks_model.dart';
import 'package:notice_board/core/models/result/result_model.dart';

class StudentResultService
{
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final Logger _logger=Logger();

  Future<MarksModel?> getStudentMarks(String studentUid)async
  {
    BotToast.showLoading();
    MarksModel? resultModel;
    try
    {
      await _firebaseFirestore.collection('result').doc('2021-2022')
          .collection('marks').doc(studentUid).get().then((docSnap){
        resultModel=MarksModel.fromJson(docSnap);
      });

    }
    catch(error)
    {
      if (kDebugMode) {
        print("error at getStudentResult / StudentResultService $error");
      }
    }
    BotToast.closeAllLoading();
    return resultModel;
  }
  Future<List<MarksModel>> getAllStudentMarks()async
  {
    BotToast.showLoading();
    List<MarksModel> listOfResults=[];
    try
    {
      await _firebaseFirestore.collection('result')
          .doc('2021-2022')
          .collection('marks')
          .get().then((docsSnap){
        for (var doc in docsSnap.docChanges) {
          listOfResults.add(MarksModel.fromJson(doc.doc));
        }});

    }
    catch(error)
    {
      if (kDebugMode) {
        print("error at getStudentResult / StudentResultService $error");
      }
    }
    BotToast.closeAllLoading();
    return listOfResults;
  }
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> getResultDocument()
  {
    late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> subscription;
    try
    {

       subscription=_firebaseFirestore.collection('result')
          .doc('2021-2022').snapshots().listen((event) {

      });
    }
    catch(error)
    {
      if (kDebugMode) {
        print("error at getResultDocument / StudentResultService $error");
      }
    }
    return subscription;
  }
  Future setResultDocument(String coordinatorUid,int timeStamp,List<String> teacherList1)async
  {
    List<String> teachersList2=[];
    try
        {
          teachersList2= ResultModel.fromJson(await _firebaseFirestore.collection('result')
              .doc('2021-2022').get()).teachersList;
          teacherList1.forEach((element) {
            if(teachersList2.contains(element)==false)
              {
                teachersList2.add(element);
              }
          });

          ResultModel resultModel=ResultModel(coordinatorUid, timeStamp,teachersList2);
          await _firebaseFirestore.collection('result')
              .doc('2021-2022').set(resultModel.toJson());
        }
    catch(error)
    {
      if (kDebugMode) {
        print("error at setResultDocument / StudentResultService $error");
      }
    }
  }
  Future setStudentMarks(String studentUid, String key,String value)async
  {
    BotToast.showLoading();

    try
    {
      await _firebaseFirestore.collection('result')
          .doc('2021-2022')
          .collection('marks')
          .doc(studentUid)
          .set({
             key:value
      },SetOptions(merge: true));

    }
    catch(error)
    {
      if (kDebugMode) {
        print("error at getStudentResult / StudentResultService $error");
      }
    }
    BotToast.closeAllLoading();

  }

}