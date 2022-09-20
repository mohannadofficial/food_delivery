import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/screens/address/cubit/cubit.dart';
import 'package:food_delivery/shared/bloc_observer.dart';
import 'package:food_delivery/shared/cubit/cubit.dart';
import 'package:food_delivery/shared/network/local/cache_helper.dart';
import 'package:food_delivery/shared/network/remote/dio_helper.dart';
import 'package:food_delivery/utils/app_constant.dart';

import 'layout/food_delivery.dart';
import 'on_boarding/on_boarding_Screen.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51Lih9pAoeXn5AEXXOEa2lkVoIL7JfAorrYKTApiDTz7DjFK0ysC7ocQL0Ak7cWnpaJbQlEG7PY3WIRIdYWHEB56z00xD6pfT4i';
  Stripe.instance.applySettings();
  DioHelper.init();
  await CacheHelper.init();
  // CacheHelper.deleteData(CART_LIST);
  // CacheHelper.deleteData(ON_BOARDING);
  // CacheHelper.deleteData(CART_HISTORY);
  // CacheHelper.deleteData('token');
  if (CacheHelper.sharedPreferences.containsKey('token')){
    token = CacheHelper.getData('token');
  }
  if (CacheHelper.sharedPreferences.containsKey(ON_BOARDING)){
    firstTimeApp = CacheHelper.getData(ON_BOARDING);
  }

  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {

  const MyApp( {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
            create: (context) => AppDeliveryFoodCubit()..getProfileInformation()..getPopularProduct()..getRecommendedProduct()..getDataLocal()..getOrderDetails(),
            ),
            BlocProvider(create: (context) => AddressAppCubit()..getAddressData(fromMain: true),),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Delivery App',
            // You can use the library anywhere in the app even in theme
            home: child,
            // initialRoute: '/',
            // routes: {
            //   '/':(context)=>FoodDeliveryLayout(),
            //   '/popular'(context) => PopularFoodDetails
            //
            // },
          ),
        );
      },
        //child: token == '' ? LoginFoodScreen(): FoodDeliveryLayout(),
        child: firstTimeApp != null ? const FoodDeliveryLayout() : const OnBoardingScreen(),
    );
  }
}