import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AppDimensions {

  static getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }


  static getScreenHeights(){
    return Get.height;
  }

  static getScreenWidth(){
    return Get.width;
  }

  // SizeIcon
  static double sizeIcon = getScreenHeights() / 156.2;
  // 5 Size Default
  static double defaultSize = getScreenHeights() / 156.2;



}