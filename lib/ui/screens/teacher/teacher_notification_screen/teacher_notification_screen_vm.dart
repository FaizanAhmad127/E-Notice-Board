import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/notification/student_idea_status_model.dart';
import 'package:notice_board/core/models/notification/teacher_notification_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/notification/student_idea_status_service.dart';
import 'package:notice_board/core/services/notification/teacher_notification_service.dart';
import 'package:notice_board/core/services/user_documents/student_idea_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

import '../../../../core/models/event/event_model.dart';
import '../../../../core/services/chat/chat_service.dart';
import '../../../../core/services/event/event_service.dart';

class TeacherNotificationScreenVM extends ChangeNotifier{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  final TeacherNotificationService _teacherNotificationService=GetIt.I.get<TeacherNotificationService>();
  final StudentIdeaService _studentIdeaService=GetIt.I.get<StudentIdeaService>();
  final StudentIdeaStatusService _studentIdeaStatusService=GetIt.I.get<StudentIdeaStatusService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final ChatService _chatService=GetIt.I.get<ChatService>();
  UserSignupModel? thisTeacher;
  List<TeacherNotificationModel> _ideasList=[];
  bool isDispose=false;
  final Logger _logger = Logger();
  late String uid;
  List<EventModel> _listOfEvents=[];
  EventService eventService=EventService();

  TeacherNotificationScreenVM()
  {
    uid=firebaseAuth.currentUser!.uid;
    thisTeacherDetails();
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
          // if(getListOfEvents.where((element) => element.id==model.id).isEmpty)
          // {
          //   setListOfEvents=model;
          // }
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

  Future thisTeacherDetails()async
  {
    try
    {
      thisTeacher=await _userProfileService.getProfileDocument(uid, "teacher");
    }
    catch(error)
    {
      _logger.e("error at thisTeacherDetails/teacherNotificationScreenVM $error");
    }
  }

  Future setNotificationStatus(String status,TeacherNotificationModel ideaStatusModel)async {
    int timeStamp = Timestamp.now()
        .millisecondsSinceEpoch;
    try {
      _studentIdeaService.getIdea(ideaStatusModel.ideaId ?? "").then((
          ideaModel) async {
        ///just check if any teacher isn't accepted it yet
        if (ideaModel?.status == "pending") {
          if (status == "accepted") {
            ///if teacher accept the idea then add it to idealist of that teacher who accepted it
            _studentIdeaService.addIdeaIdToTeacher(
                ideaStatusModel.ideaId ?? "", uid);
          }

          ///getting the students added to this idea
          ///and sending them notification whether their idea is accepted or rejected
          List<String> studentsUid = ideaModel?.students ?? [];
          if (studentsUid.isNotEmpty) {
            await _studentIdeaStatusService.postNotification(
                studentsUid,
                StudentIdeaStatusModel(
                    ideaStatusModel.ideaId, ideaStatusModel.ideaTitle,"",
                    status, timeStamp, thisTeacher?.fullName ?? "")).then((
                value) {

              ///now edit post/idea document according to accept reject status
              _studentIdeaService.acceptRejectIdea(ideaStatusModel.ideaId ?? "",
                  thisTeacher!.uid ?? "", status, studentsUid).
              then((value) {

                ///update the rejection/acceptance status in teacher notification
                 _teacherNotificationService.setIsRejectedStatus(
                    uid, ideaStatusModel.timeStamp.toString(), status)
                     .then((value) {
                      /// instantiate the chat option between the teacher and all team members
                   if(status=='accepted')
                     {
                       Future.forEach(studentsUid, (stdUid) async{
                         await _chatService.setChatDocument(thisTeacher?.uid??"",
                             stdUid.toString(), "teacher", "student");
                       }
                       );
                     }

                 });
              });
            });
          }
        }
        else {
          BotToast.showText(text: "The idea is already ${ideaModel?.status}");
        }
      });


      ///enable + button for student if all rejected.
      ///don't forget to initiate chat
    }
    catch(error)
    {
      _logger.e("error at setNotificationStatus/teacherNotificationScreenVM $error");
    }
  }

  void getIdeaStatusNotification()
  {
    try
    {
      firestore.collection("teacher").doc(uid).collection("notification").
      orderBy('timeStamp',descending: false).snapshots().listen((docsSnapshot) {
        if(isDispose==false)
          {
            for (var doc in docsSnapshot.docChanges) {
              setIdeasList=TeacherNotificationModel.fromJson(doc.doc);
            }

          }


      });
    }
    catch(error)
    {
      _logger.e("error at getIdeaStatusNotification/StudentNotificationScreenVM $error");
    }
  }

  List<TeacherNotificationModel> get getIdeasList=>_ideasList;
  List<EventModel> get getListOfEvents=>_listOfEvents;

  set setIdeasList(TeacherNotificationModel idea)
  {
    if(_ideasList.where((element) => element.ideaId==idea.ideaId).isNotEmpty)
      {
        int index=_ideasList.indexWhere((element) => element.ideaId==idea.ideaId);
        _ideasList.removeAt(index);
        _ideasList.insert(index, idea);
      }
    else
      {
        _ideasList.insert(0, idea);
      }

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