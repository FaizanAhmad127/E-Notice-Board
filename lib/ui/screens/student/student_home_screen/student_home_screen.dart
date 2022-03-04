import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/ui/custom_widgets/custom_post_card/custom_post_card.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';

class StudentHomeScreen extends StatelessWidget {
  StudentHomeScreen({Key? key}) : super(key: key);
  final TextEditingController searchTextEditingController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
     floatingActionButton: FloatingActionButton(
       onPressed: ()
       {

       },
       backgroundColor: kPrimaryColor,
       child: Icon(
         Icons.add,
         size: 35.r,
       ),
     ),
     body: SingleChildScrollView(
       child: Column(
         children: [

           // Search box
          custom_search_field(searchTextEditingController: searchTextEditingController),
           SizedBox(
             height: 16.h,
           ),
           Padding(
             padding: EdgeInsets.only(left: 4.w, right: 4.w),
             child: SizedBox(
               height: 0.7.sh,
               child: ListView.builder(
                 itemCount: 5,
                   itemBuilder: (context,index){
                 return custom_post_card(
                   button: AcceptedRejectedButton(
                     color: kAcceptedColor,
                     text: "Accepted",
                   ),
                 );
               })
             ),
           )
         ],
       ),
     ),
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
      child: ElevatedButton(
        onPressed: ()
        {

        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w)),
          backgroundColor: MaterialStateProperty.all(color),
        ),
        child: FittedBox(
          fit: BoxFit.cover,
            child: Text(text,
        style: kPoppinsMedium500.copyWith(
          fontSize: 15.sp,
          color: kWhiteColor
        ),)),
      ),
    );
  }
}
