import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/committee/committee_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/committee/committee_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

class CoordinatorCommitteeScreenVm extends ChangeNotifier
{
   final CommitteeService _committeeService=GetIt.I.get<CommitteeService>();
   final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
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
     return userSignupModelList;
   }

   List<CommitteeModel> get listOfCommittees=>_listOfCommittees;
   //
   // set setListOfCommittees(){
   //
   // }

}