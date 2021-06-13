import 'dart:convert';

import 'package:aekfooddelivery/Screen/add_info_shop.dart';
import 'package:aekfooddelivery/Screen/edit_info_shop.dart';
import 'package:aekfooddelivery/model/user_model.dart';
import 'package:aekfooddelivery/utility/my_constant.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationShop extends StatefulWidget {
  @override
  _InformationShopState createState() => _InformationShopState();
}

class _InformationShopState extends State<InformationShop> {
  UserModel userModel;
  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    String url =
        "${MyConstant().domain}/aekchaifood/getUserWhereId.php?isAdd=true&id=$id";
    await Dio().get(url).then((value) {
      // print("value =$value");
      var result = json.decode(value.data);
      // print("value = $value");
      // print("result = $result");

      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });
        print("Name Shop =${userModel.nameShop}");
      }
    });
  }

  void routeToAppInfo() {

    Widget widget = userModel.nameShop.isEmpty? AddInfoShop() :EditInfoShop();

    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, materialPageRoute).then((value) => readDataUser());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        userModel == null
            ? MyStyle().showProgress()
            : userModel.nameShop.isEmpty
                ? showNoData(context, "ยังไม่มีข้อมูล กรุณาเพิ่มข้อมูลด้วยครับ")
                : showListInfoShop(),
        addAndEditButton()
      ],
    );
  }

  Widget showListInfoShop() => Column(
        children: [
          MyStyle().showTitleH2("รายละเอียดร้าน ${userModel.nameShop}"),
          MyStyle().mySizebox(),
          showImage(),
          Row(
            children: [
              MyStyle().showTitleH2("ที่อยู่ร้าน "),
            ],
          ),
          Row(
            children: [
              Text("${userModel.address}"),
            ],
          ),
          MyStyle().mySizebox(),
          showMap(),
        ],
      );

  Container showImage() {
    return Container(width: 200.0,height: 200.0,
          child: Image.network("${MyConstant().domain}" + userModel.urlPicture),
        );
  }

  Set<Marker> shopMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId("shopID"),
          position: LatLng(
            double.parse(userModel.lat),
            double.parse(userModel.lng),
          ),
          infoWindow: InfoWindow(
              title: "ตำแหน่งร้าน ${userModel.nameShop}",
              snippet:
                  "ละติจูด =${userModel.lat}, ลองติจูด = ${userModel.lng}"))
    ].toSet();
  }

  Widget showMap() {
    double lat = double.parse(userModel.lat);
    double lng = double.parse(userModel.lng);
    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    return Expanded(
      child: GoogleMap(
        markers: shopMarker(),
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
      ),
      // padding: EdgeInsets.all(10.0),
      // height: 300.0,
    );
  }

  Widget showNoData(BuildContext context, String pstrWord) {
    return MyStyle().titleCenter(context, pstrWord);
  }

  Row addAndEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  routeToAppInfo();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
