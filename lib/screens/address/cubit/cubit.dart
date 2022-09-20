
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/components/show_custom_snackbar.dart';
import 'package:food_delivery/screens/address/cubit/states.dart';
import 'package:food_delivery/shared/network/remote/dio_helper.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../models/address_model.dart';
import '../../../utils/app_constant.dart';

class AddressAppCubit extends Cubit<AddressAppStates> {

  AddressAppCubit() : super(InitialAddressAppStates());

  static AddressAppCubit get(context) => BlocProvider.of(context);


  bool loading = false;
  late Position position;
  late Position pickPosition;
  Placemark placeMark = Placemark();
  Placemark pickPlaceMark = Placemark();
  List<AddressModel> addressList = [];
  late List<AddressModel> allAddressList;
  List<String> addressTypeList = ['home', 'office', 'others'];
  int addressTypeIndex = 0;
  late Map<String, dynamic> getAddress;
  late GoogleMapController googleMapController;
  bool updateAddressData = true;
  bool changeAddress = true;
  int navOneTime = 0;


  late LatLng initialPosition;

  Future<void> setInitialPosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    initialPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
    emit(UpdateAddressAppStates());
  }



  void setIndexAddress(int index){
    addressTypeIndex = index;
    emit(ChangeIndexAddressAppStates());
  }

  void setMapController(GoogleMapController controller){
    googleMapController = controller;
  }

  void updatePosition(CameraPosition cameraPosition, bool fromAddress) async{
    if(updateAddressData){
      loading = true;
      emit(UpdateAddressAppStates());
      try {
        if(fromAddress){
          position = Position(
              longitude: cameraPosition.target.longitude,
              latitude: cameraPosition.target.latitude,
              timestamp: DateTime.now(),
              accuracy: 1,
              altitude: 1,
              heading: 1,
              speed: 1,
              speedAccuracy: 1
          );
        } else {
          pickPosition = Position(
              longitude: cameraPosition.target.longitude,
              latitude: cameraPosition.target.latitude,
              timestamp: DateTime.now(),
              accuracy: 1,
              altitude: 1,
              heading: 1,
              speed: 1,
              speedAccuracy: 1
          );
        }
        if(changeAddress){
          print('latt ${cameraPosition.target.latitude}');
          String address = await getAddressFromServer(
            LatLng(cameraPosition.target.latitude, cameraPosition.target.longitude),
          );
          //print(address);
          fromAddress?placeMark=Placemark(name: address):
              pickPlaceMark = Placemark(name: address);
        }
      }catch(e) {
        print(e);
      }
    }
  }

  Future<String> getAddressFromServer(LatLng latLng) async{
    String address = 'unknown Location Found';
    await DioHelper.getData(
      uri: GETOCODE_URI,
      query: {
        'lat':latLng.latitude,
        'lng': latLng.longitude,
      }
    ).then((value) {
      address = value.data['results'][0]['formatted_address'].toString();
    }).catchError((onError){
      print(onError.toString());
    });
    return address;
  }

  bool checkAdd = false;

  Future<void> addAddressData(AddressModel addressModel,) async{
    await DioHelper.postData(
      uri: ADD_USER_ADDRESS,
      data: addressModel.toJson(),
      token: token,
    ).then((value) async {
      showToast(text: 'Address has been successfully added', state: selectedColor.SUCSESS);
      await getAddressData();
      checkAdd = true;
    }).catchError((e){
      showToast(text: 'Error: The new address could not be added', state: selectedColor.ERROR);
      checkAdd = false;
    });
    emit(UpdateAddressAppStates());
  }

  bool getCheckAdd(){
    return checkAdd;
  }


  Future<void> getAddressData({bool fromMain = false}) async{
    if(token != ''){
      await DioHelper.getData(
        uri: ADDRESS_LIST_URI,
        token: token,
      ).then((value) {
        allAddressList = [];
        addressList = [];
        value.data.forEach((e){
          allAddressList.add(AddressModel.fromJson(e));
          addressList.add(AddressModel.fromJson(e));
        });
      }).catchError((e){
        print('error is + ${e.toString()}');
      });
      if (addressList.isNotEmpty) {
        pickPlaceMark = Placemark(name: addressList.first.address);
        if(fromMain){
          placeMark = Placemark(name: addressList.first.address);
        }
      }
      emit(UpdateAddressAppStates());
    }

  }

  void clearAllListAddress(){
    addressList = [];
    allAddressList = [];
    emit(RemoveAllAddressAppStates());
  }

}