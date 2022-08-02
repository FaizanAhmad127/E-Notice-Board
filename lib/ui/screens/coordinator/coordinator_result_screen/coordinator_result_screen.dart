import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/ui/custom_widgets/custom_multiselect_dropdown.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_result_screen/coordinator_result_screen_vm.dart';
import 'package:notice_board/ui/screens/marks_screen/marks_screen.dart';
import 'package:provider/provider.dart';

import '../../../custom_widgets/login_register_button/login_register_button.dart';
import '../coordinator_committee_screen/coordinator_committee_screen.dart';

class CoordinatorResultScreen extends StatelessWidget {
   CoordinatorResultScreen({Key? key,}) : super(key: key);

   ScrollController scrollController=ScrollController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>CoordinatorResultScreenVm(),
    builder: (context,viewModel)
    {
      return Consumer<CoordinatorResultScreenVm>(
          builder: (context,vm,child)
      {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.only(
              left: 0.05.sw,
              right: 0.05.sw,
              top: 0.035.sh,
              bottom: 0.01.sh,
            ),
            child: Column(

              children: [
                Expanded(
                    flex:10,child: ListView(
                  children: [

                    ///select teacher dropdown
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(children: [
                      FittedBox(
                        child: Text('Select Teachers For Committee',
                          style: kPoppinsLight300.copyWith(
                              color: kDateColor,
                              fontSize: 15.sp
                          ),),
                      )
                    ],),
                    CustomMultiselectDropDown(
                        selectedList: (selectedlist) {

                          if (selectedlist.length == 5) {
                            BotToast.showText(
                                text: "That's it, Only 5 teachers");
                          }
                          vm.setSelectedTeachersList = selectedlist;
                        },
                        userModelList: vm.listOfTeachers,
                        limit: 5,
                        labelText: "Select Teachers"),


                    ///select group dropdown
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(children: [
                      FittedBox(
                        child: Text('Select Groups For Committee',
                          style: kPoppinsLight300.copyWith(
                              color: kDateColor,
                              fontSize: 15.sp
                          ),),
                      )
                    ],),
                    GroupDropDown(
                      vm: vm,
                    selectedList: (List<String> selectedIdeaList){
                        vm.setSelectedIdeaList=selectedIdeaList;
                    },
                    ),

                    // CustomMultiselectDropDown(
                    //     selectedList: (selectedlist) {
                    //
                    //       if (selectedlist.length == 10) {
                    //         BotToast.showText(
                    //             text: "That's it, Only 10 students");
                    //       }
                    //       vm.setSelectedStudentsList = selectedlist;
                    //     },
                    //     userModelList: vm.listOfStudents,
                    //     limit: 10,
                    //     labelText: "Select Students"),


                    // SizedBox(
                    //   height: 40.h,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     FittedBox(
                    //       fit: BoxFit.scaleDown,
                    //       child:
                    //       Text('List of teachers in committee: '),)
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 10.h,
                    // ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: kPrimaryColor.withOpacity(0.5)
                    //     )
                    //   ),
                    //     height: 100.h,
                    //     child: vm.listOfCommitteeTeachers.length>0?
                    //     Scrollbar(
                    //       controller: scrollController,
                    //       isAlwaysShown: true,
                    //       thickness: 10,
                    //       trackVisibility: true,
                    //       child: ListView.builder(
                    //         controller: scrollController,
                    //       itemCount: vm.listOfCommitteeTeachers.length,
                    //       itemBuilder: (context,index)
                    //       {
                    //         return SizedBox(
                    //           height: 20.h,
                    //           child: Align(
                    //             alignment: Alignment.centerLeft,
                    //             child: FittedBox(
                    //               child: Text('${index+1} .  ${vm.listOfCommitteeTeachers[index].fullName??""}',
                    //               style: kPoppinsMedium500.copyWith(
                    //                 fontSize: 20.sp
                    //               ),),
                    //             ),
                    //           ),
                    //         );
                    //       }
                    // ),
                    //     ):FittedBox(
                    //       fit: BoxFit.scaleDown,
                    //         child:Text('Teachers Name will appear here',
                    //         style: kPoppinsMedium500,)
                    //     )
                    // ),
                    // ///
                    // /// showing list of students who are already added to committee
                    // ///
                    // SizedBox(
                    //   height: 40.h,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     FittedBox(
                    //       fit: BoxFit.scaleDown,
                    //       child:
                    //       Text('List of students in committee: '),)
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 10.h,
                    // ),
                    // Container(
                    //     decoration: BoxDecoration(
                    //         border: Border.all(
                    //             color: kPrimaryColor.withOpacity(0.5)
                    //         )
                    //     ),
                    //     height: 100.h,
                    //     child: vm.listOfCommitteeStudents.length>0?
                    //     Scrollbar(
                    //       controller: scrollController,
                    //       isAlwaysShown: true,
                    //       thickness: 10,
                    //       trackVisibility: true,
                    //       child: ListView.builder(
                    //           controller: scrollController,
                    //           itemCount: vm.listOfCommitteeStudents.length,
                    //           itemBuilder: (context,index)
                    //           {
                    //             return SizedBox(
                    //               height: 20.h,
                    //               child: Align(
                    //                 alignment: Alignment.centerLeft,
                    //                 child: FittedBox(
                    //                   child: Text('${index+1} .  ${vm.listOfCommitteeStudents[index].fullName??""}',
                    //                     style: kPoppinsMedium500.copyWith(
                    //                         fontSize: 20.sp
                    //                     ),),
                    //                 ),
                    //               ),
                    //             );
                    //           }
                    //       ),
                    //     ):FittedBox(
                    //         fit: BoxFit.scaleDown,
                    //         child:Text('Students Name will appear here',
                    //           style: kPoppinsMedium500,)
                    //     )
                    // )
                  ],
                )),

                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(

                        child: LoginRegisterButton(onPressed: (){
                         Navigator.pop(context);
                        }, buttonText: "Back"),
                      ),
                      SizedBox(width: 20.w,),
                      Expanded(
                        child: LoginRegisterButton(onPressed: ()async{
                         await vm.setCommitteeTeacherIdea().then((value) {
                           if(value)
                             {
                               NavigationService().navigatePushReplacement(context, CoordinatorCommitteeScreen());

                             }
                         });
                        }, buttonText: "SUBMIT"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );;
      });

    },);
  }
}

class GroupDropDown extends StatefulWidget {
   GroupDropDown({Key? key,
    required this.vm,
   required this.selectedList}) : super(key: key);
  CoordinatorResultScreenVm vm;
  Function(List<String>) selectedList;

