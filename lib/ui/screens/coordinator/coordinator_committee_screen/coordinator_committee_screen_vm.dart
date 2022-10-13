import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/committee/committee_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/committee/committee_service.dart';
import 'package:notice_board/core/services/user_documents/student_idea_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

import '../../../../core/models/idea/idea_model.dart';

class CoordinatorCommitteeScreenVm extends ChangeNotifier
{
   final CommitteeService _committeeService=GetIt.I.get<CommitteeService>();
   final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
   final StudentIdeaService _ideaService=GetIt.I.get<StudentIdeaService>();
   final Logger _logger=Logger();
   List<CommitteeModel> _listOfCommittees=[];

   CoordinatorCommitteeScreenVm(){
    getCommitteeCollection();
   }

   Future getCommitteeCollection()async{
     try{
       _committeeService.getCommitteeCollection().then((value) {
         _listOfCommittees=value;
         notifyListeners();

       });
     }catch(error){
       _logger.e('error at getCommitteeCollection/CoordinatorCommitteeScreenVm $error');
     }

   }
   Future<List<UserSignupModel?>> getUserProfile(List<String> uids,String userType)async
   {
     List<UserSignupModel?> userSignupModelList=[];
     List<IdeaModel> ideasModeList =[];
     if(userType=='student')
       {
         try
         {
           await Future.forEach(uids, (String ideaId) async{
             await _ideaService.getIdea(ideaId).then((ideaModel) async{
                ideasModeList.add(ideaModel!);
               await Future.forEach(ideaModel!.students, (String studentUid) async{
                 await _userProfileService.getProfileDocument(studentUid, userType)
                     .then((user) {
                   userSignupModelList.add(user);
                 });
               });
             });
           });
         }
         catch(error){
           _logger.e('error at getUserProfile/CoordinatorCommitteeScreenVm $error');
         }
       }
     else
       {
         try
         {
           await Future.forEach(uids, (String uid) async{
             await _userProfileService.getProfileDocument(uid, userType).then((value){
               userSignupModelList.add(value) ;
             });
           });


         }
         catch(error){
           _logger.e('error at getUserProfile/CoordinatorCommitteeScreenVm $error');
         }
       }

     return userSignupModelList;
   }

   Future<List<IdeaModel?>> getUserStdProfile(List<String> uids,String userType)async
   {
     List<IdeaModel> ideasModeList =[];
     if(userType=='student')
       {
         try
         {
           await Future.forEach(uids, (String ideaId) async{
             await _ideaService.getIdea(ideaId).then((ideaModel) async{
                ideasModeList.add(ideaModel!);
             });
           });
         }
         catch(error){
           _logger.e('error at getUserProfile/CoordinatorCommitteeScreenVm $error');
         }
       }
     return ideasModeList;
   }

   List<CommitteeModel> get listOfCommittees=>_listOfCommittees;

   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<void> deleteCommittee(int index) async {
    var isIdealistMatched = false;
    var isTeacherlistMatched = false;
    var isConvenerlistMatched = false;
    var ideaID = "";

    try {


        await _firebaseFirestore.collection('committee').get().then((querySnap) async {
          for (var docSnap in querySnap.docs) {

            var comiteModel = CommitteeModel.fromJson(docSnap);
            for(var i = 0 ; i <comiteModel.ideaList.length; i++){
              if(comiteModel.ideaList[i]==_listOfCommittees[index].ideaList[i]){
                print("idea "+_listOfCommittees[index].ideaList[i]);
                isIdealistMatched=true;
              }else{
                isIdealistMatched = false;
                break;
              }
            }
            for(var i = 0 ; i <comiteModel.teacherList.length; i++){
              if(comiteModel.teacherList[i]==_listOfCommittees[index].teacherList[i]){
                print("teacher "+_listOfCommittees[index].teacherList[i]);
                isTeacherlistMatched=true;
              }else{
                isTeacherlistMatched = false;
                break;
              }
            }
            for(var i = 0 ; i <comiteModel.convenerList.length; i++){
              if(comiteModel.convenerList[i]==_listOfCommittees[index].convenerList[i]){
                isConvenerlistMatched=true;
              }else{
                isConvenerlistMatched = false;
                break;
              }
            }
            if(isConvenerlistMatched && isTeacherlistMatched && isIdealistMatched){
              ideaID = docSnap.id;
              break;
            }
          }
          if(isConvenerlistMatched && isTeacherlistMatched && isIdealistMatched){

            await _firebaseFirestore
                .collection('committee')
                .doc(ideaID)
                .delete().then((value) {
              BotToast.showText(text: 'Committee Deleted successfully');
            });

            listOfCommittees.removeAt(index);
            notifyListeners();

          }else{

          }
        });

      } catch (error) {

          print("error at coordinatorcomitescree $error");

      }

  }
   //
   // set setListOfCommittees(){
   //
   // }

}