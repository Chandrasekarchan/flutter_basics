
import 'package:flutter/material.dart';
import 'package:simple_scanner/providers/helper_string.dart';
import 'package:sizer/sizer.dart';

Widget standardButton(
    Function() onPressed,
    String buttonTxt,
    ){
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      shadowColor: Colors.lightBlue,
      elevation: 10,
      minimumSize: const Size.fromHeight(50),
      // side: BorderSide(color: Colors.yellow, width: 5),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
    ),
    child: Text(
      buttonTxt,
      style: TextStyle(
        fontFamily: HelperString.poppinsRegular,
        color: Colors.white,
        fontSize: 12.sp,
      ),
    ),
  );
}