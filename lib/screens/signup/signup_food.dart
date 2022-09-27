import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/AppTextForm.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/components/icon_app_pages.dart';
import 'package:food_delivery/components/show_custom_snackbar.dart';
import 'package:food_delivery/screens/signup/cubit/cubit.dart';
import 'package:food_delivery/screens/signup/cubit/states.dart';
import 'package:food_delivery/utils/colors.dart';

class SignUpFoodScreen extends StatelessWidget {
  SignUpFoodScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var signImage = [
      't.png',
      'f.png',
      'g.png',
    ];

    bool checkValidation(){
      if(emailController.text.isEmpty){
        showToast(text: 'please type your email', state: selectedColor.ERROR);
        return false;
      }
      else if(passwordController.text.isEmpty) {
        showToast(text: 'please type your password', state: selectedColor.ERROR);
        return false;
      }
      else if(phoneController.text.isEmpty) {
        showToast(text: 'please type your phone', state: selectedColor.ERROR);
        return false;
      }
      else if(nameController.text.isEmpty) {
        showToast(text: 'please type your name', state: selectedColor.ERROR);
        return false;
      }
      else if(passwordController.text.length < 6) {
        showToast(text: 'your password is too short', state: selectedColor.ERROR);
        return false;
      }
      else if(!emailController.text.contains('@')) {
        showToast(text: 'please enter a valid email', state: selectedColor.ERROR);
        return false;
      } else {
        return true;
      }
    }

    return BlocProvider(
      create: (context) => SignUpFoodDeliveryCubit(),
      child: BlocConsumer<SignUpFoodDeliveryCubit, SignUpFoodDeliveryStates>(
        listener: (context, state) {
          if(state is ErrorSignUpFoodDeliveryStates){
            showToast(text: 'Email or phone number is already in use', state: selectedColor.ERROR);
          }
          if(state is SuccessSignUpFoodDeliveryStates){
            showToast(text: 'Registration Successfully', state: selectedColor.SUCSESS);
          }
        },
        builder: (context, state) {
          var cubit = SignUpFoodDeliveryCubit.get(context);
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
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
                     AppTextForm(controller: emailController, iconData: Icons.email, hintText: 'Email', textInputType: TextInputType.emailAddress,),
                     AppTextForm(controller: passwordController, iconData: Icons.password, hintText: 'Password', textInputType: TextInputType.visiblePassword, isPassword: cubit.isPassword, afterIcon: cubit.afterIcon, functionIcon: cubit.changeVisibility, ),
                     AppTextForm(controller: phoneController, iconData: Icons.phone_android_sharp, hintText: 'Phone', textInputType: TextInputType.phone,),
                     AppTextForm(controller: nameController, iconData: Icons.person, hintText: 'Name', textInputType: TextInputType.name,),
                     SizedBox(height: 20.h,),
                     if(state is LoadingSignUpFoodDeliveryStates)
                       const CircularProgressIndicator(),
                     if(state is! LoadingSignUpFoodDeliveryStates)
                       InkWell(
                         onTap: () {
                           bool valid = checkValidation();
                           if(valid){
                             cubit.registerAccount(
                                 userName: nameController.text,
                                 password: passwordController.text,
                                 email: emailController.text,
                                 phone: phoneController.text,
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
                           child: Center(child: BigText(name: 'Sign up', color: Colors.white, size: 24.sp,),),
                         ),
                       ),
                     SizedBox(height: 10.h,),
                     RichText(
                         text: TextSpan(
                           recognizer: TapGestureRecognizer()..onTap=() {
                             Navigator.pop(context);
                           },
                           text: 'Have an account?',
                           style: TextStyle(
                               color: Colors.grey,
                               fontSize: 18.sp
                           ),
                         )
                     ),
                     SizedBox(height: 10.h,),
                     RichText(
                         text: TextSpan(
                           text: 'Sign up using one of the following methods',
                           style: TextStyle(
                               color: Colors.grey[500],
                               fontSize: 14.sp
                           ),
                         )
                     ),
                     SizedBox(height: 5.h,),
                     Wrap(
                       children: List.generate(3, (index) {
                         return Padding(
                           padding: const EdgeInsets.all(10.0),
                           child: CircleAvatar(
                               radius: 20.r,
                               backgroundImage: AssetImage('assets/image/${signImage[index]}')
                           ),
                         );
                       }),
                     )

                   ],
                 ),
               ),

             ),
           ),
          );
        },
      ),
    );
  }
}
