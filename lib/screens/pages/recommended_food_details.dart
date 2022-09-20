import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/components/expandable_textview.dart';
import 'package:food_delivery/components/icon_app_pages.dart';
import 'package:food_delivery/components/small_text.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:food_delivery/screens/pages/sub_pages/cart_food_details.dart';
import 'package:food_delivery/shared/cubit/cubit.dart';
import 'package:food_delivery/shared/cubit/states.dart';
import 'package:food_delivery/utils/app_constant.dart';

import '../../utils/colors.dart';

class RecommendedFoodDetails extends StatelessWidget {
  ProductsModel model;
  RecommendedFoodDetails(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppDeliveryFoodCubit.get(context).initProduct(model);
    return BlocConsumer<AppDeliveryFoodCubit, AppDeliveryFoodStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppDeliveryFoodCubit.get(context);
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body:  CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                backgroundColor: AppColors.yellowColor,
                expandedHeight: 240.h,
                toolbarHeight: 35.h,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                  [
                    IconAppPages(icon: Icons.clear, function: () => Navigator.pop(context),),
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        IconAppPages(icon: Icons.shopping_cart_outlined , function: () {
                            cubit.getAllCartItem();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CartFoodDetails(),));
                        },),
                        if (AppDeliveryFoodCubit.get(context).quantityCartShop >= 1)
                          CircleAvatar(
                            radius: 9.r,
                            backgroundColor: AppColors.mainColor,
                            child: BigText(
                              name: AppDeliveryFoodCubit.get(context).quantityCartShop.toString(),
                              color: Colors.white,
                              size: 10.sp,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(15.h),
                  child: Container(
                    padding: EdgeInsetsDirectional.only(top: 5.h , bottom: 10.h),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(20.r),
                        topEnd: Radius.circular(20.r),
                      ),
                    ),
                    child: Center(child: BigText(name: model.name,size: 26.sp,),),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    APP_URL+UPLOAD+model.img,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      child: ExpandableText(text: model.description),
                      margin: EdgeInsetsDirectional.only(start: 20.r, end: 20.r),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsetsDirectional.only(
                    start: 50.r,
                    end: 50.r,
                    bottom: 10.r,
                    top: 10.r
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        cubit.cartQuantity(false);
                      },
                      child: IconAppPages(icon: Icons.remove, backGroundColor: AppColors.mainColor, size: 40.h, color: Colors.white,),
                    ),
                    BigText(name: '\$ ${model.price} '+' X '+' ${cubit.inCartItem} ', color: AppColors.mainBlackColor, size: 26.sp,),
                    GestureDetector(
                        onTap: (){
                          cubit.cartQuantity(true);
                        },
                        child: IconAppPages(icon: Icons.add, backGroundColor: AppColors.mainColor, size: 40.h, color: Colors.white,)),
                  ],
                ),
              ),
              Container(
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
                      child: Icon(
                        Icons.favorite,
                        color: AppColors.mainColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        cubit.addCartItem(model, cubit.inCartItem, context);
                      },
                      child: Container(
                        padding: EdgeInsetsDirectional.all(20.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.all(Radius.circular(20.r)),
                            color: AppColors.mainColor
                        ),
                        child: BigText(name: '\$ ${model.price} Add to cart', color: Colors.white,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
