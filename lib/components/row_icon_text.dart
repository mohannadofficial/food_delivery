import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/components/icon_app_pages.dart';

class RowIconText extends StatelessWidget {
  final IconAppPages iconApp;
  final BigText bigText;
  const RowIconText({Key? key, required this.iconApp, required this.bigText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(
          start: 15.r,
          end: 10.r,
          top: 10.r,
          bottom: 10.r
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 10,
          )
        ]
      ),
      child: Row(
        children: [
          iconApp,
          SizedBox(width: 20.w,),
          Expanded(child: bigText,),
        ],
      ),
    );
  }
}
