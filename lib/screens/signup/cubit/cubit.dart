import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/layout/food_delivery.dart';
import 'package:food_delivery/models/register_model.dart';
import 'package:food_delivery/screens/signup/cubit/states.dart';
import 'package:food_delivery/shared/network/local/cache_helper.dart';
import 'package:food_delivery/shared/network/remote/dio_helper.dart';

import '../../../shared/cubit/cubit.dart';
import '../../../utils/app_constant.dart';

class SignUpFoodDeliveryCubit extends Cubit<SignUpFoodDeliveryStates> {

  SignUpFoodDeliveryCubit() : super(InitialSignUpFoodDeliveryStates());

  static SignUpFoodDeliveryCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData afterIcon = Icons.visibility_outlined;

  void changeVisibility(){
    isPassword = !isPassword;
    isPassword ? afterIcon = Icons.visibility_outlined : afterIcon = Icons.visibility_off_outlined;
    emit(PasswordSignUpFoodDeliveryStates());
  }
  
  void registerAccount({required String userName, required String password, required String email, required String phone,
    required context
    })  {
    emit(LoadingSignUpFoodDeliveryStates());
    var model = RegisterFood(userName, phone, password, email);
    DioHelper.postData(
      uri: REGISTER,
      data: model.toJson(),
    ).then((value){
      token = value.data['token'];
      AppDeliveryFoodCubit.get(context).getProfileInformation();
      CacheHelper.setData('token', token);
      emit(SuccessSignUpFoodDeliveryStates());
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const FoodDeliveryLayout(),), (route) => false);
  }).catchError((onError){
    if (kDebugMode) {
      print(onError.toString());
    }
    emit(ErrorSignUpFoodDeliveryStates());
   });
  }

}