import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aekfooddelivery/model/user_model.dart';
import 'package:aekfooddelivery/utility/my_constant.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:aekfooddelivery/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoShop extends StatefulWidget {
  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel userModel;
  String nameShop, address, phone, urlPicture;
  Location location = Location();
  double lat, lng;
  File file;

  @override
  void initState() {
    super.initState();
    readCurrentInfo();
    location.onLocationChanged.listen(
      (event) {
        if (lat == null) {
          setState(() {
            lat = event.latitude;
            lng = event.longitude;
            // print("Location lat==>>$lat ,lng=$lng");
          });
        }
      },
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      // var object = await ImagePicker().getImage(source: imageSource);
      PickedFile selectedFile = await ImagePicker().getImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        file = File(selectedFile.path);
      });
      // file = File(selectedFile.path);
    } catch (e) {}
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString("id");
    print("id shop =====>$idShop");

    String url =
        "${MyConstant().domain}/aekchaifood/getUserWhereId.php?isAdd=true&id=$idShop";
    Response response = await Dio().get(url);
    var result = json.decode(response.data);
    for (var map in result) {
      setState(() {
        userModel = UserModel.fromJson(map);

        nameShop = userModel.nameShop;
        address = userModel.address;
        phone = userModel.phone;
        urlPicture = userModel.urlPicture;
        // lat = userModel.lat;
        // lng = userModel.lng;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null ? MyStyle().showProgress() : showContent(),
      appBar: AppBar(
        title: Text("ปรับปรุง รายละเอียดร้าน aek"),
      ),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: [
            nameShopForm(),
            showImage(),
            addressForm(),
            phoneForm(),
            lat == null ? MyStyle().showProgress() : showMap(),
            editButton(),
          ],
        ),
      );

  Widget editButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton.icon(
          onPressed: () => confirmDialog(),
          icon: Icon(Icons.edit),
          label: Text("ปรับปรุงรายละเอียดร้าน"),
        ),
      );

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("คุณแน่ใจว่าจะปรับปรุงรายละเอียดของร้าน ?"),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  editThread();
                },
                child: Text("แน่ใจ"),
              ),
              MyStyle().mySizebox(),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("ไม่แน่ใจ"),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editThread() async {
    if (file == null) {
        String id = userModel.id;
          print("id = $id");

          String url =
              "${MyConstant().domain}/aekchaifood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlPicture&Lat=$lat&Lng=$lng";
          Response response = await Dio().get(url);
          if (response.toString() == "true") {
            Navigator.pop(context);
          } else {
            normalDialog(context, "ยังอัพเดทไม่ได้ กรุณาลองใหม่");
          }
    } else {
      Random random = Random();
      int i = random.nextInt(100000);
      String namefile = "editshop$i.jpg";

      Map<String, dynamic> map = Map();
      map["file"] = file == null
          ? Image.network(MyConstant().domain + urlPicture)
          : await MultipartFile.fromFile(file.path, filename: namefile);
      print("file Path ==>${file.path}");
      FormData formData = FormData.fromMap(map);

      String urlUpload = "${MyConstant().domain}/aekchaifood/saveShop.php";
      await Dio().post(urlUpload, data: formData).then(
        (value) async {
          urlPicture = "/aekchaifood/Shop/$namefile";

          String id = userModel.id;
          print("id = $id");

          String url =
              "${MyConstant().domain}/aekchaifood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlPicture&Lat=$lat&Lng=$lng";
          Response response = await Dio().get(url);
          if (response.toString() == "true") {
            Navigator.pop(context);
          } else {
            normalDialog(context, "ยังอัพเดทไม่ได้ กรุณาลองใหม่");
          }
        },
      );
    }
  }

  Set<Marker> currentMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId("myMarker"),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: "ร้าน${userModel.nameShop}อยู่ที่นี่",
            snippet: "Lat =$lat ,Lng=$lng",
          ))
    ].toSet();
  }

  Widget showMap() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.0,
    );

    return Container(
      margin: EdgeInsets.only(top: 16.0),
      height: 250.0,
      // width: 200.0,
      child: GoogleMap(
        onMapCreated: (controller) {},
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        markers: currentMarker(),
      ),
    );
  }

  Widget showImage() => Container(
        margin: EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  chooseImage(ImageSource.camera);
                },
                icon: Icon(Icons.add_a_photo)),
            Container(
              width: 250.0,
              height: 250.0,
              child: file == null
                  ? Image.network(MyConstant().domain + urlPicture)
                  : Image.file(file),
            ),
            IconButton(
                onPressed: () {
                  chooseImage(ImageSource.gallery);
                },
                icon: Icon(Icons.add_photo_alternate)),
          ],
        ),
      );

  Widget nameShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => nameShop = value,
              initialValue:
                  nameShop == null ? MyStyle().showProgress() : nameShop,
              decoration: InputDecoration(
                labelText: "ชื่อของร้าน",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              minLines: 3,
              maxLines: 5,
              onChanged: (value) => address = value,
              initialValue: address,
              decoration: InputDecoration(
                labelText: "ที่อยู่ของร้าน",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => phone = value,
              initialValue: phone,
              decoration: InputDecoration(
                labelText: "เบอร์โทรของร้าน",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
