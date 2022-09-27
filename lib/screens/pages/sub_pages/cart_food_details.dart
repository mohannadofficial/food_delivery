import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/components/empty_cart.dart';
import 'package:food_delivery/components/icon_app_pages.dart';
import 'package:food_delivery/components/small_text.dart';
import 'package:food_delivery/layout/food_delivery.dart';
import 'package:food_delivery/models/place_order_model.dart';
import 'package:food_delivery/screens/address/cubit/cubit.dart';
import 'package:food_delivery/screens/login/login_food.dart';
import 'package:food_delivery/shared/cubit/cubit.dart';
import 'package:food_delivery/shared/cubit/states.dart';
import 'package:food_delivery/utils/app_constant.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:intl/intl.dart';

import '../../address/address_food.dart';

class CartFoodDetails extends StatelessWidget {
  const CartFoodDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return BlocConsumer<AppDeliveryFoodCubit, AppDeliveryFoodStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppDeliveryFoodCubit.get(context);
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Stack(
              children: [
                // App Icon
                Positioned(
                  top: 5.h,
                  right: 20.w,
                  left: 20.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                    [
                      IconAppPages(icon: Icons.arrow_back_ios_sharp, backGroundColor: AppColors.mainColor, color: Colors.white,
                        function: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 50.w),
                      IconAppPages(icon: Icons.home, backGroundColor: AppColors.mainColor, color: Colors.white, 
                        function: (){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              const FoodDeliveryLayout()), (Route<dynamic> route) => false);
                        },
                      ),
                      const IconAppPages(icon: Icons.shopping_cart_outlined, backGroundColor: AppColors.mainColor, color: Colors.white,)
                    ],
                  ),
                ),
                // Cart Item Builder
                ConditionalBuilder(
                  condition: cubit.cartModelListItem.isNotEmpty,
                  builder: (context) {
                    return Positioned(
                      top: 50.h,
                      left: 15.h,
                      right: 15.h,
                      bottom: 0,
                      child: ListView.builder(
                        padding: EdgeInsetsDirectional.zero,
                        itemCount: cubit.cartModelListItem.length,
                        itemBuilder: (context, index) {
                          return buildCartItem(cubit, index, context);
                        },
                      ),
                    );
                  },
                  fallback: (context) {
                    return const Center(child: EmptyCartFood(imagePick: 'assets/image/empty_cart.png'));
                  },
                )
              ],
            ),
          ),
          bottomNavigationBar: ConditionalBuilder(
            condition: cubit.cartModelListItem.isNotEmpty,
            builder: (context) => Container(
              height: 100.h,
              padding: EdgeInsets.all(20.h),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadiusDirectional.all(Radius.circular(30.h)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                [
                  Container(
                    padding: EdgeInsetsDirectional.all(20.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.all(Radius.circular(20.r)),
                        color: AppColors.buttonBackgroundColor
                    ),
                    child: Row(
                      children:
                      [
                        SizedBox(width: 5.w,),
                        BigText(name: '\$ ${cubit.totalAmount}'),
                        SizedBox(width: 5.w,),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                      if(cubit.isLogin()){
                        var time = DateTime.now();
                        var formattedDate = DateFormat('MMM d, yyyy, h:mm a').format(time);
                        if(cubit.cartModelListItem.isNotEmpty){
                          cubit.cartModelListItem.forEach((e){
                            e.time = formattedDate.toString();
                          });

                        }
                        if(AddressAppCubit.get(context).addressList.isEmpty){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressFoodScreen(),));
                        } else {

                          //cubit.checkOutData();
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(),));
                          var location = AddressAppCubit.get(context).addressList.first;
                          var cart = cubit.cartModelListItem;
                          PlaceOrderBody placeOrder = PlaceOrderBody(
                              cart: cart,
                              orderAmount: 2000,
                              distance: 10.0,
                              scheduleAt: '',
                              orderNote: 'New Order from ${cubit.profileModel!.name}',
                              address: location.address,
                              latitude: location.latitude,
                              longitude: location.longitude,
                              contactPersonName: cubit.profileModel!.name,
                              contactPersonNumber: cubit.profileModel!.phone,
                          );
                          if(!cubit.isLoading) {
                            cubit.makePayment(placeOrder, context);
                          }
                        }
                      }else {
                        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarIconBrightness: Brightness.dark,
                        ));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginFoodScreen(),));
                      }

                    },
                    child: Container(
                      padding: EdgeInsetsDirectional.all(20.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.all(Radius.circular(20.r)),
                          color: AppColors.mainColor
                      ),
                      child: BigText(name: 'Check out', color: Colors.white,),
                    ),
                  ),
                ],
              ),
            ),
            fallback: (context) => Container(
              height: 0.h,
            ),
          ),
        );
      },
    );
  }

  Widget buildCartItem(AppDeliveryFoodCubit cubit, int index, BuildContext context) {


    return Container(
      margin: EdgeInsetsDirectional.all(5.r),
      child: Row(
        children: [
          Container(
            height: 100.h,
            width: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.all(Radius.circular(20.r)),
              image: DecorationImage(
                image: NetworkImage(
                    APP_URL+UPLOAD+cubit.cartModelListItem[index].img,
                  ),
                  fit: BoxFit.cover
              )
            ),
          ),
          SizedBox(width: 10.w,),
          Expanded(
            child: SizedBox(
              height: 100.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BigText(name: cubit.cartModelListItem[index].name),
                  SmallText(name: cubit.cartModelListItem[index].description),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(name: '\$ ${cubit.cartModelListItem[index].price}', color: Colors.red,),
                      Container(
                        padding: EdgeInsetsDirectional.all(8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.all(Radius.circular(20.r)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children:
                          [
                            GestureDetector(
                              onTap: () {
                                AppDeliveryFoodCubit.get(context).addCartItem(cubit.cartModelListItem[index].product, -1, context, inCart: true);
                              },
                              child: const Icon(
                                Icons.remove,
                                color:  Colors.grey,
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            BigText(name: cubit.cartModelListItem[index].quantity.toString()), // AppDeliveryFoodCubit.get(context).inCartItem.toString(),
                            SizedBox(width: 5.w,),
                            GestureDetector(
                              onTap: () {
                                AppDeliveryFoodCubit.get(context).addCartItem(cubit.cartModelListItem[index].product, 1, context, inCart: true);
                              },
                              child: const Icon(
                                Icons.add,
                                color:  Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // void _callback(bool isSuccess, String message, String orderID,context){
  //   if(isSuccess){
  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return PaymentScreen(orderModel: OrderModel(
  //         id: int.parse(orderID),
  //         userId: AppDeliveryFoodCubit.get(context).profileModel!.id!.toInt(),
  //       ));
  //     },));
  //   } else {
  //     showToast(text: message, state: selectedColor.ERROR);
  //   }
  // }

}
