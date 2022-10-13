import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/event/event_model.dart';
import 'package:notice_board/core/services/event/event_service.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/core/services/validate_service.dart';

import '../../../../core/models/idea/idea_model.dart';
import '../../../../core/models/user_authentication/user_signup_model.dart';
import '../../../../core/services/user_documents/user_profile_service.dart';

class CoordinatorEventScreenVM extends ChangeNotifier
{
    TextEditingController titleContrller=TextEditingController();
    TextEditingController addressController=TextEditingController();
    TextEditingController descriptionController=TextEditingController();
    String _pickedDateTime='';
    late String uid;
    List<EventModel> _listOfEvents=[];
    List<String> _selectedIdeasList=[];
    List<String> _emptyList=[];
    EventService eventService=EventService();
    FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  bool isNoticeOpen=false;
    final TextEditingController _searchController=TextEditingController();
    TextEditingController get searchController=>_searchController;


    CoordinatorEventScreenVM()
    {
      uid=firebaseAuth.currentUser!.uid;
      listOfIdeas();
      getAllEvents();
      _searchController.addListener(() {
        print("std list ${1} ");
        searchId(_searchController.text);
      });
    }
    void searchId(String searchText)
    {

      try
      {
        setIdeasList=searchText.isNotEmpty?
        List<IdeaModel>.from(_searchList.where((element) => element?.ideaTitle?.contains(searchText.toLowerCase())??false))
            :_searchList;

      }
      catch(error)
      {
        print("error at searchIdea/StudentHomeScreenVM.dart $error");
      }

    }
    showStudentforNotice(bool value){
      isNoticeOpen = value;
      notifyListeners();
    }
    final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
    List<IdeaModel> _searchList=[];
    List<String> _allSelectedIds=[];

    Future getListOfStudents()async
    {
      try{
        await _userProfileService.getAllStudents().then((listOfStudents) {

           // setListOfStudents=listOfStudents;
          //  setSearchList=listOfStudents;


        });
      }
      catch(error){
        print("error at getListOfTeachers/coordinatorstudentlistvm.dart $error");
      }

    }
    final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
    final Logger _logger=Logger();
    List<IdeaModel> _ideasList=[];
    Future listOfIdeas()async
    {
      IdeaModel ideaModel;

      try {
        _firebaseFirestore.collection("post")
            .snapshots().listen((querySnap) {
          _ideasList=[];
          for (var docSnap in querySnap.docs) {
            ideaModel=IdeaModel.fromJson(docSnap);
            if(ideaModel.status=='accepted')
            {
              _ideasList.add(ideaModel);
            }

          }
          setIdeasList = _ideasList;
            setSearchList=_ideasList;

        });
      }
      catch(error)
      {
        _logger.e("error at listOfIdeas /PendingScreenVM.dart $error");

      }
    }
    List<IdeaModel> get getlistOfIdeas => _ideasList;
    List<String> get allSelectedIds => _allSelectedIds;
    List<String> get getselectedIdeasList => _selectedIdeasList;
    List<String> get getEmptyList => _emptyList;
    set setIdeasList(List<IdeaModel> list)
    {
      _ideasList=list;
      notifyListeners();
    }
    set setSearchList(List<IdeaModel> list)
    {
      _searchList=list;
      notifyListeners();
    }

    set setSelectedIdeasList(List<String> std)
    {
      _selectedIdeasList=std;
      notifyListeners();
    }

    void getAllEvents()
    {
        try
        {
            eventService.getListOfEvents().onData((data) {
                data.docs.forEach((element) {
                    EventModel model=EventModel.fromJson(element.data());
                   // if(getListOfEvents.where((element) => element.id==model.id).isEmpty)
                   //     {
                   //         setListOfEvents=model;
                   //     }
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

    Future<bool> createEvent( List<String> stdList)async
    {
        String id=Timestamp.now().millisecondsSinceEpoch.toString();
        List<String> list = [];
        if(stdList!=null&&stdList.isNotEmpty){
          list.addAll(stdList);
        }
        list.add(uid);
        BotToast.showLoading();
        bool isEventCreated=false;
        bool isValidate=Validate().validateEvent(titleContrller.text,
            addressController.text, descriptionController.text, getPickedDateTime);
        if(isValidate)
            {
               await eventService.createEvent(
                    EventModel(id,getPickedDateTime, titleContrller.text,list,
                        descriptionController.text, addressController.text)).then((value) {

                            if(value==true)
                                {
                                    BotToast.showText(text: 'Notice Created');
                                    isEventCreated= true;
                                }
                            else
                                {
                                    isEventCreated= false;
                                }
                });
            }
        BotToast.closeAllLoading();
        return isEventCreated;
    }

    String get getPickedDateTime=>_pickedDateTime;
    List<EventModel> get getListOfEvents=>_listOfEvents;

    set setPickedDateTime(DateTime dateTime)
    {
        _pickedDateTime=dateTime.toString();
        print(DateTime.parse(_pickedDateTime));
        notifyListeners();
    }
    set setListOfEvents(EventModel eventModel)
    {
        _listOfEvents.add(eventModel);
        notifyListeners();
    }

    @override
    void dispose()
    {
        super.dispose();
        print('dispose is called');

    }

    void getAllUID() {
      for(var selectedideaID in _selectedIdeasList){
        for(var idea in _searchList){
          if(selectedideaID==idea.ideaId){
            for(var teacherID in idea.teachers){
              _allSelectedIds.add(teacherID);
            }
            for(var coadviserID in idea.coadviser){
              _allSelectedIds.add(coadviserID);
            }
            for(var studentsID in idea.students){
              _allSelectedIds.add(studentsID);
            }
          }
        }
      }
    }
}