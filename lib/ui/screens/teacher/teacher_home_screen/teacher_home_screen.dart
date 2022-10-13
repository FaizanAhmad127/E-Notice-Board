import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/ui/custom_widgets/custom_post_card/custom_post_card.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';
import 'package:notice_board/ui/screens/student/add_idea-screen/add_idea_screen.dart';
import 'package:notice_board/ui/screens/student/student_home_screen/student_home_screen_vm.dart';
import 'package:notice_board/ui/screens/teacher/teacher_home_screen/teacher_home_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../view_details_screen/view_details_screen.dart';

class TeacherHomeScreen extends StatelessWidget {
  TeacherHomeScreen({Key? key}) : super(key: key);
 // final TextEditingController searchTextEditingController=TextEditingController();


  Color buttonColor(String text)
  {
    Color color=Colors.blueGrey;
    if(text=="pending")
    {
      color=kSupervisedByColor;
    }
    else if(text=="accepted")
    {
      color=kAcceptedColor;
    }
    else if(text=="rejected")
    {
      color=kRejectedColor;
    }
    return color;
  }

  String buttonText(String text)
  {
    if(text=="pending")
    {
      text="Pending";
    }
    else if(text=="accepted")
    {
      text="Accepted";
    }
    else if(text=="rejected")
    {
      text="Rejected";
    }

    return text;
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create:(context)=>TeacherHomeScreenVM(),
      builder: (context,viewModel)
      {
        return Scaffold(
          backgroundColor: kWhiteColor,
          body: SingleChildScrollView(
            child: Consumer<TeacherHomeScreenVM>(
              builder: (context,vm,child)
              { return Column(
              children: [

                // Search box
                CustomSearchField(searchTextEditingController: vm.searchController,
                  hintText: "Search by Title",),
                SizedBox(
                  height: 16.h,
                ),
                vm.getSearchList.isEmpty?
                const Center(child:Text("Your accepted ideas will show here")):
                Padding(
                      padding: EdgeInsets.only(left: 4.w, right: 4.w),
                      child: SizedBox(
                          height: 0.7.sh,
                          child: ListView.builder(
                              itemCount: vm.getSearchList.length,
                              itemBuilder: (context,index){
                                IdeaModel idea=vm.getSearchList[index];
                                return CustomPostCard(
                                    button: AcceptedRejectedButton(
                                      ideaId: vm.getIdeasList[index].ideaId,
                                      color: kFinPenPressedColor,
                                      text: "View Details",
                                    ),
                                  ideaModel: idea,
                                );
                              })
                      ),
                    )

              ],
            );
              },
            ),
          ),
        );
      },
    );
  }
}

class AcceptedRejectedButton extends StatelessWidget {
  const AcceptedRejectedButton({
    Key? key,
    required this.text,required this.color,required this.ideaId
  }) : super(key: key);
  final String text;
  final Color color;
  final String ideaId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        NavigationService().navigatePush(context, ViewDetailsScreen(ideaId: ideaId));
      },
      child: SizedBox(
          height: 35.h,
          width: 110.w,
          child: Container(

            decoration: BoxDecoration(
                color: color,
                shape:BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(7.r),topLeft: Radius.circular(7.r),
                )
            ),
            child:  Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(text,
                    style: kPoppinsMedium500.copyWith(
                        fontSize: 15.sp,
                        color: kBlackColor
                    ),)),
            ),
          )),
    );
  }
}
