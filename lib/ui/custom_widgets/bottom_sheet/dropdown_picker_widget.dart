import 'package:flutter/material.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';

import 'package:notice_board/ui/custom_widgets/bottom_sheet/radio_listtile_widget.dart';

import 'bottom_sheet_widget.dart';
import 'form_submit_button_widget.dart';

class DropdownPickerWidget<T> extends StatelessWidget {
  final String? title;
  final T? value;
  final String placeholder;
  final void Function(T?)? onChange;
  final bool isClearable;
  final Map<String, T>? options;

  DropdownPickerWidget(
      {this.title,
        this.value,
        this.options,
        this.onChange,
        this.placeholder = '',
        this.isClearable = false});

  @override
  Widget build(BuildContext context) {
    final selectedOption = options?.entries
        .firstWhere((element) => element.value == value);
    final text = selectedOption != null ? selectedOption.key : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            title??'',
            textAlign: TextAlign.start,
            style: kPoppinsMedium500.copyWith(
              fontSize: 18
            ),
          ),
        ),
        TextFormField(
          controller: TextEditingController(text: text),
          onTap: () async{
            showBottomSheet(
                context: context,
                builder: (context) {
                  return DropdownPickerContentWidget<T>(
                    title: title??'',
                    options: options??{},
                    value: value,
                    onChanged: (value) {
                      if (value != null) {
                        if(onChange!=null)
                          {
                            onChange!(value);
                          }

                      }
                    },
                  );
                });
          },
          readOnly: true,
          style: kPoppinsMedium500,
          decoration: InputDecoration(
            suffixIcon: isClearable && value != null
                ? IconButton(
              onPressed: () {
                if(onChange !=null)
                  {
                    onChange!(null);
                  }
              },
              icon: Icon(Icons.clear,
                  color: kBlackColor),
            )
                : Icon(
              Icons.keyboard_arrow_down_sharp,
              color: kDateColor,
            ),
          ),
        )
      ],
    );
  }
}

class DropdownPickerContentWidget<T> extends StatefulWidget {
  final String title;
  final String dangerButtonText;
  final void Function()? dangerButtonOnPress;
  final Map<String, T> options;
  final T? value;
  final void Function(T)? onChanged;

  DropdownPickerContentWidget(
      {Key ?key,
        required this.title,
        this.dangerButtonText='',
        this.dangerButtonOnPress,
        this.options = const {},
        this.value,
        this.onChanged})
      : super(key: key);

  @override
  _DropdownPickerContentWidgetState<T> createState() =>
      _DropdownPickerContentWidgetState<T>();
}

class _DropdownPickerContentWidgetState<T>
    extends State<DropdownPickerContentWidget<T>> {
  late T  value;

  @override
  void initState() {
    value = widget.value as T;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: widget.title,
      child: Column(
        children: [
          ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: widget.options == null
                  ? []
                  : List.generate(widget.options.length, (index) {
                final item = widget.options.entries.elementAt(index);
                return RadioListTileWidget<T>(
                    value: item.value,
                    groupValue: value,
                    label: item.key,
                    onChanged: (val) {
                      setState(() {
                        value = val as T;
                      });
                    });
              })),
        ],
      ),
      bottomChild: FormSubmitButtonsWidget(
        confirmButtonText: 'Save',
        confirmButtonOnPress: () {
          if(widget.onChanged!=null)
            {
              widget.onChanged!(value!);
            }

          Navigator.pop(context);
        },

      ),
    );
  }
}
