import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_scanner/providers/helper_string.dart';

Widget phoneNumberField(
    TextEditingController controller,
    String hintText,
    String? phoneError, {
      bool enabled = true,
      int maxLines = 1,
      int maxLength = 10,
      bool autoFocus = false,
      TextInputAction action = TextInputAction.done,
    }) {
  return TextField(
    enabled: enabled,
    controller: controller,
    keyboardType: TextInputType.phone,
    maxLines: maxLines,
    maxLength: maxLength,
    textInputAction: action,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    autofocus: autoFocus,
    decoration: InputDecoration(
        hintText: hintText,
        errorText: phoneError,
        contentPadding: EdgeInsets.zero,
        counter: const SizedBox.shrink(),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        hintStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: HelperString.poppinsRegular),
        prefixIcon: const Icon(
          Icons.phone,
          color: Colors.blue,
        ),
        border: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(30)))),
  );
}

Widget otpField(
    TextEditingController controller,
    String hintText,
    String? phoneError, {
      bool enabled = true,
      int maxLines = 1,
      int maxLength = 6,
      bool autoFocus = false,
      TextInputAction action = TextInputAction.done,
    }) {
  return TextField(
    enabled: enabled,
    controller: controller,
    keyboardType: TextInputType.phone,
    maxLines: maxLines,
    textAlign: TextAlign.center,
    maxLength: maxLength,
    textInputAction: action,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    autofocus: autoFocus,
    decoration: InputDecoration(
        hintText: hintText,
        errorText: phoneError,
        contentPadding: EdgeInsets.zero,
        counter: const SizedBox.shrink(),
        focusedBorder: const OutlineInputBorder(

            borderSide: BorderSide(
                color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        hintStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: HelperString.poppinsRegular),

        border: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(30)))),
  );
}