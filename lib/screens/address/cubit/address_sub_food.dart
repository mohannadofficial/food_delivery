import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/screens/address/cubit/cubit.dart';
import 'package:food_delivery/screens/address/cubit/states.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressSubFoodScreen extends StatelessWidget {
  LatLng initialPosition;
  AddressSubFoodScreen({Key? key, required this.initialPosition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressAppCubit, AddressAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddressAppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.mainColor,
            centerTitle: true,
            title: BigText(name: 'Address Page', color: Colors.white,),
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: initialPosition,
                  zoom: 17,
                ),
                compassEnabled: false,
                indoorViewEnabled: true,
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                onCameraMove: (position) {
                  initialPosition = position.target;
                },
                onCameraIdle: () {
                  cubit.updatePosition(CameraPosition(target: initialPosition, zoom: 17), true);
                },
                onMapCreated: (controller) {
                  cubit.setMapController(controller);
                },
              ),
              Center(
                child: Image.asset('assets/image/pick_marker.png' , height: 50.h,),
              ),
              Positioned(
                top: 50.h,
                left: 15.w,
                right: 15.w,
                child: Container(
                  height: 45,
                  color: AppColors.mainColor,
                  child: Row(
                    children: [
                      SizedBox(width: 10.w,),
                      Icon(Icons.location_on, color: Colors.grey[200],),
                      SizedBox(width: 5.w,),
                      Expanded(child: BigText(name: cubit.placeMark.name!, color: Colors.white, size: 16.sp,),)
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: Colors.black12,
            ),
            child: Center(
                child: Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width/2.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: AppColors.mainColor,
                  ),
                  child: InkWell(onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Center(child: BigText(name: 'Pick Address', color: Colors.white),)),
                ),
            ),
          ),
        );
      },
    );
  }
}
