import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BigText extends StatelessWidget {
   final String name;
   double size;
   Color color;

    BigText({
    Key? key,
    required this.name,
    this.size = 0,
    this.color = const Color(0xFF332d2b),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: size == 0 ? 18.sp : size,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
