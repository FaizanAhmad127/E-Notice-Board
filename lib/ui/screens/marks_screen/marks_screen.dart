import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';
import 'package:notice_board/ui/screens/marks_screen/marks_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../core/models/result/marks_model.dart';

class MarksScreen extends StatelessWidget {
  const MarksScreen({Key? key}) : super(key: key);
  double getFyp1Total(MarksModel marksModel,int index)
  {
    double result=0;
    double obe2=getObe2(marksModel, index);
    double obe3=getObe3(marksModel, index);
    double obe4=getObe4(marksModel, index);
    double fyp1Viva=marksModel.fyp1Viva;

    result=obe2+obe3+obe4+fyp1Viva;

    return result;
  }

  double getObe2(MarksModel marksModel, int index)
  {
    double result=0;
    marksModel.obe2.forEach((key, value) {
      result=result+value;
    });

    if(result>0)
      {
        //taking average by sum of all marks given by teacher
        // and divide by no of teachers.
        result=result/marksModel.obe2.length;
        //obe2 has 10% in all Fyp1 marks which is 100
        result=(result/16)*10;
      }
    return result;

  }
  double getObe3(MarksModel marksModel, int index)
  {
    double result=0;
    marksModel.obe3.forEach((key, value) {
      result=result+value;
    });
    if(result>0)
    {
      //taking average by sum of all marks given by teacher
      // and divide by no of teachers.
      result=result/marksModel.obe3.length;
      //obe2 has 10% in all Fyp1 marks which is 100
      result=(result/16)*30;
    }
    return result;
  }
  double getObe4(MarksModel marksModel, int index)
  {
    double result=0;
    marksModel.obe4.forEach((key, value) {
      result=result+value;
    });
    if(result>0)
    {
      //taking average by sum of all marks given by teacher
      // and divide by no of teachers.
      result=result/marksModel.obe4.length;
      //obe2 has 10% in all Fyp1 marks which is 100
      result=(result/16)*20;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MarksScreenVM(),
      builder: (context, viewModel) {
        return Consumer<MarksScreenVM>(builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.only(
                left: 0.05.sw,
                right: 0.05.sw,
                top: 0.035.sh,
                bottom: 0.01.sh,
              ),
              child: ListView(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back,size: 30,))
                    ],
                  ),
                  vm.userType!='student'?CustomSearchField(
                      searchTextEditingController: vm.searchTFController,
                      hintText: 'Search By Name'):const SizedBox(),
                  vm.resultModel==null?Row(
                    children: [
                      SizedBox(
                        height: 0.05.sh,
                      ),
                      Text('Note: The result is not finalized yet',
                      style: kPoppinsMedium500.copyWith(
                        fontSize: 13,
                        color: kRejectedColor
                      ),),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                    ],
                  ):vm.resultModel!.isResultFinalized=='no'
                      ?
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 0.05.sh,
                              ),
                              Text('Note: The result is not finalized yet',
                                style: kPoppinsMedium500.copyWith(
                                    fontSize: 13,
                                    color: kRejectedColor
                                ),),

