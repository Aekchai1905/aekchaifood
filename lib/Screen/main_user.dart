// import 'dart:convert';
// import 'package:aekfooddelivery/Screen/show_shop_fodd_menu.dart';
// import 'package:aekfooddelivery/model/user_model.dart';
// import 'package:aekfooddelivery/utility/my_constant.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:aekfooddelivery/utility/signoutprocess.dart';
import 'package:aekfooddelivery/widget/show_list_shop_all.dart';
import 'package:aekfooddelivery/widget/show_status_food_order.dart';
// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String name, user, chooseType;
  Widget currentWidget;
  @override
  void initState() {
    super.initState();
    currentWidget = ShowListShopAll();
    findUser();
    // readShop();
  }



  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(name == null ? "Main User" : "$name  login "),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  signOutProcess(context);
                })
          ]),
      body: currentWidget, 
      drawer: showDrawer("User"),
      );
  }

  Drawer showDrawer(String nameFrame) => Drawer(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHeadDrawer(nameFrame), 
                menuListShop(),
                menuStatusFoodOrder(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [ 
                menuSignOut(),
              ],
            ),
          ],
        ),
      );

  ListTile menuListShop() {
    return ListTile(onTap: () {
      Navigator.pop(context);
      setState(() {
        currentWidget = ShowListShopAll();
      });
    },
      leading: Icon(Icons.home),
      title: Text("แสดงร้านค้า"),
      subtitle: Text("แสดงร้านค้าที่สามารถสั่งอาหารได้"),
    );
  }

ListTile menuStatusFoodOrder() {
    return ListTile(onTap: () {
      Navigator.pop(context);
      setState(() {
        currentWidget = ShowStatusFoodOrder();
      });
    },
      leading: Icon(Icons.restaurant_menu),
      title: Text("แสดงรายการอาหารที่สั่ง"),
      subtitle: Text("แสดงรายการอาหารที่สั่ง หรือดูสถานะอาหารที่สั่ง"),
    );
  }

  Widget menuSignOut() {
    return Container(
      decoration: BoxDecoration(color: Colors.green.shade900),
      child: ListTile(
        onTap: () => signOutProcess(context),
        leading: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        title: Text(
          "Sign Out",
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "การออกจากแอพ",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  UserAccountsDrawerHeader showHeadDrawer(String nameFrame) {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration("$nameFrame.jpg"),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        name == null ? nameFrame : "$name $nameFrame",
        style: TextStyle(color: MyStyle().whiteColor),
      ),
      accountEmail: Text(
        "LogIn",
        style: TextStyle(color: MyStyle().whiteColor),
      ),
    );
  }
}
