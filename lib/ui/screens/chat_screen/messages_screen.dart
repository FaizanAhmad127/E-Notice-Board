import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/chat/message_model.dart';
import 'package:notice_board/core/services/file_management/file_download_open_service.dart';
import 'package:notice_board/ui/screens/chat_screen/messages_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/models/chat/chat_model.dart';

class MessagesScreen extends StatelessWidget {
  ChatModel previousChatModel;
  String receiverUser;
  String thisUser;
  ScrollController _scrollController=ScrollController();
   MessagesScreen(this.previousChatModel,this.receiverUser,this.thisUser,{Key? key}) : super(key: key);

  Widget listItem(MessageModel messageModel)
  {
    return  Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Align(
              alignment: messageModel.sentBy==thisUser?Alignment.centerRight:Alignment.centerLeft,
              child: Container(
                width: 0.6.sw,
                  decoration: BoxDecoration(
                      color: messageModel.sentBy==thisUser?kPrimaryColor:kWhiteColor,
                    borderRadius: BorderRadius.only(
                      topRight:messageModel.sentBy==thisUser? Radius.circular(0):Radius.circular(15.r),
                      bottomRight:messageModel.sentBy==thisUser?Radius.circular(0) :Radius.circular(5.r),
                      topLeft:messageModel.sentBy==thisUser? Radius.circular(15.r):Radius.circular(0),
                      bottomLeft:messageModel.sentBy==thisUser?Radius.circular(5.r) :Radius.circular(0),

                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: messageModel.text!.isNotEmpty?Text(
                      messageModel.text??"",
                      maxLines: 3,
                      style: kPoppinsMedium500.copyWith(
                        color: messageModel.sentBy==thisUser?kWhiteColor:kBlackColor,
                        fontSize: 14.sp,
                      ),
                    )
                    :GestureDetector(
                      onTap: (){
                        FileDownloadOpenService().downloadFile(messageModel.fileModel?.fileUrl??"");
                      },
                      child: Text(
                        messageModel.fileModel?.fileName??"",
                        maxLines: 3,
                        style: kPoppinsMedium500.copyWith(
                          color: messageModel.sentBy==thisUser?Colors.yellow:Colors.blueAccent,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ],

    );
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>MessagesScreenVM(previousChatModel,receiverUser,thisUser),
        builder: (context,viewModel)
        {
          return Consumer<MessagesScreenVM>(
            builder: (context,vm,child)
            {
              return SafeArea(
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Colors.indigo.shade400,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: kPrimaryColor,
                    title: vm.receiverSignupModel?.fullName!=null?Row(
                      children: [
                        vm.receiverSignupModel?.profilePicture==""?
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 1.w),
                          child: ClipOval(
                            child: Container(
                              color: Colors.grey,
                              height: 0.06.sh,
                              width: 0.06.sh,
                            ),
                          ),
                        ):
                        ClipOval(
                          child: Container(
                            color: Colors.grey,
                            height: 45.w,
                            width: 45.w,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CachedNetworkImage(
                                  imageUrl: vm.receiverSignupModel?.profilePicture??""
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width:15.w),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vm.receiverSignupModel?.fullName??"",
                                style: kPoppinsSemiBold600.copyWith(
                                    fontSize: 16.sp,
                                    color: kWhiteColor
                                ),
                              ),
                              Text(
                                vm.receiverSignupModel?.onlineStatus??"",
                                style: kPoppinsLight300.copyWith(
                                  fontSize: 12.sp,
                                    color:vm.receiverSignupModel?.onlineStatus=="online"?Colors.green:kWhiteColor
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    ):const SizedBox(),
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 10,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
                          child: SizedBox(
                            height: 0.89.sh,
                            child: ListView.builder(
                                reverse: true,
                                controller: _scrollController,
                                itemCount: vm.listOfMessages.length,
                                itemBuilder: (context,index){
                                  return listItem(vm.listOfMessages.reversed.elementAt(index));
                            }),
                          ),
                        ),
                      ),
                      Container(
                        height: 0.08.sh,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.r),
                                topRight: Radius.circular(10.r)
                            )
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 15.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async{
                                    await vm.sentFile();

                                  },
                                  child:  Icon(
                                      FontAwesomeIcons.fileCirclePlus,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w,),
                              Expanded(
                                flex: 10,
                                child: TextField(
                                  controller: vm.textEditingController,
                                    style: kPoppinsMedium500.copyWith(
                                      color: kWhiteColor,
                                      fontSize: 14.sp,
                                    ),
                                  decoration: InputDecoration(

                                      filled: true,
                                      fillColor:Colors.indigo.shade400,
                                      hintText: "Type Text Here",
                                    hintStyle: kPoppinsMedium500.copyWith(
                                      color: kTfBorderColor,
                                      fontSize: 14.sp
                                    ),

                                    border: InputBorder.none,

                                  ),

                                ),
                              ),
                              SizedBox(width: 10.w,),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async{
                                   await vm.sentText();
                                  },
                                  child:  Icon(
                                    FontAwesomeIcons.solidPaperPlane,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                            ],
                          )


                        ),

                      )
                    ],
                  )
                ),
              );
            },
          );
        });
  }
}
