import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/ui/custom_widgets/custom_post_card/custom_post_card.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';
import 'package:notice_board/ui/custom_widgets/supervised_by_button/supervisedBy_Button.dart';
import 'package:notice_board/ui/screens/student/student_Project_Status_Screen/finished_screen/finished_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../../../core/models/idea/idea_model.dart';

class FinishedScreen extends StatelessWidget {
   FinishedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>FinishedScreenVM(),
      builder: (context,viewmodel)
      {
        return Scaffold(
          backgroundColor: kWhiteColor,
          body: Consumer<FinishedScreenVM>(
            builder: (context,vm,child)
            {
         return Column(
            children: [
              Expanded(child: CustomSearchField(
                searchTextEditingController: vm.searchController,
                hintText: "Search by Title",)),
              Expanded(
                  flex: 8,
                  child:vm.getSearchList.isEmpty?
                      Center(child:Text("Nothing to show")):
                     Padding(
                          padding: EdgeInsets.only(top: 22.h),
                          child: ListView.builder(
                              itemCount: vm.getSearchList.length,
                              itemBuilder: (context,index){
                                IdeaModel idea=vm.getSearchList[index];
                                return CustomPostCard(button: SupervisedByButton(uid:idea.acceptedBy ,), ideaModel: idea);

                              })
                      )

              ),
            ],
          );
            },
          ),
        );
      },

    );
  }
}
