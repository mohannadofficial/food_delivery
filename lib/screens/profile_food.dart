import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/components/icon_app_pages.dart';
import 'package:food_delivery/components/row_icon_text.dart';
import 'package:food_delivery/screens/address/address_food.dart';
import 'package:food_delivery/screens/address/cubit/cubit.dart';
import 'package:food_delivery/screens/address/cubit/states.dart';
import 'package:food_delivery/screens/login/login_food.dart';
import 'package:food_delivery/shared/cubit/cubit.dart';
import 'package:food_delivery/shared/cubit/states.dart';

import '../utils/colors.dart';

class ProfileFoodScreen extends StatelessWidget {
  const ProfileFoodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.mainColor,
    ));
    return BlocConsumer<AppDeliveryFoodCubit, AppDeliveryFoodStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppDeliveryFoodCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.isLogin(),
          builder: (context) {
            return cubit.profileModel != null ? SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.r),
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        color: AppColors.mainColor,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0,3),
                            blurRadius: 10,
                            color: Colors.black26,
                          ),
                        ]
                    ),
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                          fontSize: 22.sp
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0.r),
                    child: IconAppPages(icon: Icons.person, color: Colors.white, backGroundColor: AppColors.mainColor, size: 135.h, sizeIcon: 60.h,),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //
                          SizedBox(height: 20.h,),
                          // Name
                          RowIconText(
                            iconApp: IconAppPages(
                              icon: Icons.person,
                              color: Colors.white,
                              backGroundColor: AppColors.mainColor,
                              sizeIcon: 20.h,
                              size: 40.h,
                            ),
                            bigText: BigText(name: cubit.profileModel!.name),
                          ),
                          SizedBox(height: 20.h,),
                          // Phone
                          RowIconText(
                            iconApp: IconAppPages(
                              icon: Icons.phone,
                              color: Colors.white,
                              backGroundColor: AppColors.yellowColor,
                              sizeIcon: 20.h,
                              size: 40.h,
                            ),
                            bigText: BigText(name: cubit.profileModel!.phone),
                          ),
                          SizedBox(height: 20.h,),
                          // Email
                          RowIconText(
                            iconApp: IconAppPages(
                              icon: Icons.email,
                              color: Colors.white,
                              backGroundColor: AppColors.yellowColor,
                              sizeIcon: 20.h,
                              size: 40.h,
                            ),
                            bigText: BigText(name: cubit.profileModel!.email),
                          ),
                          SizedBox(height: 20.h,),
                          // Location
                          BlocConsumer<AddressAppCubit, AddressAppStates>(
                              listener: (context, state) {},
                              builder: (context, state) =>  InkWell(
                                onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressFoodScreen(),));
                                },
                                child: RowIconText(
                                  iconApp: IconAppPages(
                                    icon: Icons.location_on,
                                    color: Colors.white,
                                    backGroundColor: AppColors.yellowColor,
                                    sizeIcon: 20.h,
                                    size: 40.h,
                                  ),
                                  bigText: AddressAppCubit.get(context).addressList.isEmpty?BigText(name: 'Fill in your address'):
                                  BigText(name: AddressAppCubit.get(context).pickPlaceMark.name.toString()),
                                ),
                              ),
                          ),
                          SizedBox(height: 20.h,),
                          // Message
                          RowIconText(
                            iconApp: IconAppPages(
                              icon: Icons.message,
                              color: Colors.white,
                              backGroundColor: Colors.redAccent,
                              sizeIcon: 20.h,
                              size: 40.h,
                            ),
                            bigText: BigText(name: 'none'),
                          ),
                          SizedBox(height: 20.h,),
                          // LogOut
                          InkWell(
                            onTap: () {
                              AddressAppCubit.get(context).clearAllListAddress();
                              cubit.logOut();
                            },
                            child: RowIconText(
                              iconApp: IconAppPages(
                                icon: Icons.logout,
                                color: Colors.white,
                                backGroundColor: Colors.redAccent,
                                sizeIcon: 20.h,
                                size: 40.h,
                              ),
                              bigText: BigText(name: 'Logout'),
                            ),
                          ),
                          SizedBox(height: 20.h,),
                          //
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
            : const Center(child: CircularProgressIndicator());
          },
          fallback: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage(
                  'assets/image/signintocontinue.png',
                ),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/3,
              ),
              Container(
                width: MediaQuery.of(context).size.width/1.25,
                height: MediaQuery.of(context).size.height/10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(20.r),
                  color: AppColors.mainColor,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginFoodScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BigText(name: 'Sign in here! ', color: Colors.white,),
                      const Icon(Icons.login, color: Colors.white,)

                    ],
                  ),
                )
              ),
            ],
          ),
        );
      },
    );
  }
}
