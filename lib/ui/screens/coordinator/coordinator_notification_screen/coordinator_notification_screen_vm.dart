import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/notification/signup_request_model.dart';
import 'package:notice_board/core/services/notification/signup_request_service.dart';

class CoordinatorNotificationScreenVM extends ChangeNotifier {
  final SignupRequestService _signupRequestService =
      GetIt.I.get<SignupRequestService>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String uid = "";
  bool isDispose = false;
  final Logger _logger = Logger();
  List<SignupRequestModel> _listOfRequests = [];
  late StreamSubscription _streamSubscription;

  CoordinatorNotificationScreenVM() {
    uid = _firebaseAuth.currentUser!.uid;
    getNotifications();
  }

  Future getNotifications() async {
    try {
      _streamSubscription = _firebaseFirestore
          .collection("approval")
          .orderBy('timeStamp')
          .snapshots()
          .listen((docSnap) {
        if (isDispose == false) {
          for (var doc in docSnap.docChanges) {
            SignupRequestModel signupRequestModel =
                SignupRequestModel.fromJson(doc.doc);
            setListOfRequests = signupRequestModel;
          }
        } else {
          _streamSubscription.cancel();
        }
      });
    } catch (error) {
      _logger.e(
          "error at getNotifications/CoordinatorNotificationScreenVM $error");
    }
  }

  Future setApproval(String email, String isApproved, int index) async {
    
    if(isApproved=="no")
    {
      try {

        // await _firebaseFirestore
        //     .collection('approval')
        //     .doc(email)
        //     .delete().then((value) {
        //   BotToast.showText(text: 'Approval Removed');
        // });
        listOfRequests.removeAt(index);
        notifyListeners();

      } catch (error) {
        if (kDebugMode) {
          BotToast.showText(text: 'Error, Try Again!');
          print("error at getStudentResult / StudentResultService $error");
        }
      }
    }
    try {
      await _signupRequestService.approveSignupRequest(email, isApproved);
    } catch (error) {
      _logger.e("error at setApproval/CoordinatorNotificationScreenVM $error");
    }
  }

  List<SignupRequestModel> get listOfRequests => _listOfRequests;

  set setListOfRequests(SignupRequestModel request) {
    if(request.isApproved=="no")
      {
        _listOfRequests.insert(0, request);
      }
    else
      {
        if(_listOfRequests.where((element) => element.uid==request.uid).isNotEmpty)
          {
            _listOfRequests.removeWhere((req) => req.uid==request.uid);
          }

      }

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDispose = true;
  }
}
