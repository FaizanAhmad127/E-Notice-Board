import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/ui/custom_widgets/custom_post_card/custom_post_card.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';
import 'package:notice_board/ui/custom_widgets/supervised_by_button/supervisedByButton.dart';

class PendingScreen extends StatelessWidget {
   PendingScreen({Key? key}) : super(key: key);

  final TextEditingController searchTextEditingController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Column(
        children: [
          Expanded(child: custom_search_field(
            searchTextEditingController: searchTextEditingController,)),
          Expanded(
              flex: 8,
              child: Padding(
                padding: EdgeInsets.only(top: 22.h),
                child: ListView.builder(
                    itemCount: 113,
                    itemBuilder: (context,index){
                      return custom_post_card(button: SupervisedByButton());
                    }),
              )),
        ],
      ),
    );
  }
}
