import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';


class CustomMultiselectDropDown extends StatefulWidget {
  final Function(List<String>) selectedList;

  // final List<String> listOFStrings;
  final List<UserSignupModel> userModelList;
  final int limit;
  final String labelText;

   CustomMultiselectDropDown(
      {required this.selectedList,
      required this.userModelList,
      required this.limit,
      required this.labelText});

  @override
  createState() {
    return _CustomMultiselectDropDownState();
  }
}

class _CustomMultiselectDropDownState extends State<CustomMultiselectDropDown> {
  List<String> listOfStudentsUIDs = [];
  String selectedText = "";
  List<String> listOFSelectedItem = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
      child: ExpansionTile(
        iconColor: Colors.grey,
        title:
            Text(listOFSelectedItem.isEmpty ? widget.labelText : listOFSelectedItem[0],
                style: kPoppinsRegular400.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0,
                )),
        children: <Widget>[
          ListView.builder(
            //physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.userModelList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: _ViewItem(
                    item: widget.userModelList[index].fullName ?? "",
                    selected: (val) {
                      ///user should check mark only to the limit
                      ///OR
                      ///user should uncheck only those which are already checked
                      if (listOFSelectedItem.length <= widget.limit-1 ||
                          listOFSelectedItem.contains(
                              widget.userModelList[index].fullName)==true) {
                        selectedText = val;

                        if (listOFSelectedItem.contains(val)) {
                          listOFSelectedItem.remove(val);
                          listOfStudentsUIDs
                              .remove(widget.userModelList[index].uid ?? "");
                        } else {
                          listOFSelectedItem.add(val);
                          listOfStudentsUIDs
                              .add(widget.userModelList[index].uid ?? "");
                        }
                        //widget.selectedList(listOFSelectedItem);

                        widget.selectedList(listOfStudentsUIDs);
                        setState(() {});
                      }
                    },
                    itemSelected: listOFSelectedItem.contains(
                                widget.userModelList[index].fullName) ==
                            false
                        ? false
                        : listOFSelectedItem.length <= widget.limit
                            ? true
                            : false),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ViewItem extends StatelessWidget {
  String item;
  bool itemSelected;
  final Function(String) selected;

  _ViewItem(
      {required this.item, required this.itemSelected, required this.selected});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * .032, right: size.width * .098),
      child: Row(
        children: [
          SizedBox(
            height: 24.0,
            width: 24.0,
            child: Checkbox(
              value: itemSelected,
              onChanged: (val) {
                selected(item);
              },
              activeColor: Colors.blue,
            ),
          ),
          SizedBox(
            width: size.width * .025,
          ),
          Text(item,
              style: kPoppinsRegular400.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 17.0,
              )),
        ],
      ),
    );
  }
}
