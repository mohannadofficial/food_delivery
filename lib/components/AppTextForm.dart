import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/utils/colors.dart';

class AppTextForm extends StatelessWidget {
  final TextEditingController controller;
  final IconData iconData;
  final String hintText;
  final TextInputType textInputType;
  IconData? afterIcon;
  bool isPassword;
  bool isreadOnly;
  VoidCallback?  functionIcon;
  AppTextForm({Key? key, required this.controller, required this.iconData, required this.hintText, required this.textInputType, this.isPassword = false , this.functionIcon, this.afterIcon, this.isreadOnly = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start:20.r, end: 20.r , top: 8.r , bottom: 8.r),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 10,
              spreadRadius: 7,
              color: Colors.grey.withOpacity(0.2),
            )
          ]
      ),
      child: TextField(
        readOnly: isreadOnly,
        controller: controller,
        keyboardType: textInputType,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(iconData, color: AppColors.mainColor,),
          suffixIcon: IconButton(onPressed: functionIcon, icon: Icon(afterIcon)),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
          ),
        ),
      ),

    );
  }
}
