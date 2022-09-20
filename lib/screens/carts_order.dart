import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/models/place_order_model.dart';
import 'package:food_delivery/shared/cubit/cubit.dart';
import 'package:food_delivery/shared/cubit/states.dart';
import 'package:food_delivery/utils/colors.dart';

import '../components/empty_cart.dart';

class CartsOrderScreen extends StatelessWidget {
  const CartsOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.mainColor,
    ));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        leading: IconButton(
          onPressed: (){
            AppDeliveryFoodCubit.get(context).getIndex(0);
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: BigText(name: 'My Orders', color: Colors.white, size: 20.sp,),
      ),
      body: BlocConsumer<AppDeliveryFoodCubit, AppDeliveryFoodStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppDeliveryFoodCubit.get(context);
          if (cubit.isLogin() && cubit.placeOrderDetails.isNotEmpty){
            return ListView.builder(
              itemCount: cubit.placeOrderDetails.length,
              itemBuilder: (context, index) {
                PlaceOrderBody model = cubit.placeOrderDetails[index];
                return orderItemBuilder(model,context);
              },
              
            );
          } else {
            return const Center(
                child: EmptyCartFood(
                    imagePick: 'assets/image/empty_cart.png',
                    text: 'You don\'t have any order yet',
                    isHistory: true,
                    description: 'let\'s go buy something!',
                ),
            );
          }
        },
      ),
    );
  }

  Widget orderItemBuilder(PlaceOrderBody model,context) {
    List<String> format = model.createdTime!.split(' ');
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height/10,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0,1),
                  color: Colors.grey[200]!,
                  blurRadius: 1
              )
            ]
        ),
        margin: EdgeInsetsDirectional.only(top: 10.h, end: 5, start: 5),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BigText(name: ' Order id #${model.id}', ),
                  BigText(name: ' Date: ${format[0]} '),
                  BigText(name: ' Total: \$ ${model.orderAmount}'),
                ],
              ),
            ),
            Container(
              width:  MediaQuery.of(context).size.width/5,
              height: MediaQuery.of(context).size.height/18,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Center(child: BigText(name: 'Paid', color: Colors.white,),),
            )
          ],
        ),

      ),
    );
  }
}
