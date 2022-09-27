import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:food_delivery/screens/pages/sub_pages/success_order_food.dart';
import 'package:food_delivery/shared/cubit/states.dart';
import 'package:food_delivery/shared/network/local/cache_helper.dart';
import 'package:food_delivery/shared/network/remote/dio_helper.dart';
import 'package:food_delivery/utils/app_constant.dart';

import '../../components/show_custom_snackbar.dart';
import '../../models/carts_model.dart';
import '../../models/carts_order_model.dart';
import '../../models/place_order_model.dart';
import '../../models/profile_model.dart';
import '../../screens/carts_history.dart';
import '../../screens/carts_order.dart';
import '../../screens/main_food.dart';
import '../../screens/profile_food.dart';
import '../../utils/colors.dart';
import 'package:http/http.dart' as http;

class AppDeliveryFoodCubit extends Cubit<AppDeliveryFoodStates> {

  AppDeliveryFoodCubit() : super(AppDeliveryFoodInitialStates());

  static AppDeliveryFoodCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = const [
    MainFoodScreen(),
    CartsOrderScreen(),
    CartsHistory(),
    //CartHistoryScreen(),
    ProfileFoodScreen()
  ];

  int currentIndex = 0;
  void getIndex(int index){
    currentIndex = index;
    emit(AppDeliveryFoodChangeBottomStates());
  }


  // Get Popular Product Data
  Products? popularModel;
  Future getPopularProduct() async{
    await DioHelper.getData(uri: POPULAR)
      .then((value) {
      popularModel = Products.fromJson(value.data);
      emit(AppDeliveryFoodGetProductsStates());
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(AppDeliveryFoodErrorGetProductsStates());
    });
  }

  // Get Recommended Product Data
  Products? recommendedModel;
  Future getRecommendedProduct() async{
    await DioHelper.getData(uri: RECOMMENDED)
      .then((value) {
      recommendedModel = Products.fromJson(value.data);
      emit(AppDeliveryFoodGetProductsStates());
    }).catchError((error){
      emit(AppDeliveryFoodErrorGetProductsStates());
    });
  }
  int inCartItem = 0;
  int quantityCart = 0;
  // Initial Product => Popular
  void initProduct(ProductsModel model){
    inCartItem = 0;
    quantityCart = 0;
    late bool exist;
    exist = isExist(model);
    if(exist){
      inCartItem = getQuantity(model);
      if (kDebugMode) {
        print(inCartItem);
      }
      quantityCart = getQuantity(model);
      if (kDebugMode) {
        print('${quantityCart}quantity is');
      }
    }
    emit(AppDeliveryFoodCartQuantityStates());
  }
  // inc or dec Quantity
  void cartQuantity(bool inc){
    if(inc){
      checkQuantity(++inCartItem);
    } else {
      checkQuantity(--inCartItem);
    }
  }
  // Check Cart Quantity
  void checkQuantity(int num){
    if(num>20) {
      inCartItem = 20;
    }
    else if (num<0) {
      inCartItem = 0;
    }
    else {
      inCartItem = num;
      emit(AppDeliveryFoodCartQuantityStates());
    }

  }

  List<String> cartListLocalTest = [];
  void getDataLocal() {
    cartListLocalTest = [];
    if (CacheHelper.sharedPreferences.containsKey(CART_LIST)) {
      CacheHelper.getData(CART_LIST).forEach((e) {
        cartListLocalTest.add(e);
      });
        getQuantityCartShop();
        getAllCartItem();
        for (var element in cartListLocalTest) {
          Map<String, dynamic> mapValue = jsonDecode(element);
          cartModel.putIfAbsent(mapValue['id'], () {
            return CartsModel.fromJson(mapValue);
          });
        }
      }


  }