                              SizedBox(
                                height: 0.02.sh,
                              ),
                            ],
                          ),

                          vm.userType=='coordinator'?
                          Row(
                              children: [
                                Text('Wanna finalize?',
                                  style: kPoppinsMedium500.copyWith(
                                      fontSize: 13,
                                      color: kPrimaryColor
                                  ),),
                                SizedBox(
                                  width: 0.02.sw,
                                ),
                                GestureDetector(
                                  onTap: ()async
                                  {
                                    await vm.finalizeResult();

                                  },
                                  child: Text('Yes',
                                    style: kPoppinsRegular400.copyWith(
                                        color: Colors.blue,
                                      fontSize: 14
                                    ),),
                                )
                              ]
                          ) :SizedBox(),
                        ],
                      )
                  :
                  Row(
                    children: [
                      SizedBox(
                        height: 0.05.sh,
                      ),
                      Text('Note: The result is finalized',
                        style: kPoppinsMedium500.copyWith(
                            fontSize: 13,
                            color: kAcceptedColor
                        ),),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.03.sh,
                  ),
                  SizedBox(
                    height: 0.7.sh,
                    child: ListView.builder(
                        itemCount: vm.searchedStudentMarksMap.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 0.03.sh),
                            child: Container(
                              height: 0.3.sh,
                              decoration: BoxDecoration(
                                  color: kDateColor,
                                  borderRadius: BorderRadius.circular(5.r),
                                  boxShadow: []),
                              child: Padding(
                                padding: EdgeInsets.all(5.r),
                                child: Column(
                                  children: [
                                    ///Name
                                    Expanded(
                                        child: Row(
                                      children: [
                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'Name: ',
                                              style: kPoppinsBold700.copyWith(
                                                fontSize: 18.sp,
                                                color: Colors.white
                                              ),
                                            ),
                                          ),
                                        )),
                                        Expanded(
                                            flex: 3,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  vm.searchedStudentMarksMap.keys.elementAt(index),
                                                  style: kPoppinsSemiBold600
                                                      .copyWith(
                                                    fontSize: 15.sp,
                                                      color: Colors.white
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ],
                                    )),

                                    ///FYP-1
                                    Expanded(
                                      flex: 2,
                                        child: Container(
                                      decoration: BoxDecoration(
                                          color: kFinPenPressedColor,
                                          borderRadius:
                                              BorderRadius.circular(5.r)),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.r),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Row(
                                              children: [
                                                Expanded(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      'FYP-1 Total: ',
                                                      style: kPoppinsBold700
                                                          .copyWith(
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                                Expanded(
                                                    flex: 3,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          getFyp1Total(vm.searchedStudentMarksMap.values.elementAt(index), index).toString(),
                                                          style:
                                                              kPoppinsSemiBold600
                                                                  .copyWith(
                                                            fontSize: 15.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            )),
                                            ///OBE-1 AND OBE-2 ROW
                                            Expanded(
                                                child: Row(
                                              children: [
                                                ///OBE-2
                                                Expanded(
                                                    child: Row(
                                                  children: [
                                                    Expanded(
                                                    child: Align(
                                                      alignment:
                                                      Alignment.centerLeft,
                                                      child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      'OBE-2: ',
                                                      style: kPoppinsBold700
                                                          .copyWith(
                                                        fontSize: 15.sp,
                                                      ),
                                                    ),
                                                      ),
                                                    )),
                                                    Expanded(
                                                    flex: 3,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: FittedBox(
                                                        fit: BoxFit
                                                            .scaleDown,
                                                        child: Text(
                                                          getObe2(vm.searchedStudentMarksMap.values.elementAt(index), index).toString(),
                                                          style:
                                                              kPoppinsSemiBold600
                                                                  .copyWith(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                  ],
                                                )),
                                                ///OBE-3
                                                Expanded(
                                                    child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          'OBE-3: ',
                                                          style: kPoppinsBold700
                                                              .copyWith(
                                                            fontSize: 15.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                    Expanded(
                                                        flex: 3,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            child: Text(
                                                              getObe3(vm.searchedStudentMarksMap.values.elementAt(index), index).toString(),
                                                              style:
                                                                  kPoppinsSemiBold600
                                                                      .copyWith(
                                                                fontSize: 12.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ))
                                              ],
                                            )),
                                            Expanded(
                                                child: Row(
                                                  children: [
                                                    ///OBE-4
                                                    Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment.centerLeft,
                                                                  child: FittedBox(
                                                                    fit: BoxFit.scaleDown,
                                                                    child: Text(
                                                                      'OBE-4: ',
                                                                      style: kPoppinsBold700
                                                                          .copyWith(
                                                                        fontSize: 15.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                            Expanded(
                                                                flex: 3,
                                                                child: Align(
                                                                  alignment: Alignment
                                                                      .centerLeft,
                                                                  child: FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      getObe4(vm.searchedStudentMarksMap.values.elementAt(index), index).toString(),
                                                                      style:
                                                                      kPoppinsSemiBold600
                                                                          .copyWith(
                                                                        fontSize: 12.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        )),
                                                    ///FYP-1 VIVA
                                                    Expanded(

                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex:2,
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment.centerLeft,
                                                                  child: FittedBox(
                                                                    fit: BoxFit.scaleDown,
                                                                    child: Text(
                                                                      'FYP-1 Viva: ',
                                                                      style: kPoppinsBold700
                                                                          .copyWith(
                                                                        fontSize: 15.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                            Expanded(
                                                                flex: 3,
                                                                child: Align(
                                                                  alignment: Alignment
                                                                      .centerLeft,
                                                                  child: FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      vm.searchedStudentMarksMap.values.elementAt(index).fyp1Viva.toString(),
                                                                      style:
                                                                      kPoppinsSemiBold600
                                                                          .copyWith(
                                                                        fontSize: 12.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        ))
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    )),
                                    SizedBox(height: 0.01.sh,),
                                    Expanded(
                                        child: Container(
                                      decoration: BoxDecoration(
                                          color: kFinPenPressedColor,
                                          borderRadius:
                                          BorderRadius.circular(5.r)),
                                      child:  Padding(
                                        padding: EdgeInsets.all(5.r),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Align(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      'FYP-2 Total: ',
                                                      style: kPoppinsBold700
                                                          .copyWith(
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                            Expanded(
                                                flex: 3,
                                                child: Align(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      vm.searchedStudentMarksMap.values.elementAt(index).fyp2Viva.toString(),
                                                      style:
                                                      kPoppinsSemiBold600
                                                          .copyWith(
                                                        fontSize: 15.sp,
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
