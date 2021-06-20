import 'dart:convert';

import 'package:aekfooddelivery/Screen/show_shop_food_menu.dart';
import 'package:aekfooddelivery/model/user_model.dart';
import 'package:aekfooddelivery/utility/my_constant.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowListShopAll extends StatefulWidget {
  @override
  _ShowListShopAllState createState() => _ShowListShopAllState();
}

class _ShowListShopAllState extends State<ShowListShopAll> {
  List<UserModel> userModels = List.empty(growable: true);
  List<Widget> shopCards = List.empty(growable: true);
  String name;

  @override
  void initState() {
    super.initState();     
    findUser();
    readShop();
  }
  @override
  Widget build(BuildContext context) {
    return shopCards.length == 0
          ? MyStyle().showProgress()
          : GridView.extent(
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              maxCrossAxisExtent: 180.0,
              children: shopCards,
            ); 
  }
  
  Future<Null> readShop() async {
    String url =
        "${MyConstant().domain}/aekchaifood/getUserWhereChooseType.php?isAdd=true&ChooseType=Shop";
    await Dio().get(url).then((value) {
      // print("value =$value");
      var result = json.decode(value.data);
      int index = 0;
      for (var map in result) {
        UserModel model = UserModel.fromJson(map);
        if (model.nameShop.isNotEmpty) {
          // print("Seq ${model.id} NameShop ======>${model.nameShop}");
          setState(() {
            userModels.add(model);
            shopCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name");
    });
  }
  Widget createCard(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        // print("You click index $index");
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowShopFoodMenu(
            userModel: userModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage(MyConstant().domain + userModel.urlPicture),
              ),
            ),
            MyStyle().mySizebox(),
            MyStyle().showTitleH2(userModel.nameShop),
          ],
        ),
      ),
    );
  }
}