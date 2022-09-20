import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/AppTextForm.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../shared/cubit/cubit.dart';
import 'cubit/address_sub_food.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class AddressFoodScreen extends StatefulWidget {
  const AddressFoodScreen({Key? key}) : super(key: key);

  @override
  State<AddressFoodScreen> createState() => _AddressFoodScreenState();
}

class _AddressFoodScreenState extends State<AddressFoodScreen> {

  TextEditingController addressController = TextEditingController();
  TextEditingController contactPersonName = TextEditingController();
  TextEditingController contactPersonNumber = TextEditingController();
  late bool isLogged;
   CameraPosition cameraPosition = CameraPosition(target: LatLng(
    45.51563, -122.677433,
  ));
  late LatLng initialPosition = const LatLng(
    45.51563, -122.677433,
  );


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLogged = AppDeliveryFoodCubit.get(context).isLogin();
    if(isLogged && AppDeliveryFoodCubit.get(context).profileModel==null){
      AppDeliveryFoodCubit.get(context).getProfileInformation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressAppCubit, AddressAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddressAppCubit.get(context);
        var cubitUser = AppDeliveryFoodCubit.get(context);
        addressController.text = '${cubit.placeMark.name??''}'
            '${cubit.placeMark.locality??''}'
            '${cubit.placeMark.postalCode??''}'
            '${cubit.placeMark.country??''}';
        if(cubitUser.profileModel!=null && contactPersonName.text.isEmpty){
          contactPersonName.text = cubitUser.profileModel!.name;
          contactPersonNumber.text = cubitUser.profileModel!.phone;

        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.mainColor,
            title: const Text('Address Page'),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    child: Stack(
                      children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: initialPosition,
                              zoom: 17,
                            ),
                            onTap: (argument) {
                              if(cubit.navOneTime % 2 == 0) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddressSubFoodScreen(initialPosition: cameraPosition.target),));
                              }
                              ++cubit.navOneTime;
                              print(cubit.navOneTime);
                            },
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            indoorViewEnabled: true,
                            mapToolbarEnabled: false,
                            myLocationEnabled: true,

                            onCameraMove: ((position) {
                              cameraPosition = position;
                            }),
                            onCameraIdle: () {
                                cubit.updatePosition(cameraPosition, true);
                            },
                            onMapCreated: (controller) {
                              cubit.setMapController(controller);
                            },
                        ),
                      ],
                  ),
                ),
                SizedBox(height: 20.h,),
                SizedBox(
                  height: 50.h,
                  child: ListView.builder(
                    itemCount: cubit.addressTypeList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          cubit.setIndexAddress(index);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 18.r,vertical: 10.r),
                          margin: EdgeInsetsDirectional.only(start: 15.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[200]!,
                                  spreadRadius: 1
                              ),
                            ]
                          ),
                          child: Icon(
                           index == 0 ? Icons.home_filled:index==1?Icons.work:Icons.location_on,
                            color: cubit.addressTypeIndex == index? AppColors.mainColor:Theme.of(context).disabledColor,

                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h,),
                Padding(
                  padding:  EdgeInsetsDirectional.only(start: 20.r),
                  child: BigText(name: 'Delivery Address'),
                ),
                SizedBox(height: 10 .h,),
                AppTextForm(
                    controller: addressController,
                    iconData: Icons.location_on,
                    hintText: 'Your address',
                    textInputType: TextInputType.text),
                SizedBox(height: 10 .h,),
                Padding(
                  padding:  EdgeInsetsDirectional.only(start: 20.r),
                  child: BigText(name: 'Contact Details'),
                ),
                SizedBox(height: 10 .h,),
                AppTextForm(
                    controller: contactPersonName,
                    iconData: Icons.person,
                    hintText: 'Your address',
                    textInputType: TextInputType.text,
                    isreadOnly: true,
                ),
                AppTextForm(
                    controller: contactPersonNumber,
                    iconData: Icons.phone,
                    hintText: 'Your address',
                    textInputType: TextInputType.text,
                    isreadOnly: true,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: Colors.black12,
            ),
            child: Center(
              child: InkWell(
                onTap: () async{
                  AddressModel model = AddressModel(
                      addressType: cubit.addressTypeList[cubit.addressTypeIndex],
                      address: addressController.text,
                      latitude: cameraPosition.target.latitude.toString(),
                      longitude: cameraPosition.target.longitude.toString(),
                      contactPersonName: contactPersonName.text,
                      contactPersonNumber: contactPersonNumber.text,
                  );
                  await cubit.addAddressData(model);
                  if(cubit.getCheckAdd()){
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width/2.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: AppColors.mainColor,
                  ),
                  child: Center(child: BigText(name: 'Save Address', color: Colors.white),),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
