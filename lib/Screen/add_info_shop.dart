import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:aekfooddelivery/utility/my_constant.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:aekfooddelivery/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
  
}

class _AddInfoShopState extends State<AddInfoShop> {
  // Field
  double lat, lng;
  File file;
  String nameShop, address, phone, urlImage;

  @override
  void initState() {
    super.initState();
    findLaLng();
  }

  Future<Null> findLaLng() async {
    LocationData locationData = await findLocationData();

    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      // lat = 13.705311;
      // lng = 100.539307;
    });

    print("lat= $lat , lng=" + lng.abs().toString());
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Information Shop"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySizebox(),
            nameForm(),
            MyStyle().mySizebox(),
            addressForm(),
            MyStyle().mySizebox(),
            phoneForm(),
            MyStyle().mySizebox(),
            groupImage(),
            MyStyle().mySizebox(),
            lat == null ? MyStyle().showProgress() : showMap(),
            // showMap(),
            MyStyle().mySizebox(),
            saveButton()
            // RaisedButton(onPressed: () {},Icon(Icons.save),),
          ],
        ),
      ),
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
      file = File(selectedFile.path);
    } catch (e) {}
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
        label: Text(
          "Save Information",
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        onPressed: () {
          if (nameShop == null ||
              nameShop.isEmpty ||
              address == null ||
              address.isEmpty ||
              phone == null ||
              phone.isEmpty) {
            normalDialog(context, "กรุณากรอกทุกช่องครับ");
          } else if (file == null) {
            normalDialog(context, "กรุณาเลือกรูปภาพด้วยครับ");
          } else {
            uploadImage();
          }
        },
      ),
    );
  }

  Future<Null> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = "shop$i.jpg";

    String url = "${MyConstant().domain}/aekchaifood/saveShop.php";
    print(url);
    try {
      Map<String, dynamic> map = Map();
      map["file"] =
          await MultipartFile.fromFile(file.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) {
        print("Response ==>> $value");
        urlImage = "/aekchaifood/Shop/$nameImage";
        print("URL Image = $urlImage");
        editUserShop();
      });
    } catch (e) {}
  }

  Future<Null> editUserShop() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString("id");
    String url =
        "${MyConstant().domain}/aekchaifood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlImage&Lat=$lat&Lng=$lng";
    print(url);
    await Dio().get(url).then((value) {
      if (value.toString() == "true") {
        Navigator.pop(context);
      } else {
        normalDialog(context, "กรุณาลองใหม่ ไม่สามารถบันทึกได้ครับ");
      }
    });    
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("MyShop"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: "MKL Head Office",
          snippet: "ละติจูด =$lat ,ลองติจูด = $lng",
        ),
      )
    ].toSet();
  }

  Container showMap() {
    // print("lat= $lat , lng=$lng");
    // 13.705373, 100.539286
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    return Container(
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: myMarker(),
      ),
    );
  }

  Widget groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36.0,
            ),
            onPressed: () {
              chooseImage(ImageSource.camera);
            }),
        Container(
          width: 250.0,
          child: file == null
              ? Image.asset("images/PicShop.png")
              : Image.file(file),
        ),
        IconButton(
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36.0,
          ),
          onPressed: () => chooseImage(ImageSource.gallery),
        )
      ],
    );
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => nameShop = value.trim(),
              decoration: InputDecoration(
                labelText: "ชื่อร้านค้า",
                prefixIcon: Icon(Icons.account_box),
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
            width: 250.0,
            child: TextField(
              onChanged: (value) => address = value.trim(),
              decoration: InputDecoration(
                labelText: "ที่อยู่ร้านค้า",
                prefixIcon: Icon(Icons.maps_home_work),
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
            width: 250.0,
            child: TextField(
              onChanged: (value) => phone = value.trim(),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "เบอร์ติดต่อร้านค้า",
                prefixIcon: Icon(Icons.phone_iphone),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
