import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/chat/chat_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/date_time_service.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';
import 'package:notice_board/ui/screens/chat_screen/chat_screen_vm.dart';
import 'package:notice_board/ui/screens/chat_screen/messages_screen.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  String userType;
  String userId;
   ChatScreen(this.userType,this.userId,{Key? key}) : super(key: key);

  String getOppositeUser(ChatModel chatModel)
  {
    String user="";
    chatModel.user1Uid==userId?
        user="user2"
        : user="user1";
    return user;
  }
  String getThisUser(ChatModel chatModel)
  {
    String user="";
    chatModel.user1Uid==userId?
    user="user1"
        : user="user2";
    return user;
  }

  Widget listItem(BuildContext context, ChatScreenVM vm, ChatModel chatModel)
  {
    String oppositeUserNO=getOppositeUser(chatModel);
    String thisUserNo=getThisUser(chatModel);
    String timeDifference=DateTimeService().timeDifference(chatModel.recentTextTime??1);
    return SizedBox(
      width: 0.9.sw,
      height: 0.2.sh,
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(10),

          child: FutureBuilder(
            future: vm.getOppositeUserProfile(
              oppositeUserNO=="user1"?chatModel.user1Uid:chatModel.user2Uid,
              oppositeUserNO=="user1"?chatModel.user1Occupation:chatModel.user2Occupation,
            ),
            builder: (context,AsyncSnapshot<UserSignupModel?> userSignupModel)
            {
              if(userSignupModel.hasData)
                {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: ()
                    {
                      NavigationService().navigatePush(context, MessagesScreen(chatModel,oppositeUserNO,thisUserNo));
                    },
                    child: Row(
                      children: [
                        ///
                        /// Profile picture
                        ///
                        userSignupModel.data!.profilePicture!.isEmpty?
                        ClipOval(
                          child: Container(
                            height: 70.h,
                            width: 70.h,
                            color: Colors.grey,
                          ),
                        )
                        :ClipOval(
                          child: Container(
                            height: 70.h,
                            width: 70.h,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CachedNetworkImage(
                                imageUrl: userSignupModel.data!.profilePicture??"",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w,),
                        ///
                        ///Name and recent message
                        ///
                        Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child:  Text(userSignupModel.data!.fullName??"",
                                            style: kPoppinsSemiBold600.copyWith(
                                              fontSize: 16.sp,
                                            ),)
                                      ),
                                    )),
                                Expanded(child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    chatModel.recentText??"",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: kPoppinsLight300.copyWith(
                                        fontSize: 13.sp,
                                        color: kDateColor
                                    ),
                                  ),
                                )),
                              ],
                            )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: FittedBox(
                                  child: Text(
                                      timeDifference
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: ClipOval(
                                    child: (thisUserNo=="user1"?chatModel.user1UnReadCount:chatModel.user2UnReadCount)!=0?
                                    Container(
                                      width: 20.h,
                                      height: 20.h,
                                      color: kAcceptedColor,
                                      child: FittedBox(
                                        child: Text(
                                          thisUserNo=="user1"?chatModel.user1UnReadCount.toString():chatModel.user2UnReadCount.toString(),
                                          style: kPoppinsMedium500.copyWith(
                                              fontSize: 10.sp
                                          ),),
                                      ),
                                    ):
                                    SizedBox(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
              else
                {
                  return SizedBox();
                }
            },
          )
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>ChatScreenVM(userType,userId),
    builder: (context,viewModel)
    {
      return Consumer<ChatScreenVM>(
        builder: (context,vm,child)
        {
          return SafeArea(
            child: Scaffold(
              backgroundColor: kWhiteColor,
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///The Back button
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios
                            ),
                            Text("BACK",style: kPoppinsMedium500.copyWith(
                              fontSize: 16.sp
                            ),)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                        child: vm.listOfChatModel.isEmpty?
                          Center(
                           child: Text("Chat will appear once you have atleast one idea accepted"),)
                        :ListView.builder(
                            itemCount: vm.listOfChatModel.length,
                            itemBuilder: (context,index){
                          return listItem(context, vm,vm.listOfChatModel[index]);
                        }))
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
