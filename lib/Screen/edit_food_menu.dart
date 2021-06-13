import 'dart:io';

import 'package:aekfooddelivery/model/food_model.dart';
import 'package:aekfooddelivery/utility/my_constant.dart';
import 'package:aekfooddelivery/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
// import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditFoodMenu extends StatefulWidget {
  final FoodModel foodModel;
  EditFoodMenu({Key key, this.foodModel}) : super(key: key);

  @override
  _EditFoodMenuState createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {
  FoodModel foodModel;
  File file;
  String name, price, detail, pathImage;

  @override
  void initState() {
    super.initState();

    foodModel = widget.foodModel;
    name = foodModel.nameFood;
    price = foodModel.price;
    detail = foodModel.detail;
    pathImage = foodModel.pathImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: uploanButton(),
      appBar: AppBar(
        title: Text("ปรับปรุงเมนู${foodModel.nameFood}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            nameFood(),
            // MyStyle().mySizebox(),
            groupImage(),
            priceFood(),
            detailFood(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton uploanButton() {
    return FloatingActionButton(
      onPressed: () {
        if (name.isEmpty || price.isEmpty || detail.isEmpty) {
          normalDialog(context, "กรุณากรอกให้ครบทุกช่องครับ");
        } else {
          confirmEdit();
        }
      },
      child: Icon(Icons.cloud_upload),
    );
  }

  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("คุณต้องการจะเปลี่ยนแปลงเมนูอาหาร?"),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  editValueOnMySQL();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                label: Text("ตกลง"),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text("ยกเลิก"),
              ),
            ],
          ),
        ],
        // children: Row(children: [ElevatedButton.icon(onPressed: null, icon: Icon(Icons.check), label: "เปลี่ยนแปลง")]),
      ),
    );
  }

  Future<Null> editValueOnMySQL() async {

    String id = foodModel.id;
    
    // print("Edit Value ON MY SQL ===========>>>>>>");

    String url =
        "${MyConstant().domain}/aekchaifood/editFoodWhereId.php?isAdd=true&id=$id&NameFood=$name&PathImage=$pathImage&Price=$price&Detail=$detail";
    
    print("URL = $url");
    await Dio().get(url).then((value) {
      if(value.toString() == "true") {
        Navigator.pop(context);
      } else {
        normalDialog(context, "กรุณาลองใหม่มีอะไรผิดพลาด");
      }
    });
  }

  Widget groupImage() => Row(
        children: [
          IconButton(
              onPressed: () => chooseImage(ImageSource.camera),
              icon: Icon(Icons.add_a_photo)),
          Container(
            padding: EdgeInsets.all(16.0),
            width: 250.0,
            height: 250.0,
            child: file == null
                ? Image.network(
                    "${MyConstant().domain}${foodModel.pathImage}",
                    fit: BoxFit.cover,
                  )
                : Image.file(file),
          ),
          IconButton(
              onPressed: () => chooseImage(ImageSource.gallery),
              icon: Icon(Icons.add_photo_alternate)),
        ],
      );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800.0,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget nameFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => name = value.trim(),
              initialValue: foodModel.nameFood,
              decoration: InputDecoration(
                labelText: "ชื่อ เมนูอาหาร",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
  Widget priceFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => price = value.trim(),
              keyboardType: TextInputType.phone,
              initialValue: foodModel.price,
              decoration: InputDecoration(
                labelText: "ราคาอาหาร",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
  Widget detailFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => detail = value.trim(),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 3,
              initialValue: foodModel.detail,
              decoration: InputDecoration(
                labelText: "รายละเอียดอาหาร",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
