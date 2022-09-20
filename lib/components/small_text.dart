import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallText extends StatelessWidget {
   final String name;
   double size;
   Color color;
   double height;

    SmallText({
    Key? key,
    required this.name,
    this.size = 0,
    this.height= 0,
    this.color = const Color(0xFFccc7c5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: size == 0 ? 12.sp : size,
        color: color,
        height: height == 0 ? 0 : height,
      ),
      maxLines: 1,
    );
  }
}
