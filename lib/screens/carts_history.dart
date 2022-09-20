import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/components/small_text.dart';
import 'package:food_delivery/shared/cubit/cubit.dart';
import 'package:food_delivery/shared/cubit/states.dart';
import 'package:food_delivery/utils/app_constant.dart';
import 'package:food_delivery/utils/colors.dart';
import '../components/empty_cart.dart';
import '../models/carts_order_model.dart';

class CartsHistory extends StatelessWidget {
  const CartsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.mainColor,
    ));
    return BlocConsumer<AppDeliveryFoodCubit, AppDeliveryFoodStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppDeliveryFoodCubit.get(context);
        return Scaffold(
          //backgroundColor: Colors.grey.withOpacity(0.3),
          appBar: AppBar(
            backgroundColor: AppColors.mainColor,
            elevation: 0.0,
            leading: IconButton(
              onPressed: (){
              cubit.getIndex(0);
          }, icon: const Icon(Icons.arrow_back_ios_sharp)),
            title: BigText(name: 'Your Cart History', color: Colors.white,),
            actions:const [
               Icon(
                Icons.shopping_cart,
              ),
               SizedBox(width: 10,),
            ],
          ),
          body: ConditionalBuilder(
              condition: cubit.isLogin() && cubit.cartOrderList.isNotEmpty,
              builder: (context) {
                return ListView.builder(
                  itemCount: cubit.cartOrderList.length,
                  itemBuilder: (context, index) {

                    var model = cubit.cartOrderList[index];
                    return buildListCartHistory(context, index, model);
                  },
                );
              },
              fallback: (context) {
                return const Center(
                  child: EmptyCartFood(
                    imagePick: 'assets/image/empty_cart.png',
                    isHistory: true,
                  ),
                );
              },
          ),
        );
      },
    );
  }

  Widget buildListCartHistory(BuildContext context, int index, CartOrderModel model) {
    return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                color: Colors.grey.shade100,
                blurRadius: 1
              )
            ]
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 80.h,
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    image: DecorationImage(
                        image: NetworkImage(
                            APP_URL+UPLOAD+model.image,
                        ),
                      fit: BoxFit.cover,

                    )
                  ),
                ),
                const SizedBox(width: 10.0,),
                Expanded(
                  child: SizedBox(
                    height: 80.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BigText(name: model.name),
                        Container(
                          padding: EdgeInsetsDirectional.all(3.r),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: SmallText(
                            name: 'Confirmed',
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        BigText(name: '\$${int.parse(model.price)*int.parse(model.quantity)}', color: Colors.redAccent,),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  width: MediaQuery.of(context).size.width/10,
                  height: MediaQuery.of(context).size.height/18,
                  child: Center(child: Text(
                    model.quantity.toString(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.grey[500]
                    ),
                  ),),
                ),
              ],
            ),
          ),
        );
  }
}
