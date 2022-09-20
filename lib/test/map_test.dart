import 'package:flutter/material.dart';
import 'package:food_delivery/components/icon_app_pages.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTestScreen extends StatefulWidget {
  const MapTestScreen({Key? key}) : super(key: key);

  @override
  State<MapTestScreen> createState() => _MapTestScreenState();

}

class _MapTestScreenState extends State<MapTestScreen> {
  late bool services ;
  late LocationPermission cl;
  late Position cu;
  Future getPosition() async {
    services = await Geolocator.isLocationServiceEnabled();
    cl = await Geolocator.checkPermission();
    print(services);
    if(cl == LocationPermission.denied ){
      Geolocator.requestPermission();
    }
    cu = await Geolocator.getCurrentPosition();
    print(cl);
  }


  @override
  void initState() {
    getPosition();
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onTap: (t){
          print(t.longitude);
        },
          initialCameraPosition: CameraPosition(target: LatLng(10.978943, 21.349695),
          ),
      ),
    );
  }
}