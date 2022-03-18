import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/services/date_time_service.dart';
import 'package:notice_board/ui/custom_widgets/custom_post_card/custom_post_card_vm.dart';
import 'package:provider/provider.dart';

import '../../screens/student/student_home_screen/student_home_screen.dart';
class CustomPostCard extends StatelessWidget {
  CustomPostCard({
    Key? key,
     required this.button,
    required this.ideaModel
  }) : super(key: key);
 Widget button;
 final IdeaModel ideaModel;
 late String _dateTimeText;

  @override
  Widget build(BuildContext context) {
    _dateTimeText= DateTimeService().getDMY(timeStamp: ideaModel.timestamp);
    return ChangeNotifierProvider(
      create: (context)=>CustomPostCardVM(ideaModel.ideaOwner),
      builder: (context,viewmodel)
      {
        return Consumer<CustomPostCardVM>(
          builder: (context,vm,child)
          {
            return SizedBox(
              height: 173.h,
              child: Card(
                elevation: 1,
                color: kPostBackgroundColor,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h,bottom: 5.h,left: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(
                                flex:3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex:1,
                                      child: Align(
                                        alignment:Alignment.topLeft,
                                        child: CircleAvatar(
                                          radius: 30.r,
                                          backgroundColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: FittedBox(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  vm.getUserName,
                                                  style: kPoppinsMedium500.copyWith(
                                                      fontSize: 20.sp
                                                  ),
                                                ),
                                                Text(_dateTimeText,
                                                  style: kPoppinsLight300.copyWith(
                                                    fontSize: 15.sp,
                                                    color: kDateColor,
                                                  ),)
                                              ],),
                                          ),
                                        ))
                                  ],
                                )),
                            //
                            Expanded(
                                flex:2,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child:  button,))
                          ],
                        ),
                      ),
                      Expanded(child: FittedBox(
                        child: Text("TITLE: ${ideaModel.ideaTitle}",
                          style: kPoppinsMedium500.copyWith(
                            fontSize: 15.sp,
                          ),),
                      )),
                      Expanded(
                          flex: 3,
                          child:  Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: SingleChildScrollView(
                                  child: Text(ideaModel.ideaDescription,
                                    textAlign: TextAlign.start,

                                    maxLines: 6,
                                    style: kPoppinsLight300.copyWith(

                                        fontSize: 12.sp,
                                        color: kDateColor


                                    ),),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container())
                            ],
                          )),

                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}