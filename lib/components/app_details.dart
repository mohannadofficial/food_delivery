import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';
import 'big_text.dart';
import 'icon_text.dart';
import 'small_text.dart';

class AppDetails extends StatelessWidget {
  final String name;
  final double size;
  const AppDetails({Key? key, required this.name , this.size = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(name: name, size: size),
        SizedBox(height: 20.h),
        Row(
            children: [
              Wrap(
                children: List.generate(5, (index) => Icon(Icons.star, color: AppColors.mainColor, size: 14.sp,),),
              ),
              SizedBox(width: 10.w,),
              SmallText(name: '4.5',),
              SizedBox(width: 10.w,),
              SmallText(name: '1287'),
              SizedBox(width: 10.w,),
              SmallText(name: 'Comments',),
            ]
        ),
        SizedBox(height: 20.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
          const [
            IconText(name: 'Normal', icon: Icons.circle_sharp, color: AppColors.iconColor1),
            IconText(name: '1.7km', icon: Icons.location_on_sharp, color: AppColors.mainColor),
            IconText(name: '32min', icon: Icons.watch_later_outlined, color: AppColors.iconColor2),
          ],
        ),
      ],
    );
  }
}
