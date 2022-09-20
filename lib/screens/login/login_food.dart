import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/AppTextForm.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/components/icon_app_pages.dart';
import 'package:food_delivery/components/show_custom_snackbar.dart';
import 'package:food_delivery/screens/login/cubit/cubit.dart';
import 'package:food_delivery/screens/login/cubit/states.dart';
import 'package:food_delivery/screens/signup/signup_food.dart';
import 'package:food_delivery/utils/colors.dart';

class LoginFoodScreen extends StatelessWidget {
  LoginFoodScreen({Key? key}) : super(key: key);
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    bool checkValidation(){
      if(phoneController.text.isEmpty){
        showToast(text: 'please type your phone', state: selectedColor.ERROR);
        return false;
      }
      else if(passwordController.text.isEmpty) {
        showToast(text: 'please type your password', state: selectedColor.ERROR);
        return false;
      }
      else if(passwordController.text.length < 6) {
        showToast(text: 'your password is too short', state: selectedColor.ERROR);
        return false;
      }
      // else if(!phoneController.text.contains('@')) {
      //   showToast(text: 'please enter a valid phone', state: selectedColor.ERROR);
      //   return false;
      // }
      else {
        return true;
      }
    }

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return BlocProvider(
      create: (context) => LoginFoodDeliveryCubit(),
      child: BlocConsumer<LoginFoodDeliveryCubit, LoginFoodDeliveryStates>(
        listener: (context, state) {
          if(state is ErrorLoginFoodDeliveryStates){
            showToast(text: 'phone or password is incorrect', state: selectedColor.ERROR);
          }
          if(state is SuccessLoginFoodDeliveryStates){
            showToast(text: 'Login Successfully', state: selectedColor.SUCSESS);
          }
        },
        builder: (context, state) {
          var cubit = LoginFoodDeliveryCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 20.h),
                      child: Row(
                        children: [
                          IconAppPages(
                            icon: Icons.arrow_back_ios_sharp,
                            backGroundColor: AppColors.mainColor,
                            color: Colors.white,
                            function: (){
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Image(
                        image: const AssetImage(
                          'assets/image/logo_part_1.png',
                        ),
                        height: MediaQuery.of(context).size.height*0.20,
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsetsDirectional.only(start: 20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello',
                            style: TextStyle(
                              fontSize: 56.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Sign into your account',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    AppTextForm(controller: phoneController, iconData: Icons.phone, hintText: 'Phone', textInputType: TextInputType.phone,),
                    AppTextForm(
                      controller: passwordController,
                      iconData: Icons.password,
                      hintText: 'Password',
                      textInputType: TextInputType.visiblePassword,
                      isPassword: cubit.isPassword,
                      afterIcon: cubit.afterIcon,
                      functionIcon: cubit.changeVisibility,
                    ),
                    SizedBox(height: 10.h,),
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsetsDirectional.only(end: 20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Sign into your account',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h,),
                    if(state is LoadingLoginFoodDeliveryStates)
                      const CircularProgressIndicator(),
                    if(state is! LoadingLoginFoodDeliveryStates)
                      InkWell(
                        onTap: () {
                          if(checkValidation()){
                            cubit.loginAccount(
                                phone: phoneController.text,
                                password: passwordController.text,
                                context: context
                            );
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.45,
                          height: MediaQuery.of(context).size.height/13,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadiusDirectional.circular(MediaQuery.of(context).size.width*0.25),
                          ),
                          child: Center(child: BigText(name: 'Sign in', color: Colors.white, size: 24.sp,),),
                        ),
                      ),
                    SizedBox(height: 30.h,),
                    RichText(
                      text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 20.sp
                          ),
                          children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()..onTap=(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return SignUpFoodScreen();
                                  },));
                                },
                                text: ' Create',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.sp,
                                    color: Colors.black
                                )
                            )
                          ]
                      ),
                    ),
                    SizedBox(height: 5.h,),
                  ],
                ),
              ),

            ),
          );
        },
      ),
    );
  }
}
