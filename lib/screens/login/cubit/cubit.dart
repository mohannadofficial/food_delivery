import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/screens/address/cubit/cubit.dart';
import 'package:food_delivery/screens/login/cubit/states.dart';
import '../../../layout/food_delivery.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../../shared/network/remote/dio_helper.dart';
import '../../../utils/app_constant.dart';

class LoginFoodDeliveryCubit extends Cubit<LoginFoodDeliveryStates> {

  LoginFoodDeliveryCubit() : super(InitialLoginFoodDeliveryStates());

  static LoginFoodDeliveryCubit get(context) => BlocProvider.of(context);


  bool isPassword = true;
  IconData afterIcon = Icons.visibility_outlined;

  void changeVisibility(){
    isPassword = !isPassword;
    isPassword ? afterIcon = Icons.visibility_outlined : afterIcon = Icons.visibility_off_outlined;
    emit(PasswordLoginFoodDeliveryStates());
  }

  void loginAccount({required String phone , required String password , required context}){
    emit(LoadingLoginFoodDeliveryStates());
    DioHelper.postData(
      uri: LOGIN,
      data: {
        'phone':phone,
        'password':password,
      },
    ).then((value){
      token = value.data['token'];
      AppDeliveryFoodCubit.get(context).getProfileInformation();
      AddressAppCubit.get(context).getAddressData(fromMain: true);
      AppDeliveryFoodCubit.get(context).getOrderDetails();
      AppDeliveryFoodCubit.get(context).currentIndex = 0;
      print(token);
      CacheHelper.setData('token', token);
      emit(SuccessLoginFoodDeliveryStates());
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => FoodDeliveryLayout(),), (route) => false);
    }).catchError((onError){
      print(onError.toString());
      emit(ErrorLoginFoodDeliveryStates());
    });
  }


}