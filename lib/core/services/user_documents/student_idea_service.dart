import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/committee/committee_model.dart';
import 'package:notice_board/core/models/idea/file_model.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/models/notification/teacher_notification_model.dart';
import 'package:notice_board/core/models/result/marks_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/notification/teacher_notification_service.dart';

class StudentIdeaService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future postIdea(
      String title,
      String desc,
      String ownerUID,
      List<String> studentsUid,
      List<String> teachersUid,
      List<String> coadviserUid,
      String ideaType,
      List<PlatformFile> filesList,
      int ideaId) async {
    BotToast.showLoading();
    try {
      ///current student is also a team member so add him/her
      studentsUid.add(ownerUID);

      List<FileModel> fileModelList = [];

      /// Adding files to firebase Storage
      await Future.forEach(filesList, (PlatformFile platformFile) async {
        File file = File(platformFile.path ?? "");
        await _firebaseStorage
            .ref()
            .child("post/$ideaId/files/${platformFile.name}")
            .putFile(file)
            .then((uploadTask) async {
          String downloadUrl = await uploadTask.ref.getDownloadURL();
          fileModelList.add(FileModel(platformFile.name,
              platformFile.extension ?? "", downloadUrl, platformFile.size));
        });
      }).then((value) async {
        /// Adding idea to firestore post collection
        IdeaModel ideaModel = IdeaModel(
            ideaId.toString(),
            ideaType,
            title,
            desc,
            ownerUID,
            teachersUid.length,
            studentsUid,
            teachersUid,
            coadviserUid,
            fileModelList,
            ideaId);

        await _firebaseFirestore
            .collection("post")
            .doc(ideaId.toString())
            .set(
                ideaModel.toJson(),
                SetOptions(
                  merge: true,
                ))
            .then((value) async {
          ///adding idea id to selected Students

          await addIdeaIdToStudent(ideaId.toString(), studentsUid)
              .then((value) async {
            /// adding idea id to teacher notification
            await TeacherNotificationService()
                .setTeacherNotification(
                    teachersUid,
                    TeacherNotificationModel("permission", ideaId.toString(),
                        title, ideaType, ideaId))
                .then((value) {
              BotToast.showText(text: "Idea Submitted");
            });
          });
        });
      });
    } catch (error) {
      BotToast.showText(text: "Unable to submit, try again!");
      _logger.e("error at postIdea/StudentIdeaService.dart $error");
    }
    BotToast.closeAllLoading();
  }

  Future addIdeaIdToStudent(String ideaId, List<String> studentsUids) async {
    BotToast.showLoading();
    try {
      //first fetch the existing list of ideas
      await Future.forEach(studentsUids, (String uid) async {
        await _firebaseFirestore
            .collection("student")
            .doc(uid)
            .get()
            .then((docSnap) {
          //now append the list with new idea id
          List<String> ideaList = List<String>.from(docSnap.get('ideaList'));
          ideaList.add(ideaId);
          _firebaseFirestore.collection("student").doc(uid).set(
              {'available': "no", 'ideaList': ideaList},
              SetOptions(merge: true));
        });
      });
    } catch (error) {
      _logger.e("error at addIdeaIdToStudent/StudentIdeaService.dart $error");
    }
    BotToast.closeAllLoading();
  }

  Future addIdeaIdToTeacher(String ideaId, String uid) async {
    BotToast.showLoading();
    try {
      //first fetch the existing list of ideas
      await _firebaseFirestore
          .collection("teacher")
          .doc(uid)
          .get()
          .then((docSnap) async {
        //now append the list with new idea id
        List<String> ideaList = List<String>.from(docSnap.get('ideaList'));
        ideaList.add(ideaId);
        await _firebaseFirestore
            .collection("teacher")
            .doc(uid)
            .set({'ideaList': ideaList}, SetOptions(merge: true));
      });
    } catch (error) {
      _logger.e("error at addIdeaIdToTeacher /StudentIdeaService.dart $error");
    }
    BotToast.closeAllLoading();
  }

  Future removeIdeaIdFromTeacher(String ideaId, String uid) async {
    BotToast.showLoading();
    try {
      //first fetch the existing list of ideas
      await _firebaseFirestore
          .collection("teacher")
          .doc(uid)
          .get()
          .then((docSnap) async {
        //now append the list with new idea id
        List<String> ideaList = List<String>.from(docSnap.get('ideaList'));
        ideaList.remove(ideaId);
        await _firebaseFirestore
            .collection("teacher")
            .doc(uid)
            .set({'ideaList': ideaList}, SetOptions(merge: true));
      });
    } catch (error) {
      _logger.e(
          "error at removeIdeaIdFromTeacher /StudentIdeaService.dart $error");
    }
    BotToast.closeAllLoading();
  }

  Future<List<IdeaModel>> getAllUserIdeas(String uid) async {
    List<IdeaModel> ideasList = [];
    try {
      await _firebaseFirestore
          .collection("post")
          .where('students', arrayContains: uid)
          .orderBy('timeStamp', descending: true)
          .get()
          .then((docsSnap) {
        for (var doc in docsSnap.docChanges) {
          ideasList.add(IdeaModel.fromJson(doc.doc));
        }
      });
    } catch (error) {
      _logger.e("error at getAllUserIdeas /StudentIdeaService.dart $error");
    }
    return ideasList;
  }

  Future<IdeaModel?> getIdea(String ideaId) async {
    IdeaModel? ideaModel;
    try {
      await _firebaseFirestore
          .collection("post")
          .doc(ideaId)
          .get()
          .then((docSnap) {
        ideaModel = IdeaModel.fromJson(docSnap);
      });
    } catch (error) {
      _logger.e("error at  getIdea/StudentIdeaService.dart $error");
    }
    return ideaModel;
  }

  Future acceptRejectIdea(String ideaId, String teacherUid, String status,
      List<String> studentsUid) async {
    BotToast.showLoading();
    try {
      await getIdea(ideaId).then((ideaModel) async {
        int rejectedTimes = ideaModel!.rejectedTimes;
        int noOfTeachers = ideaModel.noOfTeachers;
        if (status == "rejected") {
          await _firebaseFirestore.collection("post").doc(ideaId).set({
            'rejectedTimes': rejectedTimes + 1,
            'status':
                noOfTeachers <= (rejectedTimes + 1) ? 'rejected' : 'pending'
          }, SetOptions(merge: true)).then((value) {
            /// if all of the teachers rejected the idea then
            /// allow student to post another idea. i.e visible the plus button
            if (noOfTeachers <= (rejectedTimes + 1)) {
              Future.forEach(studentsUid, (uid) async {
                await _firebaseFirestore
                    .collection("student")
                    .doc(uid.toString())
                    .set({
                  'available': 'yes',
                }, SetOptions(merge: true));
              });
            }
          });
        } else {
          await _firebaseFirestore.collection("post").doc(ideaId).set(
              {'acceptedBy': teacherUid, 'status': 'accepted'},
              SetOptions(merge: true)).then((value) async {
            /// Create empty result of each student
            await Future.forEach(studentsUid, (sUid) async {
              await _firebaseFirestore
                  .collection('result')
                  .doc('2021-2022')
                  .collection('marks')
                  .doc(sUid.toString())
                  .set(MarksModel(sUid.toString(), "no", "").toJson());
            });

            /// if one of the teacher accepted the idea then
            /// allow student to post another idea. i.e visible the plus button

            // Future.forEach(studentsUid, (uid) async{
            //   await _firebaseFirestore.collection("student").doc(uid.toString()).set({
            //     'available':'yes',
            //   },SetOptions(merge: true));
            // });
          });
        }
      });
    } catch (error) {
      _logger.e("error at acceptRejectIdea/StudentIdeaService.dart $error");
    }
    BotToast.closeAllLoading();
  }

  Future<List<IdeaModel>> getAllAcceptedIdeas() async {
    List<IdeaModel> listOfIdeas = [];
    try {
      await _firebaseFirestore
          .collection('post')
          .where('acceptedBy', isNotEqualTo: '')
          .get()
          .then((querySnap) {
        querySnap.docs.forEach((doc) {
          listOfIdeas.add(IdeaModel.fromJson(doc));
        });
      });
    } catch (error) {
      _logger.e("error at getAllAcceptedIdeas/StudentIdeaService.dart $error");
    }
    return listOfIdeas;
  }

  Future editIdeaTitle(String title, String ideaId) async {
    await _firebaseFirestore.collection("post").doc(ideaId).update({
      "ideaTitle": title,
    });
  }

  Future changeSupervisor(String ideaId, String supervisorUid) async {
    try {
      await _firebaseFirestore.collection("post").doc(ideaId).update({
        "acceptedBy": supervisorUid,
      });
    } catch (error) {
      _logger.e("error at changeSupervisor/StudentIdeaService.dart $error");
    }
  }

  Future deleteIdea(String ideaId, List<String> studentsUid) async {


    BotToast.showLoading();
    try {
      ///remove idea from committee and if only one idea is there then remove the committee
      await _firebaseFirestore
          .collection('committee')
          .where('ideaList', arrayContains: ideaId)
          .get()
          .then((querySnap) async {
            await Future.forEach(querySnap.docs,
                (QueryDocumentSnapshot queryDoc) async {
              CommitteeModel committeeModel = CommitteeModel.fromJson(queryDoc);
              if (committeeModel.ideaList.length == 1) {
                //delete the whole document which contains only this idea

                await queryDoc.reference.delete();
              } else {
                final tempList = committeeModel.ideaList;

                tempList.remove(ideaId);

                await queryDoc.reference.update({
                  "ideaList":tempList
                });
              }
            });
          });

      ///remove idea from student and teacher if exist
      await _firebaseFirestore
          .collection('student')
          .where('ideaList', arrayContains: ideaId)
          .get()
          .then((querySnap) async{
           await Future.forEach( querySnap.docs, (QueryDocumentSnapshot queryDoc) async{

             UserSignupModel student=UserSignupModel.fromJson(queryDoc);
             List<String> tempList= student.ideaList;

             tempList.remove(ideaId);

             await queryDoc.reference.update({"ideaList":tempList});

           });
      });
      ///remove from teacher
      await _firebaseFirestore
          .collection('teacher')
          .where('ideaList', arrayContains: ideaId)
          .get()
          .then((querySnap) async{
        await Future.forEach( querySnap.docs, (QueryDocumentSnapshot queryDoc) async{

          UserSignupModel student=UserSignupModel.fromJson(queryDoc);
          List<String> tempList= student.ideaList;

          tempList.remove(ideaId);

          await queryDoc.reference.update({"ideaList":tempList});

        });
      });

      ///the student can add new idea now
      await Future.forEach(studentsUid, (uid) async{
                       await _firebaseFirestore.collection("student").doc(uid.toString()).set({
                         'available':'yes',
                       },SetOptions(merge: true));
                     });


      ///now delete the post
      await _firebaseFirestore.collection("post").doc(ideaId).delete();
    } catch (error) {
      _logger.e("error at deleteIdea/StudentIdeaService.dart $error");
    }

    BotToast.closeAllLoading();
  }
}