  // Get Cart Shop
  int quantityCartShop = 0;
  void getQuantityCartShop(){
    quantityCartShop = 0;
    for (var element in cartListLocalTest) {
      Map valueMap = jsonDecode(element);
      quantityCartShop += int.parse(valueMap['quantity'].toString());
    }

  }
  // Map of The Item
  Map<int, CartsModel> cartModel = {};
  // Add Cart Item
  void addCartItem(ProductsModel model, int quantity, context , {bool inCart = false}){
    if(inCart){
      if (cartModel.containsKey(model.id)){
        // Update
        cartModel.update(model.id, (value) {
          return CartsModel(
            id: value.id,
            name: value.name,
            price: value.price,
            img: value.img,
            description: value.description,
            quantity: value.quantity+quantity,
            isExist: true,
            time: DateTime.now().toString(),
            product: model,
          );
        });
        // Initialize
        // Remove Empty Cart
        quantityCart = getQuantity(model);
        inCartItem = getQuantity(model);
        if(quantityCart == 0){
          if (kDebugMode) {
            print('The id is ${cartModel[model.id]!.id} the Quantity is ${cartModel[model.id]!.quantity}');
          }
          cartModel.remove(model.id);
        }
        cartListLocalTest = [];
        cartModel.forEach((key, value) {
          cartListLocalTest.add(jsonEncode(value));
        });
        // CacheHelper.deleteData(CART_LIST);
        CacheHelper.setData(CART_LIST, cartListLocalTest);
        //print(CacheHelper.getData(CART_LIST));
        getQuantityCartShop();
        getAllCartItem();
        emit(AppDeliveryFoodCartQuantityStates());
      }
    }
    //Check if Cart Empty or Not
    else {
      if(quantity+quantityCart > 0) {
        // Check of key is duplicate or not if duplicate update else insert
        if (cartModel.containsKey(model.id)){
          // Update
          cartModel.update(model.id, (value) {
            return CartsModel(
              id: value.id,
              name: value.name,
              price: value.price,
              img: value.img,
              description: value.description,
              quantity: quantity,
              isExist: true,
              time: DateTime.now().toString(),
              product: model,
            );
          });
          // Initialize
          quantityCart = getQuantity(model);
          // Remove Empty Cart
          if(quantity == 0){
            if (kDebugMode) {
              print('The id is ${cartModel[model.id]!.id} the Quantity is ${cartModel[model.id]!.quantity}');
            }
            cartModel.remove(model.id);
          }
          cartListLocalTest = [];
          cartModel.forEach((key, value) {
            cartListLocalTest.add(jsonEncode(value));
          });
          //CacheHelper.deleteData(CART_LIST);
          CacheHelper.setData(CART_LIST, cartListLocalTest);
          //print(CacheHelper.getData(CART_LIST));
          getQuantityCartShop();
          emit(AppDeliveryFoodCartQuantityStates());
        } else {
          // Insert
          cartModel.putIfAbsent(model.id, () {
            return CartsModel(
              id: model.id,
              name: model.name,
              price: model.price,
              img: model.img,
              description: model.description,
              quantity: quantity,
              isExist: true,
              time: DateTime.now().toString(),
              product: model,
            );
          });
          cartListLocalTest = [];
          cartModel.forEach((key, value) {
            cartListLocalTest.add(jsonEncode(value));
          });
         // CacheHelper.deleteData(CART_LIST);
            CacheHelper.setData(CART_LIST, cartListLocalTest);
          //print(CacheHelper.getData(CART_LIST));

          // Initialize
          if (kDebugMode) {
            print(model.id);
          }
          quantityCart = getQuantity(model);
          getQuantityCartShop();
          emit(AppDeliveryFoodCartQuantityStates());
        }
        // if Quantity < 0 Don't Do Any Thing Just appear message to Customer
      } else {
        SnackBar snackBarCart = SnackBar(
          padding: EdgeInsetsDirectional.all(20.r),
          backgroundColor: AppColors.mainColor,
          content: Text(
            'You Should at least add an item in the cart',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarCart);
      }
    }
    if(cartModel.isNotEmpty){
      cartModel.forEach((key, value) {
        if (kDebugMode) {
          print('The 222id is ${value.id} the Quantity is ${value.quantity}');
        }
      });
    }
  }
  // Exist or Not
  bool isExist(ProductsModel model){
    if (cartModel.containsKey(model.id)){
      return true;
    }
    return false;
  }
  // get Quantity
  int getQuantity(ProductsModel model){
    int quantity = 0;
    if(cartModel.containsKey(model.id)) {
      cartModel.forEach((key, value) {
        if(key == model.id) {
          quantity = value.quantity;
        }
      });
    }
    return quantity;
  }

  List<CartsModel> cartModelListItem = [];
  var totalAmount = 0;
  void getAllCartItem(){

    cartModelListItem = [];
    for (var element in cartListLocalTest) {
      Map<String, dynamic> valueMap = jsonDecode(element);
      cartModelListItem.add(CartsModel.fromJson(valueMap));
    }
    getTotalAmount();
  }

  void getTotalAmount(){
    totalAmount = 0;
    if(cartModelListItem.isNotEmpty){
      for (var element in cartModelListItem) {
        totalAmount+= element.quantity*element.price;
      }
    }
  }


  List<int> convertToMap(List<String> data){
    Map<String, int> mapData = {};
    for (var element in data) {
      Map<String ,dynamic> mapValue = jsonDecode(element);
      if(mapData.containsKey(mapValue['time'])){
        mapData.update(mapValue['time'], (value) => ++value);
      }
      mapData.putIfAbsent((mapValue['time']), () => 1);
    }
    List<int> dataSave = [];
    mapData.forEach((key, value) {
      dataSave.add(value);
    });
    return dataSave;
  }

  List<String> cartHistory = [];
  void getCartHistoryData(){

    for (var element in cartModelListItem) {
      cartHistory.add(jsonEncode(element));
    }

    // for (var element in cartListLocalTest) {
    //   cartHistory.add(element);
    // }
    CacheHelper.setData(profileModel!.id.toString(),cartHistory);
  }

  void checkOutData(){
    getCartHistoryData();
    sortHistoryDataByTime();
    convertToCartModelObject();
    CacheHelper.deleteData(CART_LIST);
    cartModel = {};
    cartListLocalTest = [];
    cartModelListItem = [];
    quantityCartShop = 0;
    inCartItem = 0;
    getTotalAmount();
    emit(AppDeliveryFoodCheckOutStates());
  }

  // Sort Like Integer [ 3 , 1 , 2 ]; Know Length
  List<int> dataHistoryList = [];
  void sortHistoryDataByTime() {
    dataHistoryList = convertToMap(cartHistory);
  }


  // int listCounter = 0;
  // void getSortByTimeData(){
  //   listCounter = 0;
  //   print(cartHistory.length);
  //   for (int i = 0; i < dataHistoryList.length; i++){
  //     print('index is '+i.toString());
  //     for(int y = 0; y < dataHistoryList[i]; y++){
  //       print('index is '+y.toString());
  //     }
  //   }
  // }

  List<CartsModel> cartModelHistory = [];
  void convertToCartModelObject(){
    cartModelHistory = [];
    for (var element in cartHistory) {
      Map<String, dynamic> mapValue = jsonDecode(element);
      cartModelHistory.add(CartsModel.fromJson(mapValue));
    }
    // cartModelHistory.forEach((element) {
    //   print('Quantity is '+ element.quantity.toString());
    // });
  }

  // Show Cart Details
  List<CartsModel> cartHistoryDetails = [];
  int totalAmountDetails = 0;
  void getCartHistoryDetails(CartsModel model) {
    cartHistoryDetails = [];
    totalAmountDetails = 0;
    for (var element in cartModelHistory) {
      if (element.time == model.time){
        cartHistoryDetails.add(element);
      }
    }
    for (var element in cartHistoryDetails) {
      totalAmountDetails+=element.price*element.quantity;
    }
  }


  // Delete Cart History
  List<int> deleteIndex = [];
  void deleteCartHistory(CartsModel model, int index){
    deleteIndex = [];
    for(int i = 0; i<cartModelHistory.length; i++){
      if(model.time == cartModelHistory[i].time) {
        deleteIndex.add(i);
      }
    }

    for(int c = deleteIndex.length-1; c>=0; c--){
      cartModelHistory.removeAt(deleteIndex[c]);
    }


    cartHistory = [];
    if(cartModelHistory.isNotEmpty){
      for (var element in cartModelHistory) {
        cartHistory.add(jsonEncode(element));
      }
    }
    dataHistoryList.removeAt(index);
    CacheHelper.setData(profileModel!.id.toString(),cartHistory);
    emit(AppDeliveryFoodDeleteProductsStates());
  }

  ProfileModel? profileModel;
  void getProfileInformation(){
    if(token != ''){
      DioHelper.getData(
        uri: PROFILE,
        token: token,
      ).then((value) {
        profileModel = ProfileModel.fromJson(value.data);
        if(profileModel != null){
          if (kDebugMode) {
            print('profile id is ${profileModel!.id}');
          }
          if (CacheHelper.sharedPreferences.containsKey(profileModel!.id.toString())) {
            CacheHelper.getData(profileModel!.id.toString()).forEach((e) {
              cartHistory.add(e);
            });
            sortHistoryDataByTime();
            convertToCartModelObject();
          }
        }
        emit(AppDeliveryFoodGetProfileStates());
      }).catchError((onError){
        if (kDebugMode) {
          print(onError.toString());
        }
        emit(AppDeliveryFoodErrorGetProfileStates());
      });
    }
  }

  bool isLogin(){
    if(token == ''){
      return false;
    } else {
      return true;
    }
  }
  void logOut(){
    CacheHelper.deleteData('token');
    CacheHelper.deleteData(CART_LIST);
    token = '';
    profileModel = null;
    cartModelHistory.clear();
    dataHistoryList.clear();
    cartHistory.clear();
    cartOrderList = [];
    placeOrderDetails = [];
    pendingOrderId = [];
    emit(AppDeliveryFoodLogOutStates());
  }

  // @override
  // Future<void> close() {
  //   // dispose
  //
  //   return super.close();
  // }


  //  Payment

  // OrderModel? orderModel;
  // void placeOrder(Function callBack, BuildContext context, PlaceOrderBody placeOrderBody) {
  //   DioHelper.postData(
  //     uri: PLACE_DETAILS_URI,
  //     data: placeOrderBody.toJson(),
  //   ).then((value) {
  //     String message = value.data['message'];
  //     String orderID = value.data['order_id'].toString();
  //     callBack(true,message,orderID,context);
  //   }).catchError((error){
  //     callBack(false,error.toString(),'-1',context);
  //   });
  // }



  Map<String, dynamic>? paymentIntentData;
  bool isLoading = false;
  Future<void> makePayment(PlaceOrderBody placeOrderBody, context) async {
    isLoading = true;
    try {
      paymentIntentData = await createPaymentIntent(totalAmount.toString(), 'USD');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US',testEnv: true),
              style: ThemeMode.dark,

              merchantDisplayName: 'Food Delivery'
          )
      );
      displayPaymentSheet(placeOrderBody,context);

    } catch(e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  displayPaymentSheet(PlaceOrderBody placeOrderBody, context) async {
    try {



      await Stripe.instance.presentPaymentSheet();


      // old paymentSheet _ Flutter V3.0 Update it (Not Recommended)
      // await Stripe.instance.presentPaymentSheet(
      //   parameters: PresentPaymentSheetParameters(
      //     clientSecret: paymentIntentData!['client_secret'],
      //     confirmPayment: true,
      //
      //   ),
      // );


      paymentIntentData =null;
      checkOutData();
      emit(AppDeliveryFoodCheckOutStates());
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const SuccessOrderFood();
      },));
      await DioHelper.postData(uri: PLACE_DETAILS_URI, token:token ,data: placeOrderBody.toJson()).then((value) {

      }).catchError((e){
        if (kDebugMode) {
          print('Error$e');
        }
      });
      isLoading = false;
      await getOrderDetails();


    } on StripeException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      showToast(text: 'Cancelled', state: selectedColor.ERROR);
      isLoading = false;
    }
    emit(AppDeliveryFoodGetOrderStates());
  }

  createPaymentIntent(String amount, String currency) async{
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await  http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers:  {
            'Authorization': 'Bearer sk_test_51Lih9pAoeXn5AEXXx3c7hGjlXEQBqLuYzVp5xXzHMAxDQcU8TqmNsPsUK5nQf4wE0Yks8DuS0Ba0WYJpdcD0UCwF00ZAhKBJ4n',
            'Content-Type': 'application/x-www-form-urlencoded'
          }
      );
      return jsonDecode(response.body.toString());

    } catch(e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }


  }

  calculateAmount(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }

  List<String> pendingOrderId = [];
  
  List<PlaceOrderBody> placeOrderDetails = [];
  Future<void> getOrderDetails() async {
    if (kDebugMode) {
      print(token);
    }
    if(token != ''){
      placeOrderDetails = [];
      pendingOrderId = [];
      DioHelper.getData(
        uri: LIST_DETAILS_URI,
        token: token,
      ).then((value) {
        value.data.forEach((e){
          if (kDebugMode) {
            print(e.toString());
          }
          placeOrderDetails.add(PlaceOrderBody.fromJson(e));
          if(e['order_status'] == 'pending') {
            pendingOrderId.add(e['id'].toString());
          }
        });
      }).then((value) async{
        await getOrderDetailsById(pendingOrderId);
        emit(AppDeliveryFoodGetOrderStates());
      });
    }
  }

  List<CartOrderModel> cartOrderList = [];
  Future<void> getOrderDetailsById(List<String> orderId) async{
    cartOrderList = [];
    for (var element in orderId) {
      await DioHelper.getData(
        uri: DETAILS_BY_ORDER_URI,
        token: token,
        query: {
          'order_id': element
        },
      ).then((value) {
        value.data.forEach((e){
          var model = e['food_details'];
          model = jsonDecode(model);
          cartOrderList.add(CartOrderModel(name: model['name'], image: model['img'], quantity: e['quantity'].toString(), price: e['price'].toString()),);
          //print( cartOrderList[0].name);
        });
      }).catchError((error){
        if (kDebugMode) {
          print('s$error');
        }
      });
    }
    emit(AppDeliveryFoodGetOrderStates());
  }

}