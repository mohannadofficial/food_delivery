import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/small_text.dart';

class IconText extends StatelessWidget {
  final String name;
  final double size;
  final IconData icon;
  final Color color;
  const IconText({Key? key,
    required this.name,
    this.size = 0,
    required this.icon,
    required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
      [
        Icon(
          icon,
          color: color,
          size: size == 0 ? 20.sp : size,
        ),
        const SizedBox(width: 5.0,),
        SmallText(
          name: name,
        ),
      ],
    );
  }
}
