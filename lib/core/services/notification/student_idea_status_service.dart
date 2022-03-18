import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/notification/student_idea_status_model.dart';

class StudentIdeaStatusService {
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final Logger _logger=Logger();

  Future postNotification(List<String> studentsUid, StudentIdeaStatusModel statusModel)async{
    BotToast.showLoading();
     CollectionReference collectionReference= _firebaseFirestore.collection("student");
     try
     {
       for(String uid in studentsUid)
       {
         await collectionReference.doc(uid).collection("ideaStatusNotification").add(statusModel.toJson());
       }
     }
     catch(error)
    {
      _logger.e("error at postNotification/StudentIdeaStatusService $error");
    }
    BotToast.closeAllLoading();

  }

  Stream<List<StudentIdeaStatusModel>> getNotification(String uid)async*
  {
    print("fetching");
    List<StudentIdeaStatusModel> statusModelList=[];
    try
    {
           _firebaseFirestore.collection("student").doc(uid).collection("ideaStatusNotification").
          orderBy('timeStamp',descending: true).snapshots().listen((docsSnapshot) {
            print("inside listen");
            statusModelList=[];
            for (var doc in docsSnapshot.docChanges) {
              statusModelList.add(StudentIdeaStatusModel.fromJson(doc.doc));
            }

          });
           print("after listen");



    }
    catch(error)
    {
      _logger.e("error at getNotification/StudentIdeaStatusService $error");
    }
  }


}