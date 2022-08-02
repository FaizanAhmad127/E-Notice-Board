import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/committee/committee_model.dart';

class CommitteeService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future setCommitteeDocument(List<String> teacherList,List<String> ideaList)async
  {
    String docId = Timestamp
        .now()
        .millisecondsSinceEpoch.toString();
    try{
      await _firebaseFirestore.collection('committee').doc(docId).set(
        {
          'teacherList':teacherList,
          'ideaList':ideaList
        },
        SetOptions(merge: true)
      ).then((value) async{
        /// pushing committee id to result document


      });
    }
    catch (error) {
      _logger.e('error at setCommitteeDocument/ CommitteeService $error');
    }
  }
  Future<List<CommitteeModel>> getCommitteeCollection() async {
    List<CommitteeModel> listOfCommittees = [];
    try {
      await _firebaseFirestore.collection('committee').get().then((querySnap) {
        querySnap.docs.forEach((docSnap) {
          listOfCommittees.add(CommitteeModel.fromJson(docSnap));
        });
      });
    } catch (error) {
      _logger.e('error at getCommitteeCollection/ CommitteeService $error');
    }
    return listOfCommittees;
  }

  Future<CommitteeModel?> getSingleCommittee(String committeeId) async {
    try {
      await _firebaseFirestore
          .collection('committee')
          .doc(committeeId)
          .get()
          .then((docSnap) {
        return CommitteeModel.fromJson(docSnap);
      });
    } catch (error) {
      _logger.e('error at getSingleCommittee/commitee_service $error');
    }
    return null;
  }

  Future<bool> isIdeaAlreadyInCommittee(String ideaId) async {
    bool isAlreadyAMember = false;
    try {
      await _firebaseFirestore.collection('committee').get().then((querySnap) {
        for (var docSnap in querySnap.docs) {
          for (var id in CommitteeModel
              .fromJson(docSnap)
              .ideaList) {
            if (ideaId == id) {
              isAlreadyAMember = true;
              break;
            }
          }
          if (isAlreadyAMember) {
            break;
          }
        }
      });
    } catch (error) {
      _logger.e('error at getCommitteeCollection/ CommitteeService $error');
    }
    return isAlreadyAMember;
  }

  Future<bool> isTeacherAlreadyInCommittee(String teacherUid) async {
    bool isAlreadyAMember = false;
    try {
      await _firebaseFirestore.collection('committee').get().then((querySnap) {
        for (var docSnap in querySnap.docs) {
          for (var uid in CommitteeModel
              .fromJson(docSnap)
              .teacherList) {
            if (teacherUid == uid) {
              isAlreadyAMember = true;
              break;
            }
          }
          if (isAlreadyAMember) {
            break;
          }
        }
      });
    } catch (error) {
      _logger.e('error at getCommitteeCollection/ CommitteeService $error');
    }
    return isAlreadyAMember;
  }
  Future<List<String>> getListOfAllTeachersInCommittee() async {
    List<String> listOfTeachers=[];
    try {
      await _firebaseFirestore.collection('committee').get().then((querySnap) {
        for (var docSnap in querySnap.docs) {
         CommitteeModel committeeModel= CommitteeModel.fromJson(docSnap);
         committeeModel.teacherList.forEach((element) {
           listOfTeachers.add(element);
         });

        }
      });
    } catch (error) {
      _logger.e('error at getListOfAllTeachersInCommittee/ CommitteeService $error');
    }
    return listOfTeachers;
  }

  Future<List<String>> getListOfAllIdeasInCommittee() async {
    List<String> listOfIdeas=[];
    try {
      await _firebaseFirestore.collection('committee').get().then((querySnap) {
        for (var docSnap in querySnap.docs) {
          CommitteeModel committeeModel= CommitteeModel.fromJson(docSnap);
          committeeModel.ideaList.forEach((element) {
            listOfIdeas.add(element);
          });

        }
      });
    } catch (error) {
      _logger.e('error at getListOfAllStudentsInCommittee/ CommitteeService $error');
    }
    return listOfIdeas;
  }

  ///this method is used to result section, to show only students who are committee
  ///member with this teacher
  ///
  Future<CommitteeModel?> getTeacherCommittee(String teacherUid) async {
    CommitteeModel? cm;
    try {
      await _firebaseFirestore.collection('committee').get().then((querySnap) {
        for (var docSnap in querySnap.docs) {
          CommitteeModel? committeeModel=CommitteeModel.fromJson(docSnap);
          if(committeeModel.teacherList.contains(teacherUid))
            {
              cm=committeeModel;
              break;
            }

        }
      });
    }
    catch(error){
    _logger.e('error at getTeacherCommittee/ CommitteeService $error');

    }
    return cm;
  }
}
