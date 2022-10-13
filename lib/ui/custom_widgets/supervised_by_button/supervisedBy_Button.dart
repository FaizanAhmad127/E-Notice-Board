import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/ui/custom_widgets/supervised_by_button/supervisedBy_button_vm.dart';
import 'package:provider/provider.dart';
class SupervisedByButton extends StatelessWidget {
  const SupervisedByButton({
    Key? key,
    required this.uid
  }) : super(key: key);

  final String uid;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>SupervisedByButtonVM(uid),
    builder: (context,viewModel)
      {
        return Consumer<SupervisedByButtonVM>(
          builder: (context,vm,child)
          {
            return Container(
              height: 50.h,
              width: 140.w,
              decoration: BoxDecoration(
                color: kSupervisedByColor,

              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w),
                child: Column(
              children: [
                Flexible(
                  child: FittedBox(
                    child: Text(
                      "Supervised by",
                      style: kPoppinsLight300.copyWith(
                        fontSize: 12.sp,
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child:
                     Text(
                        vm.getUserName,
                        overflow: TextOverflow.ellipsis,
                        style: kPoppinsMedium500.copyWith(
                          fontSize: 15.sp,
                          color: kWhiteColor,

                        ),
                      )

                )
              ],

            ),
              ),
            );
          }

        );
      },);
  }
}

