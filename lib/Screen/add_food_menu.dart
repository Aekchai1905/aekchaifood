import 'dart:io';
import 'dart:math';


import 'package:aekfooddelivery/utility/my_constant.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:aekfooddelivery/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoodMenu extends StatefulWidget {
  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  File file;
  String nameFood, price, detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มรายการเมนูอาหาร"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            showTitleFood("รูปอาหาร"),
            groupImage(),
            showTitleFood("รายละเอียดอาหาร"),
            nameForm(),
            MyStyle().mySizebox(),
            priceForm(),
            MyStyle().mySizebox(),
            detailForm(),
            MyStyle().mySizebox(),
            saveButton()
          ],
        ),
      ),
    );
  }
  Future <Null> uploadFoodAndInsertData() async
  {
      String urlUpload = "${MyConstant().domain}/aekchaifood/saveFood.php";
      Random random = Random();
      int i = random.nextInt(1000000);
      String nameFile = "food$i.jpg";

      try {
        Map <String ,dynamic> map = Map();
        map["file"] =await MultipartFile.fromFile(file.path,filename: nameFile);
        FormData formData = FormData.fromMap(map);

        print("File Path ==>>>>>>${file.path} ,Name File ===>>>>>>$nameFile");

        await Dio().post(urlUpload,data: formData).then((value) async{
          String urlPathImage = "/aekchaifood/food/$nameFile";
          print("Url Path Image =${MyConstant().domain}$urlPathImage");
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String idShop = preferences.getString("id");

          String urlInsertData = "${MyConstant().domain}/aekchaifood/addFood.php?isAdd=true&idShop=$idShop&NameFood=$nameFood&PathImage=$urlPathImage&Price=$price&Detail=$detail";

          await Dio().get(urlInsertData).then((value) => Navigator.pop(context));


        });


      } catch (e) {
      }

      
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width, 
      child: ElevatedButton.icon(
          onPressed: () {
            if (file == null) {
              normalDialog(context,
                  "กรุณาเลือกรูปภาพก่อน โดยการ Tab Camera หรือ Gallery");
            } else if (detail == null ||
                detail.isEmpty ||
                nameFood == null ||
                nameFood.isEmpty ||
                price == null ||
                price.isEmpty)
              normalDialog(context, "กรุณากรอกทุกช่องครับ");
            else {
              uploadFoodAndInsertData();
            }
          },
          icon: Icon(Icons.save),
          label: Text("Save Food Menu")),
    );
  }

  Widget nameForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => nameFood = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.fastfood),
            labelText: "ชื่ออาหาร",
            border: OutlineInputBorder(),
          ),
        ),
      );
  Widget priceForm() => Container(
        width: 250.0,
        child: TextField(keyboardType: TextInputType.phone ,
          onChanged: (value) => price = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.attach_money),
            labelText: "ราคาอาหาร",
            border: OutlineInputBorder(),
          ),
        ),
      );
  Widget detailForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => detail = value.trim(),
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.details),
            labelText: "รายละเอียดอาหาร",
            border: OutlineInputBorder(),
          ),
        ),
      );

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () => chooseImage(ImageSource.camera),
        ),
        Container(
            width: 160.0,
            height: 160.0,
            child: file == null
                ? Image.asset("images/food_list1.png")
                : Image.file(file)),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () => chooseImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {
      normalDialog(context, e.toString());
    }
  }

  Widget showTitleFood(String string) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyStyle().showTitleH2(string),
        ],
      ),
    );
  }
}
