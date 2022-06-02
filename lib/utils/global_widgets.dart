// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_haul/utils/extension.dart';

Widget text(
  String text, {
  var fontWeight = FontWeight.w800,
  var fontSize = textSizeLargeMedium,
  Color textColor = AppColors.textColor,
  var fontFamily = "Rubik",
  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.5,
  bool textAllCaps = false,
  var isLongText = false,
  bool lineThrough = false,
}) {
  return Text(
    textAllCaps ? text.toUpperCase() : text,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration: lineThrough ? TextDecoration.underline : TextDecoration.none,
    ),
  );
}

BoxDecoration boxDecoration(
    {double radius = 2,
    blurRadius = 10.0,
    borderWidth = 1.5,
    Offset offset = const Offset(2.0, 2.0),
    Color bordercolor = Colors.transparent,
    Color fillcolor = AppColors.white,
    shadowColor,
    var showShadow = false}) {
  return BoxDecoration(
    color: fillcolor,
    boxShadow: showShadow
        ? [
            BoxShadow(
                color: shadowColor.withOpacity(0.4),
                blurRadius: blurRadius,
                offset: offset)
          ]
        : [BoxShadow(color: Colors.transparent)],
    border: Border.all(
      color: bordercolor,
      width: borderWidth,
    ),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

Widget loadingWidget() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

Widget textInputContainer(
    {double rad = 8,
    TextInputType inputType = TextInputType.text,
    TextEditingController? textEditingController,
    String? label,
    hint,
    bool obscure = false,
    bool shadow = false,
    double width = double.infinity,
    required String? Function(dynamic value) validator,
    bool suffix = false}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    width: width,
    decoration: boxDecoration(
      radius: rad,
      showShadow: shadow,
      fillcolor: AppColors.white,
    ),
    child: TextFormField(
      keyboardType: inputType,
      autofocus: false,
      obscureText: obscure,
      controller: textEditingController,
      style: const TextStyle(
        color: AppColors.textColor,
        fontFamily: "Rubik",
        fontWeight: FontWeight.w900,
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.white,
          hintText: hint,
          hintStyle: TextStyle(
              color: AppColors.textColor.withOpacity(0.38),
              fontFamily: "Rubik",
              fontSize: textSizeMedium,
              fontWeight: FontWeight.w600),
          labelStyle: TextStyle(
              color: AppColors.textColor.withOpacity(0.6),
              fontFamily: "Rubik",
              fontSize: textSizeSMedium,
              fontWeight: FontWeight.w600),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(rad),
              borderSide: BorderSide(
                  color: AppColors.textColor,
                  style: BorderStyle.solid,
                  width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(rad),
              borderSide: BorderSide(
                  color: AppColors.textColor,
                  width: 1.5,
                  style: BorderStyle.solid)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(rad),
              borderSide: BorderSide(
                  color: AppColors.textColor.withOpacity(0.38),
                  style: BorderStyle.solid,
                  width: 1.5))),
    ),
  );
}

Widget textInputContainerforMobile({
  double rad = 8,
  marginValue = 0.0,
  TextEditingController? textEditingController,
  String? label,
  hint,
  bool obscure = false,
  Color iconColor = AppColors.textColor,
  bool shadow = true,
  //Function? validator
}) {
  return Container(
    margin: EdgeInsets.only(left: marginValue, right: marginValue),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(rad)),
    ),
    child: TextFormField(
      maxLength: 10,
      //validator: validator,
      cursorColor: AppColors.textColor.withOpacity(0.4),
      keyboardType: TextInputType.number,
      autofocus: false,
      obscureText: obscure,
      controller: textEditingController,
      style: const TextStyle(
        color: AppColors.textColor,
        fontFamily: "Rubik",
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        fontSize: textSizeMedium,
      ),
      decoration: InputDecoration(
          counter: Container(),
          filled: true,
          fillColor: AppColors.background,
          hintText: hint,
          hintStyle: TextStyle(
              color: AppColors.textColor.withOpacity(0.38),
              fontFamily: "Rubik",
              fontSize: textSizeMedium,
              fontWeight: FontWeight.w500),
          prefixIcon: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: text(" +91  | ",
                  textColor: AppColors.textColor,
                  fontSize: textSizeMedium,
                  fontWeight: FontWeight.w600)),
          contentPadding: const EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(rad),
              borderSide: BorderSide(
                  color: AppColors.textColor,
                  style: BorderStyle.solid,
                  width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(rad),
              borderSide: BorderSide(
                  color: AppColors.textColor,
                  width: 1.5,
                  style: BorderStyle.solid)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(rad),
              borderSide: BorderSide(
                  color: AppColors.textColor,
                  style: BorderStyle.solid,
                  width: 1.5))),
    ),
  );
}
