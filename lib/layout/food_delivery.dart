import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/screens/address/cubit/cubit.dart';
import 'package:food_delivery/screens/address/cubit/states.dart';
import 'package:food_delivery/shared/cubit/cubit.dart';
import 'package:food_delivery/shared/cubit/states.dart';
import '../utils/colors.dart';

class FoodDeliveryLayout extends StatelessWidget {
   const FoodDeliveryLayout({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppDeliveryFoodCubit, AppDeliveryFoodStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppDeliveryFoodCubit.get(context);
        return BlocConsumer<AddressAppCubit, AddressAppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.white,
              body: SafeArea(
                child: cubit.screens[cubit.currentIndex],
              ),
              bottomNavigationBar: BottomNavigationBar(
                onTap: cubit.getIndex,
                currentIndex: cubit.currentIndex,
                selectedItemColor: AppColors.mainColor,
                unselectedItemColor: Colors.grey[500],
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedFontSize: 0.0,
                unselectedFontSize: 0.0,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home_outlined,
                    ),
                    activeIcon: Icon(
                      Icons.home,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                    ),
                    activeIcon: Icon(
                      Icons.shopping_bag,
                    ),
                    label: 'Archive',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                      ),
                      activeIcon: Icon(
                        Icons.shopping_cart,
                      ),
                      label: 'cart'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person_outline,
                      ),
                      activeIcon: Icon(
                        Icons.person,
                      ),
                      label: 'Profile'),
                ],
              ),
            );
          },
        );
      },
    );
  }







}
