import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/components/icon_app_pages.dart';
import 'package:food_delivery/components/small_text.dart';
import 'package:food_delivery/models/carts_model.dart';
import 'package:food_delivery/shared/cubit/cubit.dart';
import 'package:food_delivery/utils/app_constant.dart';
import 'package:food_delivery/utils/colors.dart';

class CartHistoryDetails extends StatelessWidget {
  const CartHistoryDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppDeliveryFoodCubit.get(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.mainColor,
                padding: EdgeInsetsDirectional.all(10.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconAppPages(icon: Icons.arrow_back_ios_sharp, color: Colors.white, backGroundColor: AppColors.mainColor, function: () {
                      Navigator.pop(context);
                    },),
                    SizedBox(width: 10.h,),
                    BigText(
                      name: 'Cart Details',
                      color: Colors.white,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cubit.cartHistoryDetails.length,
                  itemBuilder: (context, index) {
                    var model = cubit.cartHistoryDetails[index];
                    return buildCartDetails(index,model);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
          [
            Container(
              padding: EdgeInsetsDirectional.all(20.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(20.r)),
                  color: AppColors.mainColor
              ),
              child: Row(
                children:
                [
                  SizedBox(width: 5.w,),
                  BigText(name: '\$ ${cubit.totalAmountDetails}', color: Colors.white,),
                  SizedBox(width: 5.w,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildCartDetails(int index, CartsModel model) {
    return Container(
      margin: EdgeInsetsDirectional.all(10.r),
      child: Row(
        children: [
          Container(
            height: 100.h,
            width: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              image: DecorationImage(
                image: NetworkImage(
                  APP_URL+UPLOAD+model.img
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 100.h,
              margin: EdgeInsetsDirectional.all(10.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BigText(name: model.name),
                  SmallText(name: 'Spicy'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(
                        name: '\$ ${model.price}',
                        color: Colors.red,
                      ),
                      Container(
                        padding:
                            EdgeInsetsDirectional.only(start: 15.r, end: 15.r),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColors.mainColor,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.r)),
                            color: AppColors.mainColor),
                        child: BigText(
                          name: model.quantity.toString(),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
