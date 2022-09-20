import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/empty_cart.dart';
import 'package:food_delivery/components/icon_app_pages.dart';
import 'package:food_delivery/components/small_text.dart';
import 'package:food_delivery/models/carts_model.dart';
import 'package:food_delivery/screens/pages/sub_pages/cart_food_details.dart';
import 'package:food_delivery/screens/pages/sub_pages/cart_food_history_details.dart';
import 'package:food_delivery/shared/cubit/cubit.dart';
import 'package:food_delivery/shared/cubit/states.dart';
import 'package:food_delivery/utils/app_constant.dart';

import '../components/big_text.dart';
import '../utils/colors.dart';

class CartHistoryScreen extends StatelessWidget {
  const CartHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.mainColor,
    ));
    return BlocConsumer<AppDeliveryFoodCubit, AppDeliveryFoodStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppDeliveryFoodCubit.get(context);
        int listCounter = 0;
        return Column(
          children: [
            Container(
              padding: EdgeInsetsDirectional.all(5.h),
              color: AppColors.mainColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 5.w,),
                  BigText(name: 'Your Cart History', color: Colors.white, size: 18.sp),
                  IconAppPages(icon: Icons.shopping_cart, function: (){

                  },),
                  SizedBox(width: 5.w,),
                ],
              ),
            ),
            SizedBox(height: 20.h,),
            ConditionalBuilder(
              condition: cubit.dataHistoryList.isNotEmpty && cubit.cartModelHistory.isNotEmpty,
              builder: (context) => Expanded(
                child: ListView(
                  children: [
                    for(int i =0; i<AppDeliveryFoodCubit.get(context).dataHistoryList.length; i++)
                      Container(
                        height: 150.h,
                        width: double.maxFinite,
                        margin: EdgeInsetsDirectional.only(start: 5.w ,end: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BigText(name: '${AppDeliveryFoodCubit.get(context).cartModelHistory[listCounter].time}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  direction: Axis.horizontal,
                                  children: List.generate(AppDeliveryFoodCubit.get(context).dataHistoryList[i], (index) {
                                    return index<=2?Container(
                                      height: 75.h,
                                      width: 75.h,
                                      margin: EdgeInsets.symmetric(horizontal: 2.r),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadiusDirectional.all(Radius.circular(15.r)),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                APP_URL+UPLOAD+AppDeliveryFoodCubit.get(context).cartModelHistory[listCounter++].img,
                                              ),
                                              fit: BoxFit.cover
                                          )
                                      ),
                                    ):Container();
                                  }),
                                ),
                                Container(
                                  height: 80.h,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SmallText(name: 'Total'),
                                      BigText(name: '${AppDeliveryFoodCubit.get(context).dataHistoryList[i]} items'),
                                      Container(
                                        padding: EdgeInsetsDirectional.all(5.r),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadiusDirectional.all(Radius.circular(5.r)),
                                          border: Border.all(width: 1, color: AppColors.mainColor),
                                        ),
                                        child: GestureDetector(
                                            onTap: () {
                                              int counter = -1;
                                              for (int i1 = i; i1 >= 0; i1--) {
                                                counter+=cubit.dataHistoryList[i1];
                                              }
                                              cubit.getCartHistoryDetails(cubit.cartModelHistory[counter]);
                                              print(cubit.cartModelHistory[counter].time);
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => CartHistoryDetails(),));
                                            },
                                            child: SmallText(name: 'Show Details', color: AppColors.mainColor,)
                                        ),
                                      ),],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            GestureDetector(
                              onTap: (){
                                int counterDelete = -1;
                                for (int c = i; c >= 0; c--) {
                                  counterDelete += cubit.dataHistoryList[c];
                                }
                                cubit.deleteCartHistory(cubit.cartModelHistory[counterDelete], i);
                              },
                              child: Container(
                                padding: EdgeInsetsDirectional.all(5.r),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.red),
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Colors.red,
                                ),
                                child: BigText(name: 'Remove Cart', color: Colors.white,),
                              ),
                            ),

                          ],
                        ),
                      ),
                  ],
                ),
              ),
              fallback: (context) => Expanded(
                  child:EmptyCartFood(imagePick: 'assets/image/empty_box.png', isHistory: true,)
              ),
            ),
          ],
        );
      },
    );
  }
}
