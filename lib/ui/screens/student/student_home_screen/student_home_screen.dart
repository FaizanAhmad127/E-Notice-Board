import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/ui/custom_widgets/custom_post_card/custom_post_card.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';
import 'package:notice_board/ui/screens/student/add_idea-screen/add_idea_screen.dart';
import 'package:notice_board/ui/screens/student/student_home_screen/student_home_screen_vm.dart';
import 'package:provider/provider.dart';

class StudentHomeScreen extends StatelessWidget {
  StudentHomeScreen({Key? key}) : super(key: key);
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
        create:(context)=>StudentHomeScreenVM(),
      builder: (context,viewModel)
      {
        return Scaffold(
          backgroundColor: kWhiteColor,
          floatingActionButton: Consumer<StudentHomeScreenVM>(
            builder: (context,viewModel,child)
            {
              return  viewModel.isAvailable ?FloatingActionButton(
                onPressed: ()
                {
                  NavigationService().navigatePush(context,  AddIdeaScreen());
                },
                backgroundColor: kPrimaryColor,
                child: Icon(
                  Icons.add,
                  size: 35.r,
                ),
              ):Container();
            },
          ),
          body: SingleChildScrollView(
            child: Consumer<StudentHomeScreenVM>(
              builder: (context,vm,child)
              { return Column(
              children: [

                // Search box
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: FittedBox(
                        child: CustomSearchField(searchTextEditingController: vm.searchController,
                          hintText: "Search by Title",),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top: 18.h,right: 3.w),
                        child: FittedBox(
                          child: Container(
                            height: 0.064.sh,
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(
                                color: kPrimaryColor,
                              )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.w,right: 5.w),
                              child: DropdownButton<String>(
                                alignment: Alignment.center,
                                 underline: SizedBox(),
                                // hint: Text('Filter',
                                // style: kPoppinsSemiBold600.copyWith(
                                //   color: Colors.blueAccent,
                                //   fontSize: 13.sp
                                // ),),
                                icon: SizedBox(),
                                items: List.generate(vm.items.length, (index) =>
                                DropdownMenuItem(
                                    value: vm.items[index],

                                    child: FittedBox(child: Text(vm.items[index],
                                    style: kPoppinsMedium500.copyWith(
                                      fontSize: 13.sp
                                    ),)))
                                ),
                                value: vm.selectedItem,

                                onChanged: (String? value)
                                {
                                  vm.setSelectedItem=value??'Project';
                                  vm.searchIdeas(vm.searchController.text);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

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
                                      color: buttonColor(idea.status),
                                      text: buttonText(idea.status),
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
    required this.text,required this.color,
  }) : super(key: key);
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34.h,
      width: 87.w,
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
              fit: BoxFit.fill,
              child: Text(text,
                style: kPoppinsMedium500.copyWith(
                    fontSize: 15.sp,
                    color: kWhiteColor
                ),)),
        ),
      ));
  }
}
