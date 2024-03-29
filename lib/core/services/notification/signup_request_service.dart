import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/notification/signup_request_model.dart';
import '../../models/user_authentication/user_signup_model.dart';
import '../user_documents/user_profile_service.dart';

class SignupRequestService {

  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final Logger _logger=Logger();

  Future createSignupRequestDocument(String email,SignupRequestModel requestModel)async
  {
    BotToast.showLoading();
    try
    {
      await _firebaseFirestore.collection("approval").doc(email).set(requestModel.toJson());

    }
    catch(error)
    {
      _logger.e("error at createSignupRequestDocument/SignupRequestService.dart $error");
    }
    BotToast.closeAllLoading();
   }

   Future<SignupRequestModel?> getSignupRequestDocument(String email) async{

     SignupRequestModel? requestModel;
     BotToast.showLoading();

     try
     {
       DocumentSnapshot<Map<String,dynamic>> _documentReference= await _firebaseFirestore.collection("approval").doc(email).get();
       requestModel= SignupRequestModel.fromJson(_documentReference);
     }
     catch(error)
     {
       BotToast.showText(text: "Email is not registered");
       _logger.e("error at getSignupRequestDocument/SignupRequestService.dart $error");
     }
     BotToast.closeAllLoading();

     return requestModel;

   }
   Future approveSignupRequest(String email, String isApproved)async
   {
     BotToast.showLoading();
     try
     {
        await _firebaseFirestore.collection("approval").doc(email).
        set(
        {
          'isApproved':isApproved
        },SetOptions(merge: true)).then((value) {
          BotToast.showText(text: "Request ${isApproved=='yes'?"Approved":"Rejected"}");
        }).then((value) async{
          if(isApproved=='yes')
            {
              await _firebaseFirestore.collection("approval").doc(email)
                  .get().then((docSnap)async {
                    ///getting details from Signup Request Model
                ///and creating a relevant user document
                    SignupRequestModel signupRequestModel=SignupRequestModel.fromJson(docSnap);
                    await _userProfileService.createProfileDocument(
                      uid: signupRequestModel.uid??"",
                        userType: signupRequestModel.occupation??"",
                        userSignupModel: UserSignupModel(
                            signupRequestModel.email, signupRequestModel.universityId,
                            signupRequestModel.fullName, signupRequestModel.uid,
                            signupRequestModel.occupation));
              });
            }
        });

     }
     catch(error)
     {

       _logger.e("error at approveSignupRequest/SignupRequestService.dart $error");
     }
     BotToast.closeAllLoading();
   }

}