import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';

class StudentHomeScreen extends StatelessWidget {
  StudentHomeScreen({Key? key}) : super(key: key);
  final TextEditingController searchTextEditingController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
     body: Column(
       children: [

         // Search box
         Padding(
           padding: EdgeInsets.only(top: 17.h,left: 4.w,right: 4.w),
           child: Container(
             height: 40.h,
             decoration: BoxDecoration(
                 color: kWhiteColor,
                 border: Border.all(
                   color: kTfBorderColor
                 ),
                 borderRadius: BorderRadius.circular(5.r)
             ),
             child: Row(
               children: [
                 Container(
                   height: 40.h,
                   width: 50.w,
                   decoration: BoxDecoration(
                       color: kPrimaryColor,
                       borderRadius: BorderRadius.circular(5.r)
                   ),
                   child: Center(
                     child: Icon(Icons.search,color: kWhiteColor,),
                   ),
                 ),
                 SizedBox(
                   width: 10.w,
                 ),
                 Container(
                     height: 40.h,
                     width: 206.w,
                     child: Center(
                       child: TextField(
                         controller: searchTextEditingController,

                         style: kPoppinsLight300.copyWith(
                             fontSize: 16.sp,
                             letterSpacing: 1

                         ),
                         keyboardType: TextInputType.number,
                         decoration: InputDecoration(
                          //contentPadding: EdgeInsets.only(bottom: 10.h),
                           border: InputBorder.none,
                           hintText: "Search by Title",
                           hintStyle: kPoppinsLight300.copyWith(
                             fontSize: 16.sp,
                               color:kSearchTFHintColor
                           ),



                         ),
                       ),
                     ))
               ],
             ),
           ),
         ),
         SizedBox(
           height: 16.h,
         ),
         Padding(
           padding: EdgeInsets.only(left: 4.w, right: 4.w),
           child: SizedBox(
             height: 0.7.sh,
             child: ListView.builder(
               itemCount: 4,
                 itemBuilder: (context,index){
               return postCard();
             })
           ),
         )
       ],
     ),
    );
  }

  SizedBox postCard() {
    return SizedBox(
               height: 173.h,
               child: Card(
                 elevation: 1,
                 color: kPostBackgroundColor,
                 child: Padding(
                   padding: EdgeInsets.only(top: 10.h,bottom: 5.h,left: 15.w),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,

                     children: [
                       Expanded(
                         flex: 2,
                         child: Row(
                           children: [
                             Expanded(
                               flex:3,
                                 child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     Expanded(
                                       flex:1,
                                       child: Align(
                                         alignment:Alignment.topLeft,
                                         child: CircleAvatar(
                                           radius: 30.r,
                                           backgroundColor: Colors.grey,
                                         ),
                                       ),
                                     ),
                                     Expanded(
                                       flex: 3,
                                         child: Align(
                                       alignment: Alignment.topLeft,
                                           child: FittedBox(
                                             child: Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                               Text(
                                                 "ALI KHAN ",
                                                 style: kPoppinsMedium500.copyWith(
                                                   fontSize: 20.sp
                                                 ),
                                               ),
                                               Text("25 February, 2022",
                                               style: kPoppinsLight300.copyWith(
                                                 fontSize: 15.sp,
                                                   color: kDateColor,
                                               ),)
                                             ],),
                                           ),
                                         ))
                                   ],
                                 )),
                             //
                             Expanded(
                                 flex:1,
                                 child: Align(
                                   alignment: Alignment.topRight,
                                     child: SizedBox(
                                       height: 34.h,
                                       width: 87.w,
                                       child: ElevatedButton(
                                         onPressed: ()
                                         {

                                         },
                                         style: ButtonStyle(
                                           padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w)),
                                           backgroundColor: MaterialStateProperty.all(kAcceptedColor),
                                         ),
                                         child: FittedBox(
                                           fit: BoxFit.cover,
                                             child: Text("Accepted",
                                         style: kPoppinsMedium500.copyWith(
                                           fontSize: 15.sp,
                                           color: kWhiteColor
                                         ),)),
                                       ),
                                     )))
                           ],
                         ),
                       ),
                       Expanded(child: FittedBox(
                         child: Text("TITLE: Auto Machine",
                         style: kPoppinsMedium500.copyWith(
                           fontSize: 15.sp,
                         ),),
                       )),
               Expanded(
                 flex: 3,
                   child:  Row(
                     children: [
                       Expanded(
                         flex: 5,
                         child: SingleChildScrollView(
                           child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing "
                               +"elit. Aenean sodales, tellus vehicula feugiat vulputate, ante nu"
                               +"lla aliquet arcu, a lobortis lectus lacus vestibulum leo. "+
                               "Crassed accumsan est, nec euismod eros.",
                             textAlign: TextAlign.start,
                             maxLines: 6,
                             style: kPoppinsLight300.copyWith(
                                 fontSize: 12.sp,
                                 color: kDateColor

                             ),),
                         ),
                       ),
                       Expanded(
                         flex: 1,
                           child: Container())
                     ],
                   )),

               ],
                   ),
                 ),
               ),
             );
  }
}
