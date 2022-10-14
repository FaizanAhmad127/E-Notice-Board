import 'package:flutter/material.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/ui/custom_widgets/login_register_button/login_register_button.dart';

class FormSubmitButtonsWidget extends StatelessWidget {
  final String confirmButtonText;
  final String dangerButtonText;
  final void Function()? confirmButtonOnPress;
  final void Function() ?dangerButtonOnPress;
  final Color dangerButtonColor;

  FormSubmitButtonsWidget(
      {this.confirmButtonText='',
        this.confirmButtonOnPress,
        this.dangerButtonText='Cancel',
        this.dangerButtonOnPress,
        this.dangerButtonColor = Colors.red});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (confirmButtonText.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
                top: 24, bottom: dangerButtonText.isEmpty ? 0 : 8),
            child: LoginRegisterButton(
              onPressed: confirmButtonOnPress,
              buttonText: confirmButtonText,
            ),
          ),
        if (dangerButtonText.isNotEmpty)
          Padding(
              padding: EdgeInsets.only(
                  top: confirmButtonText.isEmpty ? 24 : 0, bottom: 0),
              child: TextButton(
                onPressed: dangerButtonOnPress??()=>Navigator.pop(context),
                child: Text(dangerButtonText,style: kPoppinsRegular400.copyWith( color: dangerButtonColor),),
              ))
      ],
    );
  }
}
