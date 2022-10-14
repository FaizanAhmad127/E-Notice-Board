import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/ui/custom_widgets/custom_post_card/custom_post_card.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';
import 'package:notice_board/ui/custom_widgets/supervised_by_button/supervisedBy_Button.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_home_screen/coordinator_home_screen.dart';
import 'package:notice_board/ui/screens/student/student_Project_Status_Screen/finished_screen/finished_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/models/idea/idea_model.dart';
import '../../../../../core/services/navigation_service.dart';
import '../../../view_details_screen/view_details_screen.dart';
import 'coordinator_finished_screen_vm.dart';

class CoordinatorFinishedScreen extends StatelessWidget {
   CoordinatorFinishedScreen({Key? key,required this.vm}) : super(key: key);
   final CoordinatorFinishedScreenVM vm;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Column(
        children: [
          CustomSearchField(
            searchTextEditingController: vm.searchController,
            hintText: "Search by Title",),
          Expanded(
              child:vm.getSearchList.isEmpty?
              Center(child:Text("Nothing to show")):
              Padding(
                  padding: EdgeInsets.only(top: 12.h),
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
                            ideaModel: idea);

                      })
              )

          ),
        ],
      ),
    );
  }
}
