import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:todo_app/ui/theme.dart';

class myInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  myInputField(
      {required this.title, required this.hint, this.controller, this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            height: 52.0,
            margin: EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      readOnly: widget == null ? false : true,
                      autofocus: false,
                      controller: controller,
                      style: subTitleStyle,
                      decoration: InputDecoration(
                        hintText: hint,
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.backgroundColor,
                                width: 0)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.backgroundColor,
                                width: 0)),
                      ),
                    ),
                  ),
                ),
                widget == null ? Container() : Container(child: widget)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// TextFormField(
// controller: controller,
// decoration: InputDecoration(
// hintText: hint,
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(10.0),
// borderSide:
// BorderSide(color: Colors.blueAccent, width: 4))),
// textAlign: TextAlign.start,
// ),
