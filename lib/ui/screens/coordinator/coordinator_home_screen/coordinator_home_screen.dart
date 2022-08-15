import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/ui/custom_widgets/custom_post_card/custom_post_card.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';
import 'package:notice_board/ui/custom_widgets/login_register_button/login_register_button.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_event_screen/coordinator_event_screen.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_home_screen/coordinator_home_screen_vm.dart';
import 'package:notice_board/ui/screens/view_details_screen/view_details_screen.dart';
import 'package:provider/provider.dart';

class CoordinatorHomeScreen extends StatelessWidget {
  CoordinatorHomeScreen({Key? key}) : super(key: key);

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
      create:(context)=>CoordinatorHomeScreenVM(),
      builder: (context,viewModel)
      {
        return Scaffold(
          backgroundColor: kWhiteColor,
          floatingActionButton: SizedBox(
            width: 0.22.sw,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ))
              ),
              onPressed: ()
              {
                NavigationService().navigatePush(context, CoordinatorEventScreen());
              }, child: Row(
              children: [
                Expanded(child: Icon(Icons.add,color: kWhiteColor,)),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: FittedBox(
                    child: Text('Event',style: kPoppinsRegular400.copyWith(
                      color: kWhiteColor,
                      fontSize: 15
                    ),),
                  ),
                ),
                SizedBox(width: 2,)
              ],
            ),

            ),
          ),
          body: SingleChildScrollView(
            child: Consumer<CoordinatorHomeScreenVM>(
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
                  const Center(child:Text("Nothing to show")):
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
