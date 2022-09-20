import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/components/small_text.dart';
import 'package:food_delivery/screens/food_page.dart';
import 'package:food_delivery/utils/colors.dart';

class MainFoodScreen extends StatelessWidget {
   const MainFoodScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return SafeArea(
      child: Column(

        children: [
          Container(
            padding: EdgeInsetsDirectional.only(start: 20.w , end: 20.w, top: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    BigText(name: 'Palestine' , color: AppColors.mainColor, size: 20.sp,),
                    Row(
                      children: [
                        SmallText(name: 'Gaza',),
                        const Icon(
                            Icons.arrow_drop_down
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 45.h,
                  width: 45.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: AppColors.mainColor,
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: SingleChildScrollView(
            child: FoodPageScreen(),
          )),
        ],
      ),
    );
  }
}
