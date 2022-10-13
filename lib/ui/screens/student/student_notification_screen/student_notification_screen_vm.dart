import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/notification/student_idea_status_model.dart';
import 'package:notice_board/core/services/notification/student_idea_status_service.dart';

import '../../../../core/models/event/event_model.dart';
import '../../../../core/services/event/event_service.dart';

class StudentNotificationScreenVM extends ChangeNotifier{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  List<StudentIdeaStatusModel> _ideasList=[];
  final Logger _logger = Logger();
  late String uid;
  bool isDispose=false;
  List<EventModel> _listOfEvents=[];
  EventService eventService=EventService();

  StudentNotificationScreenVM()
  {
    uid=firebaseAuth.currentUser!.uid;
    getIdeaStatusNotification();
    getAllEvents();

  }


  void getAllEvents()
  {
    try
    {
      eventService.getListOfEvents().onData((data) {

        data.docs.forEach((element) {
          EventModel model=EventModel.fromJson(element.data());
         /* if(getListOfEvents.where((element) => element.id==model.id).isEmpty)
          {
            setListOfEvents=model;
          }*/
          if(model.stdList .isNotEmpty){
          for(var stdID in model.stdList ){
            if(stdID==uid){
              if(getListOfEvents.where((element) => element.id==model.id).isEmpty)
              {
                setListOfEvents=model;
              }

            }
          }
          }else{
            if(getListOfEvents.where((element) => element.id==model.id).isEmpty)
            {
              setListOfEvents=model;
            }

          }

        });
      });
    }
    catch(error)
    {
      print('error at getAllEvents /CoordinatorEventScreenVm $error');
    }


  }
  void getIdeaStatusNotification()
  {
    try
    {
      firestore.collection("student").doc(uid).collection("ideaStatusNotification").
      orderBy('timeStamp',descending: false).snapshots().listen((docsSnapshot) {
        if(isDispose==false)
          {
            for (var doc in docsSnapshot.docChanges) {
              setIdeasList=StudentIdeaStatusModel.fromJson(doc.doc);
            }
          }



      });
    }
    catch(error)
    {
      _logger.e("error at getIdeaStatusNotification/StudentNotificationScreenVM $error");
    }
  }

  List<StudentIdeaStatusModel> get getIdeasList=>_ideasList;
  List<EventModel> get getListOfEvents=>_listOfEvents;

  set setIdeasList(StudentIdeaStatusModel idea)
  {

    _ideasList.insert(0, idea);
    notifyListeners();
  }
  set setListOfEvents(EventModel eventModel)
  {
    _listOfEvents.add(eventModel);
    notifyListeners();
  }
 @override
  void dispose() {

    super.dispose();
    isDispose=true;
  }
}