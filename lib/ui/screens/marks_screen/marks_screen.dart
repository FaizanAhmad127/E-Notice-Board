import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';
import 'package:notice_board/ui/screens/marks_screen/marks_screen_vm.dart';
import 'package:provider/provider.dart';

class MarksScreen extends StatelessWidget {
  const MarksScreen({Key? key}) : super(key: key);

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
                  CustomSearchField(
                      searchTextEditingController: vm.searchTFController,
                      hintText: 'Search By Name'),
                  SizedBox(
                    height: 0.05.sh,
                  ),
                  SizedBox(
                    height: 0.8.sh,
                    child: ListView.builder(
                        itemCount: 2,
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
                                                  'Faizan Ahmad',
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
                                                          '00',
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
                                                ///OBE-1
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
                                                      'OBE-1: ',
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
                                                          '80',
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
                                                              '58',
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
                                                                      '66',
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
                                                                      '58',
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
                                                      '100',
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
