import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/small_text.dart';
import 'package:food_delivery/layout/food_delivery.dart';

import '../utils/colors.dart';

class EmptyCartFood extends StatelessWidget {
  final String imagePick;
  final String text;
  final String description;
  final bool isHistory;


  const EmptyCartFood(
      {Key? key, required this.imagePick, this.text = 'Your cart is empty', this.isHistory = false, this.description = 'You have no item in your shopping cart.'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: MediaQuery.of(context).size.height*0.30,
            image: AssetImage(
              imagePick
            ),
            fit: BoxFit.cover,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h,),
          SmallText(name: description),
          if (!isHistory)
            SmallText(name: 'Let\'s go buy something!'),
          if (!isHistory)
            SizedBox(height: 30.h,),
          if (!isHistory)
            GestureDetector(
            onTap: (){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const FoodDeliveryLayout()), (route) => false);
            },
            child: Container(
              padding: EdgeInsetsDirectional.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadiusDirectional.circular(20.r),
              ),
              child: Text(
                'Shop Now',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
