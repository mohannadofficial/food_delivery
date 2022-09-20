import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/app_details.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/components/icon_text.dart';
import 'package:food_delivery/components/small_text.dart';
import 'package:food_delivery/screens/pages/popular_food_details.dart';
import 'package:food_delivery/screens/pages/recommended_food_details.dart';
import 'package:food_delivery/shared/cubit/cubit.dart';
import 'package:food_delivery/shared/cubit/states.dart';
import 'package:food_delivery/utils/app_constant.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import '../models/products_model.dart';

class FoodPageScreen extends StatefulWidget {
  const FoodPageScreen({Key? key}) : super(key: key);

  @override
  State<FoodPageScreen> createState() => _FoodPageScreenState();
}

class _FoodPageScreenState extends State<FoodPageScreen> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = 200.h;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController.addListener(() {
      pageController.addListener(() {
        setState(() {
          _currPageValue = pageController.page!;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppDeliveryFoodCubit, AppDeliveryFoodStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppDeliveryFoodCubit.get(context);
        Products? popularModel = cubit.popularModel;
        Products? recommendedModel = cubit.recommendedModel;
        return ConditionalBuilder(
          condition: popularModel != null && recommendedModel != null,
          builder: (context) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(top: 30.h),
                  height: 275.h,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: popularModel!.products.length,
                    itemBuilder: (context, index) {
                      return _buildPageItem(
                          index, popularModel.products[index]);
                    },
                  ),
                ),
                DotsIndicator(
                  dotsCount: popularModel.products.length,
                  position: _currPageValue,
                  decorator: DotsDecorator(
                    activeColor: AppColors.mainColor,
                    size: const Size.square(9.0),
                    activeSize: Size(18.w, 9.h),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r)),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(start: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BigText(name: 'Recommended'),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: 5.w,
                          end: 5.w,
                        ),
                        child: BigText(
                          name: '.',
                          color: Colors.black26,
                          size: 30.sp,
                        ),
                      ),
                      SmallText(name: 'Food pairing')
                    ],
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsetsDirectional.only(top: 30.h, start: 10.w),
                  primary: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recommendedModel!.products.length,
                  itemBuilder: (context, index) {
                    return buildRecommendedFood(
                        context, recommendedModel, index);
                  },
                ),
              ],
            );
          },
          fallback: (context) => Center(
            child: CircularProgressIndicator(
              color: AppColors.mainColor,
            ),
          ),
        );
      },
    );
  }

  //Build PageItem
  Widget _buildPageItem(int index, ProductsModel? model) {
    Matrix4 matrix = Matrix4.identity();

    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 0);
    }

    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PopularFoodDetails(model),
            ));
      },
      child: Transform(
        transform: matrix,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(
                start: 10.w,
                end: 10.w,
              ),
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  30.r,
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(APP_URL + UPLOAD + model!.img),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: 30.w, end: 30.w, bottom: 20.h),
                height: 120.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20.r,
                  ),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(0, 5),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(5, 0),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5, 0),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsetsDirectional.only(
                    top: 20.h,
                    start: 20.w,
                    end: 20.w,
                  ),
                  child: AppDetails(name: model.name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //Build RecommendedItem
  Widget buildRecommendedFood(BuildContext context, Products recommendedModel, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RecommendedFoodDetails(recommendedModel.products[index]),
            ));
      },
      child: Row(
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(
              bottom: 10.h,
              start: 10.w,
            ),
            height: 105.h,
            width: 105.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                20.r,
              ),
              color: Colors.white38,
              image: DecorationImage(
                image: NetworkImage(
                  APP_URL + UPLOAD + recommendedModel.products[index].img,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsetsDirectional.only(end: 10.w, bottom: 10.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(20.r),
                    topEnd: Radius.circular(20.r),
                  ),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 10.w, bottom: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    BigText(name: recommendedModel.products[index].name),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      recommendedModel.products[index].description,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12.sp,
                          color: AppColors.textColor),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconText(
                            name: 'Normal',
                            icon: Icons.circle_sharp,
                            color: AppColors.iconColor1),
                        IconText(
                            name: '17km',
                            icon: Icons.location_on_sharp,
                            color: AppColors.mainColor),
                        IconText(
                            name: '32min',
                            icon: Icons.watch_later_outlined,
                            color: AppColors.iconColor2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
