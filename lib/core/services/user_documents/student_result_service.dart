import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/result/marks_model.dart';
import 'package:notice_board/core/models/result/result_model.dart';

class StudentResultService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future<MarksModel?> getStudentMarks(String studentUid) async {
    BotToast.showLoading();
    MarksModel? resultModel;
    try {
      await _firebaseFirestore
          .collection('result')
          .doc('2021-2022')
          .collection('marks')
          .doc(studentUid)
          .get()
          .then((docSnap) {
        resultModel = MarksModel.fromJson(docSnap);
      });
    } catch (error) {
      if (kDebugMode) {
        print("error at getStudentResult / StudentResultService $error");
      }
    }
    BotToast.closeAllLoading();
    return resultModel;
  }

  Future<List<MarksModel>> getAllStudentMarks() async {
    BotToast.showLoading();
    List<MarksModel> listOfResults = [];
    try {
      await _firebaseFirestore
          .collection('result')
          .doc('2021-2022')
          .collection('marks')
          .get()
          .then((docsSnap) {
        for (var doc in docsSnap.docChanges) {
          listOfResults.add(MarksModel.fromJson(doc.doc));
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print("error at getStudentResult / StudentResultService $error");
      }
    }
    BotToast.closeAllLoading();
    return listOfResults;
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      getResultDocument() {
    late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
        subscription;
    try {
      subscription = _firebaseFirestore
          .collection('result')
          .doc('2021-2022')
          .snapshots()
          .listen((event) {});
    } catch (error) {
      if (kDebugMode) {
        print("error at getResultDocument / StudentResultService $error");
      }
    }
    return subscription;
  }

  Future setResultDocument(
      String coordinatorUid, int timeStamp, List<String> teacherList1) async {
    List<String> teachersList2 = [];
    ResultModel? resltModel;
    try {

      try
      {
        resltModel=ResultModel.fromJson(await _firebaseFirestore
            .collection('result')
            .doc('2021-2022')
            .get());
        teachersList2 = resltModel.teachersList;
        teacherList1.forEach((element) {
          if (teachersList2.contains(element) == false) {
            teachersList2.add(element);
          }
        });
      }
      catch(error)
    {
      print('Result Document is empty or any field is missing $error');
    }



      ResultModel resultModel =
          ResultModel(coordinatorUid, timeStamp, teachersList2);
      await _firebaseFirestore
          .collection('result')
          .doc('2021-2022')
          .set(resultModel.toJson());
    } catch (error) {
      if (kDebugMode) {
        print("error at setResultDocument / StudentResultService $error");
      }
    }
  }

  Future setStudentMarks(
      Map<String, Map<String, dynamic>> _marksListMap,String teacherUid) async {

    try {
      _marksListMap.forEach((key, marksMap) async {
        double marks = 0;
        String uid = "", exam = "";

        marksMap.forEach((key, value) {
          if (key == 'uid') {
            uid = value;
          } else if (key == 'exam') {
            exam = getExamKeyword(value);
          } else if (key == 'marks') {
            marks = value;
          }
        });

        /// getting existing values of the specific exam if any..
        await _firebaseFirestore
            .collection('result')
            .doc('2021-2022')
            .collection('marks')
            .doc(uid)
            .get()
            .then((docSnap) async{
          MarksModel marksModel = MarksModel.fromJson(docSnap);
          ///for just fyp1 and 2
          if (exam == 'fyp1Viva' || exam=='fyp2Viva')
          {

              await _firebaseFirestore
                  .collection('result')
                  .doc('2021-2022')
                  .collection('marks')
                  .doc(uid).set({
                exam: marks
              },SetOptions(merge: true)).then((value) {
                BotToast.showText(text: 'Marks Uploaded');
              });
          }
          ///for obe2,3,4
          else {
            Map<String,double> specificExamValue = getExamMap(marksModel, exam);
            specificExamValue.addAll({
              teacherUid:marks
            });

            await _firebaseFirestore
                .collection('result')
                .doc('2021-2022')
                .collection('marks')
                .doc(uid).set({
              exam: specificExamValue
            },SetOptions(merge: true)).then((value) {
              BotToast.showText(text: 'Marks Uploaded');
            });

          }
        });

      });
    } catch (error) {
      if (kDebugMode) {
        BotToast.showText(text: 'Error, Try Again!');
        print("error at getStudentResult / StudentResultService $error");
      }
    }
  }

  Future finalizeResult()async
  {
    ResultModel? resultModel;
    try
    {
      resultModel=ResultModel.fromJson(await _firebaseFirestore
          .collection('result')
          .doc('2021-2022')
          .get());
    }
    catch(error)
    {
      _logger.e('result model is pushed to firebase yet, ignore it because no body is in committee yet');
    }
    if(resultModel!=null)
      {
        await _firebaseFirestore
            .collection('result')
            .doc('2021-2022')
            .set({
          'isResultFinalized':'yes'
        },SetOptions(merge: true)).then((value)
        async{
          List<String> studentsUid=[];
          await _firebaseFirestore
              .collection('result')
              .doc('2021-2022').collection('marks').get().then((querySnap) 
          {
                
                querySnap.docs.forEach((docSnap) 
                {
                  studentsUid.add(docSnap['uid']);
                });

          }).then((value) async{
            if(studentsUid.isNotEmpty)
              {
                BotToast.showLoading();
                studentsUid.forEach((sUid) async{
                  await _firebaseFirestore.collection('post').
                  where('ideaOwner',isEqualTo: sUid).get().then((value) {
                    value.docs.forEach((post) async{
                      await _firebaseFirestore.collection('post').doc(post['ideaId'])
                          .set({
                        'status':'finished'

                      },SetOptions(merge: true));
                      //print();
                    });
                  });
                });
                BotToast.closeAllLoading();
              }
          });
        });
      }
    else
      {
        BotToast.showText(text: 'ERROR! None of the students have given marks');
      }

  }

  String getExamKeyword(String exam) {
    if (exam == 'OBE2') {
      return 'obe2';
    } else if (exam == 'OBE3') {
      return 'obe3';
    } else if (exam == 'OBE4') {
      return 'obe4';
    } else if (exam == 'FYP-1 VIVA') {
      return 'fyp1Viva';
    } else if (exam == 'FYP-2 VIVA') {
      return 'fyp2Viva';
    } else {
      return '';
    }
  }

  Map<String, double> getExamMap(MarksModel marksModel, String exam) {
    if (exam == 'obe2') {
      return marksModel.obe2;
    } else if (exam == 'obe3') {
      return marksModel.obe3;
    } else if (exam == 'obe4') {
      return marksModel.obe4;
    } else {
      return {};
    }
  }
}
