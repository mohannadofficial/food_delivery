import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconAppPages extends StatelessWidget {
  final IconData icon;
  final Color backGroundColor;
  final double size;
  final double sizeIcon;
  final Color color;
  final VoidCallback? function;
  const IconAppPages({Key? key, required this.icon, this.backGroundColor = const Color(0xFFfcf4e4), this.size = 35, this.color = const Color(0xFF756d54),  this.function, this.sizeIcon = 16}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size == 35 ? 35.h : size,
      width: size == 35 ? 35.h : size,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(size)),
        color: backGroundColor,
      ),
      child: IconButton(
        onPressed: function,
        icon: Icon(
          icon,
          size: size==16?16.h:sizeIcon,
          color: color,
        ),
      ),
    );
  }
}
