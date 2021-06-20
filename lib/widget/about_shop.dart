

import 'package:aekfooddelivery/model/user_model.dart';
import 'package:aekfooddelivery/utility/my_api.dart';
import 'package:aekfooddelivery/utility/my_constant.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AboutShop extends StatefulWidget {
  final UserModel userModel;
  AboutShop({Key key, this.userModel}) : super(key: key);

  @override
  _AboutShopState createState() => _AboutShopState();
}

class _AboutShopState extends State<AboutShop> {
  UserModel userModel;
  double lat1 = 0, lng1 = 0, lat2 = 0, lng2 = 0, distance;
  String distanceString;
  int transport;
  CameraPosition position;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    findLat1Lng1();
    // location.onLocationChanged.listen((event) {
    //   if (lat1 == 0) {
    //     setState(() {
    //       lat1 = event.latitude;
    //       lng1 = event.longitude;
    //       print("lat1 = $lat1 , lng = $lng1");
    //     });
    //   }
    // });
  }

  Future<Null> findLat1Lng1() async {
    LocationData locationData = await MyAPI().findLocationData();
    setState(() {
      lat1 = locationData.latitude;
      lng1 = locationData.longitude;
      lat2 = double.parse(userModel.lat);
      lng2 = double.parse(userModel.lng);
      distance = MyAPI().calculateDistance(lat1, lng1, lat2, lng2);

      var myFormat = NumberFormat("#0.0#", 'en_US');
      distanceString = myFormat.format(distance);
      transport = MyAPI().calculateTransport(distance);

      // print("lat1 = $lat1 ,lng1=$lng1 ,lat2 = $lat2 ,lng2=$lng2 ,distance =$distance");
    });
  }

  

  

  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(16.0),
                width: 150.0,
                height: 150.0,
                child: Image.network(
                  "${MyConstant().domain}${userModel.urlPicture}",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          ListTile(
            // leading: MyStyle().showTitleH2("ที่อยู่ :"),
            leading: Icon(Icons.home),
            title: Text(userModel.address),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(userModel.phone),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text(distance == null ? "" : "$distanceString กิโลเมตร"),
          ),
          ListTile(
            leading: Icon(Icons.transfer_within_a_station),
            title: Text(transport == null ? "" : "${transport.toString()} บาท"),
          ),
          showMap()
        ],
      ),
    );
  }

  Widget showMap() {
    if (lat1 != 0) {
      LatLng latLng1 = LatLng(lat1, lng1);
      print("lat1 =$lat1 ,lng1 =$lng1");
      position = CameraPosition(
        target: latLng1,
        zoom: 14,
      );
    }

    Marker userMarker() {
      return Marker(
        markerId: MarkerId("userMarker"),
        position: LatLng(lat1, lng1),
        // icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "คุณอยู่ที่นี่"),
      );
    }
    // BitmapDescriptor aa = BitmapDescriptor;
    Marker shopMarker() {
      return Marker(
        markerId: MarkerId("shopMarker"),
        position: LatLng(lat2, lng2),
        icon: BitmapDescriptor.defaultMarkerWithHue(125.0),
        // icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: userModel.nameShop),
      );
    }

    Set<Marker> mySet()
    {
      return <Marker>[userMarker(),shopMarker()].toSet();
    }

    return Container(
      margin: EdgeInsets.all(16.0),
      // margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 16.0),
      // color: Colors.grey,
      height: 250.0,
      child: lat1 == 0
          ? MyStyle().showProgress()
          : GoogleMap(              
              initialCameraPosition: position,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: mySet(),
            ),
    );
  }
}
