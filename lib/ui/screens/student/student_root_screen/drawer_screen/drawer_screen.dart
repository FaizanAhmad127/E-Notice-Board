import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/strings.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/drawer_screen/drawer_screen_vm.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/drawer_screen/list_item.dart';
import 'package:notice_board/ui/screens/student/student_root_screen/student_root_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/cache_image_service.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DrawerScreenVM(),
      builder: (context, viewModel) {
        return SizedBox(
          width: 0.95.sw,
          child: Drawer(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
              side: BorderSide(color: kPrimaryColor, width: 3),
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
                              FittedBox(
                                fit: BoxFit.fill,
                                child: CacheImageService()
                                    .loadCacheImage(noImageUrl),
                              ),
                              Consumer<DrawerScreenVM>(
                                  builder: (context, vm, child) {
                                return vm.isEditButtonClicked
                                    ? Positioned(
                                        bottom: 80.h,
                                        // left: 10.w,
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
                                          child: GestureDetector(
                                            onTap: () {},
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
                    Consumer<DrawerScreenVM>(
                      builder: (context, vm, child) {
                        return vm.isEditButtonClicked
                            ? Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 30.w),
                            child: Column(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Expanded(
                                        child: FittedBox(
                                          fit:BoxFit.scaleDown,
                                      child: Text(
                                        "Full Name",
                                        style: kPoppinsMedium500.copyWith(
                                          fontSize: 24.sp
                                        ),
                                      ),
                                    )),
                                    SizedBox(width: 10.w,),
                                    Expanded(
                                      flex:3,
                                        child: Align(
                                          alignment:Alignment.centerLeft,
                                          child: FittedBox(
                                            fit:BoxFit.scaleDown,
                                      child: SizedBox(
                                          width: 250.w,
                                          child: TextField(
                                            decoration: InputDecoration(
                                                hintText: "Enter your name",
                                              border: InputBorder.none
                                            ),
                                          ),
                                      )
                                    ),
                                        ))
                                  ],
                                ))
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
                                          itemCount: 5,
                                          itemBuilder: (context, index) {
                                            return const ListItem();
                                          })),

                                  ///
                                  /// Sign out button
                                  ///
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 50.h,
                                          width: 100.w,
                                          child: TextButton(
                                            onPressed: () {
                                              Provider.of<DrawerScreenVM>(
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
                                      ))
                                ],
                              ));
                      },
                    )
                  ],
                ),
                // Center Card
                ///
                /// For the centered card
                Consumer<DrawerScreenVM>(builder: (context, vm, child) {
                  return vm.isEditButtonClicked
                      ? SizedBox()
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
                                  child: FittedBox(
                                    child: Text(
                                      "Sana Ali Khan ",
                                      style: kPoppinsMedium500.copyWith(
                                        fontSize: 32.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: FittedBox(
                                  child: Text(
                                    "App Development in Flutter",
                                    style: kPoppinsExtraLight200.copyWith(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                )),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Expanded(
                                    child: Align(
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
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                      Expanded(
                                          flex: 4,
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: FittedBox(
                                                  child: Text(
                                                "32649273929",
                                                style:
                                                    kPoppinsLight300.copyWith(
                                                        fontSize: 15.sp,
                                                        letterSpacing: 1.5),
                                              ))))
                                    ],
                                  ),
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
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: FittedBox(
                                                child: Text(
                                              "SanaAliKhan@gmail.com",
                                              style: kPoppinsLight300
                                                  .copyWith(fontSize: 15.sp),
                                            ))))
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                          ),
                      );
                }),

                Positioned(
                    top: 30.h,
                    right: 1.w,
                    child: TextButton(
                      onPressed: () {
                        Provider.of<DrawerScreenVM>(context, listen: false)
                            .setIsEditButtonClicked = true;
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15))))),
                      child: Center(
                        child: FittedBox(child: Consumer<DrawerScreenVM>(
                          builder: (context, vm, child) {
                            return vm.isEditButtonClicked
                                ? Text(
                                    "Save Profile",
                                    style: kPoppinsLight300.copyWith(
                                        color: kWhiteColor, fontSize: 16.sp),
                                  )
                                : Text(
                                    "Edit Profile",
                                    style: kPoppinsLight300.copyWith(
                                        color: kWhiteColor, fontSize: 16.sp),
                                  );
                          },
                        )),
                      ),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
