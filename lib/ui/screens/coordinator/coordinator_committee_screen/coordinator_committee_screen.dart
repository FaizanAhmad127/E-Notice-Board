import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_committee_screen/coordinator_committee_screen_vm.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_result_screen/coordinator_result_screen.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_result_screen/coordinator_result_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/navigation_service.dart';
import '../../marks_screen/marks_screen.dart';

class CoordinatorCommitteeScreen extends StatelessWidget {
  const CoordinatorCommitteeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CoordinatorCommitteeScreenVm(),
        builder: (context, vm) {
          return Consumer<CoordinatorCommitteeScreenVm>(
            builder: (context, vm, child) {
              return SafeArea(
                  child: Scaffold(
                      backgroundColor: kWhiteColor,
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
                              child: GestureDetector(
                                onTap: () {
                                  NavigationService()
                                      .navigatePush(context, MarksScreen());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        'Check Result',
                                        style: kPoppinsSemiBold600.copyWith(
                                          color: Colors.blueAccent,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.blueAccent,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                  onPressed: () {
                                    NavigationService().navigatePush(
                                        context, CoordinatorResultScreen());
                                  },
                                  child: Text('Create committee')),
                            )),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        'List of committees will appear below'))),
                            Expanded(
                                flex: 10,
                                child: vm.listOfCommittees.length!=0?ListView.builder(
                                    itemCount: vm.listOfCommittees.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          top: 0.03.sh,
                                        ),
                                        child: Container(
                                          height: 0.3.sh,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                            color:
                                                kPrimaryColor.withOpacity(0.5),
                                          )),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child:Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Teachers',
                                                      style: kPoppinsSemiBold600.copyWith(
                                                        fontSize: 13
                                                      ),),
                                                      Expanded(
                                                        child: CommitteeScrollView(
                                                          userType: 'teacher',
                                                          listOfCommitteeMembers: vm.listOfCommittees[index].teacherList??[],

                                                        ),
                                                      )
                                                    ],
                                                  )),
                                              VerticalDivider(
                                                thickness: 2,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Students',style: kPoppinsSemiBold600.copyWith(
                                                      fontSize: 13
                                                  ),),
                                                      Expanded(
                                                        child: CommitteeScrollView(
                                                          userType: 'student',
                                                          listOfCommitteeMembers: vm.listOfCommittees[index].studentList??[],

                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                      );
                                    }):Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        'No committee is created yet..',
                                    style: kPoppinsRegular400.copyWith(
                                      color: kFinPenTextColor,
                                      fontSize: 13
                                    ),)))
                          ],
                        ),
                      )));
            },
          );
        });
  }
}
class CommitteeScrollView extends StatefulWidget {
   CommitteeScrollView({Key? key,

     required this.listOfCommitteeMembers,
     required this.userType,}) : super(key: key);

  List<String> listOfCommitteeMembers;
  String userType;

  @override
  State<CommitteeScrollView> createState() => _CommitteeScrollViewState();
}

class _CommitteeScrollViewState extends State<CommitteeScrollView> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 0.01.sh,
          bottom: 0.01.sh,
          left: 0.01.sw,
          right: 0.01.sw),
      child: FutureBuilder(
        future: CoordinatorCommitteeScreenVm().getUserProfile(widget.listOfCommitteeMembers, widget.userType),
        builder: (context,AsyncSnapshot<List<UserSignupModel?>> snapshot)
        {
          if(snapshot.hasData && snapshot.data!.isNotEmpty)
            {
              return ListView.builder(
                      itemCount: snapshot.data!.length,

                      itemBuilder:
                          (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: 5,
                            ),

                          child: Text(
                            '${index+1}. ${snapshot.data![index]!.fullName??""}',
                            maxLines: 1,
                          ),
                        );
                      });
            }
          else if(snapshot.hasError)
            {
              return Text('Error');
            }
          else
            {
              return Text('Loading');
            }
        },
      ),
    );
  }

}

