import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/ui/custom_widgets/custom_post_card/custom_post_card.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';
import 'package:notice_board/ui/custom_widgets/supervised_by_button/supervisedBy_Button.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_home_screen/coordinator_home_screen.dart';
import 'package:notice_board/ui/screens/student/student_Project_Status_Screen/pending_screen/pending_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../../../core/models/idea/idea_model.dart';
import 'coordinator_pending_screen_vm.dart';

class CoordinatorPendingScreen extends StatelessWidget {
   const CoordinatorPendingScreen({Key? key,required this.vm}) : super(key: key);
   final CoordinatorPendingScreenVM vm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhiteColor,
        body:  Column(
          children: [
            Expanded(child: CustomSearchField(
              searchTextEditingController: vm.searchController,
              hintText: "Search by Title",)),
            Expanded(
              flex: 8,
              child:  vm.getSearchList.isEmpty?
              const Center(child:Text("Nothing to show")):
              Padding(
                  padding: EdgeInsets.only(top: 22.h),
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
              ,),
          ],
        )
    );
  }
}
