
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';

import 'package:flutter/material.dart';

class RadioListTileWidget<T> extends StatelessWidget {
  const RadioListTileWidget({
    Key? key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label='',
    this.child,
  }) : super(key: key);

  final T value;
  final T groupValue;
  final String label;
  final Widget? child;
  final Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          unselectedWidgetColor: const Color(0xFFCCCCCC),
        ),
        child: Container(
            decoration: BoxDecoration(
                color: groupValue == value ? Color(0xFFF8F8F8) : null,
                borderRadius: BorderRadius.circular(4)),
            child: RadioListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 3),
                dense: true,
                visualDensity: VisualDensity.compact,
                activeColor: kAcceptedColor,
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                title: Transform.translate(
                  offset: const Offset(-10, 0),
                  child: child ?? Text(label,
                      style: kPoppinsMedium500
                          .copyWith(
                          color: groupValue == value
                              ? kAcceptedColor
                              : Colors.black)),
                ))));
  }
}
