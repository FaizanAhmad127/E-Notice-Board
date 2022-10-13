import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/student_drawer_screen/student_drawer_screen_vm.dart';
import 'package:notice_board/ui/screens/teacher/teacher_root_screen/teacher_drawer_screen/teacher_drawer_screen_vm.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/cache_image_service.dart';
import '../../../../../core/services/navigation_service.dart';
import '../../../changepassword/change_password_screen.dart';
import 'list_item.dart';


class TeacherDrawerScreen extends StatelessWidget {
   TeacherDrawerScreen({Key? key}) : super(key: key);

  TextEditingController fullNameController=TextEditingController();
  TextEditingController occupationController=TextEditingController();
  bool isFirstTime=false;


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TeacherDrawerScreenVM(),
      builder: (context, viewModel) {
        return Consumer<TeacherDrawerScreenVM>(
          builder: (context,vm,child)
          {
            if(vm.fullNameValue.isNotEmpty)
              {
                if(isFirstTime==false)
                  {
                    fullNameController.text=vm.fullNameValue;
                    occupationController.text=vm.occupationValue;
                    isFirstTime=true;
                  }

              }

            return SizedBox(
              width: 0.95.sw,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                    child: SizedBox(
                      width: 0.95.sw,
                      height: 1.sh,
                      child: Drawer(
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30)),
                            side: BorderSide(color: kPrimaryColor, width: 1),
                          ),
                          child: Stack(
                            children: [
                            Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          ///
                          ///this expanded is for the half upper part
                          ///
                          Expanded(
                          child: Align(
                          alignment: Alignment.topLeft,
                            child: SizedBox(
                                width: double.infinity,
                                height: 300.h,
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 250.h,
                                      width: 400.w,
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: CacheImageService()
                                            .loadCacheImage(vm.imageUrl),
                                      ),
                                    ),
                                    Consumer<TeacherDrawerScreenVM>(
                                        builder: (context, vm, child) {
                                          return vm.isEditButtonClicked
                                              ? Positioned(
                                            bottom: 80.h,
                                            // left: 10.w,
                                            child: GestureDetector(
                                              onTap: ()
                                              {
                                                vm.chooseImage();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent
                                                      .withOpacity(0.7),
                                                  borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                    Radius.circular(15.r),
                                                    topRight: Radius.circular(15.r),
                                                  ),
                                                ),
                                                height: 50.h,
                                                width: 100.w,
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets.only(top: 5.h),
                                                          child: FittedBox(
                                                            child: Icon(
                                                              Icons.camera_alt,
                                                              color: kWhiteColor,
                                                            ),
                                                          ),
                                                        )),
                                                    Expanded(
                                                        child: FittedBox(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                              left: 10.w,
                                                              right: 10.w,
                                                            ),
                                                            child: Text(
                                                              "Change Picture",
                                                              style: kPoppinsRegular400
                                                                  .copyWith(
                                                                  fontSize: 18.sp,
                                                                  letterSpacing: 1,
                                                                  color:
                                                                  kWhiteColor),
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                              : const SizedBox();
                                        }),
                                  ],
                                )),
                          )),

                      ///
                      ///this expanded is for the half lower part
                      ///
                      vm.isEditButtonClicked==true
                          ? Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 30.w),
                          child: Column(
                            children: [
                              ///
                              /// Full name textfield
                              Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            color: kPrimaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(10.r)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.r),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: FittedBox(
                                                fit:BoxFit.scaleDown,
                                                child: Text(
                                                  "Full Name : ",
                                                  style: kPoppinsMedium500.copyWith(
                                                      fontSize: 24.sp
                                                  ),
                                                ),
                                              )),
                                          SizedBox(width: 10.w,),
                                          Expanded(
                                              flex:2,
                                              child: Align(
                                                alignment:Alignment.centerLeft,
                                                child: FittedBox(
                                                    fit:BoxFit.scaleDown,
                                                    child: SizedBox(
                                                      width: 250.w,
                                                      child:  TextField(
                                                        controller: fullNameController,
                                                        onChanged: (value)
                                                        {
                                                            vm.setFullNameValue=value;
                                                        },
                                                        decoration: const InputDecoration(
                                                            hintText: "Enter Your Full Name",
                                                            border: InputBorder.none
                                                        ),
                                                      ),
                                                    )
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 40.h,
                              ),
                              ///
                              /// Occupation textfield
                              Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            color: kPrimaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(10.r)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.r),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: FittedBox(
                                                fit:BoxFit.scaleDown,
                                                child: Text(
                                                  "Occupation : ",
                                                  style: kPoppinsMedium500.copyWith(
                                                      fontSize: 24.sp
                                                  ),
                                                ),
                                              )),
                                          SizedBox(width: 10.w,),
                                          Expanded(
                                              flex:2,
                                              child: Align(
                                                alignment:Alignment.centerLeft,
                                                child: FittedBox(
                                                    fit:BoxFit.scaleDown,
                                                    child: SizedBox(
                                                      width: 250.w,
                                                      child:  TextField(
                                                        controller: occupationController,
                                                        onChanged: (value)
                                                        {
                                                            vm.setOccupationValue=value;
                                                        },
                                                        decoration: const InputDecoration(
                                                            hintText: "App Dev/Web Dev/Lecturer",
                                                            border: InputBorder.none,

                                                        ),
                                                      ),
                                                    )
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  )),
                              Expanded(child: SizedBox()),
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 50.h,
                                          width: 100.w,
                                          child: TextButton(
                                            onPressed: () async{
                                              vm.setIsEditButtonClicked=false;
                                              await vm.getUserData();
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all(
                                                  kPrimaryColor),
                                            ),
                                            child: FittedBox(
                                              child: Text(
                                                "Back",
                                                style:
                                                kPoppinsMedium500.copyWith(
                                                    color: kWhiteColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 50.h,
                                          width: 100.w,
                                          child: TextButton(
                                            onPressed: () async{
                                              // vm.setIsEditButtonClicked=false;
                                              // await vm.getUserData();
                                              // NavigationService().navigatePush(context, ChangePasswordScreen());
                                              Navigator.pushReplacement(context, PageTransition(
                                                  duration: Duration(milliseconds: 500),
                                                  type: PageTransitionType.leftToRightWithFade, child: ChangePasswordScreen(
                                              )));
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all(
                                                  kPrimaryColor),
                                            ),
                                            child: FittedBox(
                                              child: Text(
                                                "Change Password",
                                                style:
                                                kPoppinsMedium500.copyWith(
                                                    color: kWhiteColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      )
                          : Expanded(
                          child: Column(
                            children: [
                              Expanded(flex: 1, child: SizedBox()),

                              ///
                              /// the listview
                              ///
                              Expanded(
                                  flex: 1,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: vm.listOfIdeas!.length,
                                      itemBuilder: (context, index) {
                                        return vm.listOfIdeas!.isEmpty?
                                            const Center(
                                              child: Text("Your ideas will appear here"),
                                            )
                                            : ListItem(vm.listOfIdeas![index]);
                                      })),

                              ///
                              /// Sign out button
                              ///
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: 50.h,
                                        width: 100.w,
                                        child: TextButton(
                                          onPressed: () {
                                            Provider.of<TeacherDrawerScreenVM>(
                                                context,
                                                listen: false)
                                                .signOut(context);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all(
                                                kPrimaryColor),
                                          ),
                                          child: FittedBox(
                                            child: Text(
                                              "Sign Out",
                                              style:
                                              kPoppinsMedium500.copyWith(
                                                  color: kWhiteColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],)),
                            ],
                          ))

                      ],
                    ),
                    // Center Card
                    ///
                    /// For the centered card
                    vm.isEditButtonClicked
                        ? const SizedBox()
                        : Positioned(
                      left: 0.057.sw,
                      top: 160.h,
                      child: SizedBox(
                        height: 164.h,
                        width: 346.w,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 19.h, horizontal: 40.w),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    child: FittedBox(

                                      child: Text(
                                        vm.signupModel?.fullName??"",
                                        maxLines: 1,
                                        style: kPoppinsMedium500.copyWith(
                                          fontSize: 32.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: FittedBox(
                                      child: SizedBox(
                                        width: 335.w,
                                        child: Center(
                                          child: Text(
                                            vm.signupModel?.occupation??"",
                                           maxLines: 1, style: kPoppinsExtraLight200.copyWith(
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    "ID:  ",
                                                    style: kPoppinsMedium500
                                                        .copyWith(fontSize: 15.sp),
                                                  )),
                                            )),
                                        const Expanded(
                                          child: SizedBox(),
                                        ),
                                        Expanded(
                                            flex: 4,
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: FittedBox(
                                                    child: SizedBox(
                                                      width: 180.w,
                                                      child: Text(
                                                       vm.signupModel?.universityId??"",
                                                        maxLines: 1,
                                                        style:
                                                        kPoppinsLight300.copyWith(
                                                            fontSize: 15.sp,
                                                            letterSpacing: 1.5),
                                                      ),
                                                    ))))
                                      ],
                                    )),
                                Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: FittedBox(
                                                    child: Text(
                                                      "Email:  ",
                                                      style: kPoppinsMedium500
                                                          .copyWith(fontSize: 15.sp),
                                                    )))),
                                        const Expanded(
                                          child: SizedBox(),
                                        ),
                                        Expanded(
                                            flex: 4,
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: FittedBox(
                                                    child: SizedBox(
                                                      width: 180.w,
                                                      child: Text(
                                                        vm.signupModel?.email??"",
                                                        maxLines: 1,
                                                        style: kPoppinsLight300
                                                            .copyWith(fontSize: 15.sp),
                                                      ),
                                                    ))))
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                    top: 30.h,
                    right: 1.w,
                    child: TextButton(
                      onPressed: () async{
                            if(vm.isEditButtonClicked == false)
                              {
                                vm.setIsEditButtonClicked=true;
                              }
                            else
                              {
                                 if(fullNameController.text.isEmpty || occupationController.text.isEmpty)
                                   {
                                     BotToast.showText(text: "TextField can't be empty");
                                   }
                                 else
                                   {
                                        await vm.saveEditedProfile(fullNameController.text,
                                            occupationController.text).then((value){
                                              vm.setIsEditButtonClicked=false;
                                        });
                                   }
                              }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(kPrimaryColor),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15))))),
                      child: Center(
                        child: FittedBox(child: vm.isEditButtonClicked
                            ? Text(
                          "Save Profile",
                          style: kPoppinsLight300.copyWith(
                              color: kWhiteColor, fontSize: 16.sp),
                        )
                            : Text(
                          "Edit Profile",
                          style: kPoppinsLight300.copyWith(
                              color: kWhiteColor, fontSize: 16.sp),
                        )
                        ),
                      ),
                    ))
                ],
              ),
            )
                    )
        ),
              ),
            );


      },
    );
  }
  );
}
}

