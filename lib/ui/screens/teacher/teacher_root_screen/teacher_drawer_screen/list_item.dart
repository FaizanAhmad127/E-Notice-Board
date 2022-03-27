import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/services/date_time_service.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
class ListItem extends StatelessWidget {
  const ListItem(this._ideaModel,{Key? key}) : super(key: key);
  final IdeaModel _ideaModel;

  String ideaStatus(String status)
  {
    if(status=="accepted")
      {
        return "Accepted";
      }
    else if(status=="rejected")
      {
        return "Rejected";
      }
    else if(status=="pending")
      {
        return "Pending";
      }
    else
      {
        return "Finished";
      }
  }
  Color ideaColor(String status)
  {
    if(status=="accepted")
    {
      return kAcceptedColor;
    }
    else if(status=="rejected")
    {
      return kRejectedColor;
    }
    else if(status=="pending")
    {
      return kPrimaryColor;
    }
    else
    {
      return kAcceptedColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116.h,
      width: 150.w,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 86.w,
                    height:22.h ,
                    color: ideaColor(_ideaModel.status),
                    child: Center(
                      child: FittedBox(
                        child: Text(ideaStatus(_ideaModel.status),
                          style: kPoppinsMedium500.copyWith(
                              fontSize: 15.sp,
                              color: kWhiteColor
                          ),),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 7,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 13.h,horizontal: 7.w),
                    child: Column(
                      children: [
                        Expanded(
                          child: FittedBox(child:
                          Text(_ideaModel.ideaTitle,
                            style: kPoppinsMedium500.copyWith(
                              fontSize: 15.sp,
                            ),),),
                        ),
                        Expanded(
                          child: FittedBox(child:
                          Text(DateTimeService().getDMY(timeStamp: _ideaModel.timestamp),
                            style: kPoppinsLight300.copyWith(
                              fontSize: 12.sp,
                            ),),),
                        ),
                        Expanded(
                          child: FittedBox(child:
                          Text("Teacher ${_ideaModel.acceptedBy==""?"None":_ideaModel.acceptedBy}",
                            style: kPoppinsMedium500.copyWith(
                              fontSize: 10.sp,
                            ),),),
                        ),


                      ],
                    ),
                  )
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FittedBox(
                      child:
                  Container(
                    height: 5.h,
                    width: 150.w,
                    color: kPrimaryColor,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
