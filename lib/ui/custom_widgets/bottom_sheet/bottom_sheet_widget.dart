import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';

class BottomSheetWidget extends StatelessWidget {
  final Widget child;
  final String title;
  final String topButtonText;
  final void Function()? topButtonOnPress;
  final bool fullHeight;
  final Widget bottomChild;

  const BottomSheetWidget(
      {Key? key,
        this.child=const SizedBox.shrink(),
        this.title='',
        this.topButtonText='',
        this.topButtonOnPress,
        this.bottomChild=const SizedBox.shrink(),
        this.fullHeight = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height * 0.86 -
              MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: fullHeight ? MainAxisSize.max : MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: 64,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                if (title.isNotEmpty)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, topButtonText.isEmpty ? 14 : 4),
                                child: Text(
                                  title,
                                  style: kPoppinsSemiBold600
                                      .copyWith(
                                    color: kBlackColor,
                                    fontSize: 22.sp
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (topButtonText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: TextButton(
                        onPressed: topButtonOnPress,
                        child: Text(
                          topButtonText,
                          style: kPoppinsRegular400
                              .copyWith(
                              color: kPrimaryColor,
                              fontSize: 16,
                              decoration: TextDecoration.underline),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 30),
                        )),
                  ),
                fullHeight
                    ? Expanded(
                  // flex: 9,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                    child: child,
                  ),
                )
                    : Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                    child: child,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: bottomChild,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}