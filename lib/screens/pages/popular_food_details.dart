import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/app_details.dart';
import 'package:food_delivery/components/expandable_textview.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:food_delivery/screens/pages/sub_pages/cart_food_details.dart';
import 'package:food_delivery/shared/cubit/cubit.dart';
import 'package:food_delivery/shared/cubit/states.dart';
import 'package:food_delivery/utils/app_constant.dart';
import 'package:food_delivery/utils/app_dimensions.dart';
import '../../components/big_text.dart';
import '../../components/icon_app_pages.dart';
import '../../utils/colors.dart';

class PopularFoodDetails extends StatelessWidget {
  ProductsModel model;

  PopularFoodDetails(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    AppDeliveryFoodCubit.get(context).initProduct(model);
    return BlocConsumer<AppDeliveryFoodCubit, AppDeliveryFoodStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned(
                left: 0.0.w,
                right: 0.0.w,
                child: Container(
                  width: double.infinity,
                  height: 250.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(
                      APP_URL + UPLOAD + model.img,
                    ),
                    fit: BoxFit.cover,
                  )),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsetsDirectional.only(top: 30.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconAppPages(
                        icon: Icons.arrow_back_ios_sharp,
                        function: () {
                          Navigator.pop(context);
                        },
                      ),
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          IconAppPages(
                            icon: Icons.shopping_cart_outlined,
                            function: () {
                                AppDeliveryFoodCubit.get(context)
                                    .getAllCartItem();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CartFoodDetails(),
                                    ));
                            },
                          ),
                          if (AppDeliveryFoodCubit.get(context)
                                  .quantityCartShop >=
                              1)
                            CircleAvatar(
                              radius: 9.r,
                              backgroundColor: AppColors.mainColor,
                              child: BigText(
                                name: AppDeliveryFoodCubit.get(context)
                                    .quantityCartShop
                                    .toString(),
                                color: Colors.white,
                                size: 10.sp,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 240.h,
                child: Container(
                  height: 700,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(15.r),
                      topEnd: Radius.circular(15.r),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0.0.w,
                right: 0.0.h,
                top: 255.h,
                child: Container(
                    height: 350.h,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppDetails(name: model.name, size: 22.sp),
                        SizedBox(
                          height: 20.h,
                        ),
                        BigText(name: 'Introduce'),
                        SizedBox(
                          height: 20.h,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                                child: ExpandableText(
                          text: model.description,
                          size: 14.sp,
                        ))),
                        SizedBox(
                          height: AppDimensions.defaultSize * 6,
                        )
                      ],
                    )),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            height: 100.h,
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadiusDirectional.all(Radius.circular(30.h)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsetsDirectional.all(20.h),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadiusDirectional.all(Radius.circular(20.r)),
                      color: AppColors.buttonBackgroundColor),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          AppDeliveryFoodCubit.get(context).cartQuantity(false);
                        },
                        child: Icon(
                          Icons.remove,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      BigText(
                          name: AppDeliveryFoodCubit.get(context)
                              .inCartItem
                              .toString()),
                      SizedBox(
                        width: 5.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          AppDeliveryFoodCubit.get(context).cartQuantity(true);
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AppDeliveryFoodCubit.get(context).addCartItem(model,
                        AppDeliveryFoodCubit.get(context).inCartItem, context);
                  },
                  child: Container(
                    padding: EdgeInsetsDirectional.all(20.h),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadiusDirectional.all(Radius.circular(20.r)),
                        color: AppColors.mainColor),
                    child: BigText(
                      name: '\$ ${model.price} Add to cart',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