  @override
  State<GroupDropDown> createState() => _GroupDropDownState();
}

class _GroupDropDownState extends State<GroupDropDown> {

  late CoordinatorResultScreenVm vm;
  List<String> listOfSelectedIdeaId=[];


  @override
  void initState() {
    super.initState();
    vm=widget.vm;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      decoration:
      BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
      child: ExpansionTile(
        iconColor: Colors.grey,
        title:
        Text('Select Groups',
            style: kPoppinsRegular400.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 15.0,
            )),
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: vm.listOfIdeas.length,
              itemBuilder: (context,topIndex){
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade100,
                      )
                  ),
                  child: Padding(
                    padding:
                    EdgeInsets.only(left: 10.w, right:  10.w,bottom: 10.w),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: Checkbox(
                            value: listOfSelectedIdeaId.isEmpty?false:listOfSelectedIdeaId.contains(vm.listOfIdeas[topIndex].ideaId),
                            onChanged: (val) {
                              setState(() {
                                if(listOfSelectedIdeaId.contains(vm.listOfIdeas[topIndex].ideaId))
                                  {
                                    listOfSelectedIdeaId.remove(vm.listOfIdeas[topIndex].ideaId);
                                  }
                                else
                                  {
                                    listOfSelectedIdeaId.add(vm.listOfIdeas[topIndex].ideaId);
                                  }
                               widget.selectedList(listOfSelectedIdeaId);

                              });
                            },
                            activeColor: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              vm.listOfGroups[topIndex].length, (index) {
                            return Text(  vm.listOfGroups[topIndex][index]?.fullName??"",
                                style: kPoppinsRegular400.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17.0,
                                ));
                          })
                          ,
                        )

                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }

}

