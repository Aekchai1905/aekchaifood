import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:aekfooddelivery/utility/signoutprocess.dart';
import 'package:aekfooddelivery/widget/information_shop.dart';
import 'package:aekfooddelivery/widget/list_food_menu_shop.dart';
import 'package:aekfooddelivery/widget/order_list_shop.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
// Field
  Widget currentWidget = OrderListShop();

  String name;
  @override
  void initState() {
    super.initState();
    findUser();
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
        title: Text(name == null ? "Main Shop" : "$name  login "),
        actions: <Widget>[
          IconButton(
              onPressed: () => signOutProcess(context),
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      drawer: showDrawer("Shop"),
      body: currentWidget,
    );
  }

  Drawer showDrawer(String nameFrame) => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(nameFrame),
            homeMenu(),
            foodMenu(),
            informationMenu(),
            signOut(),
          ],
        ),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.home),
        title: Text("รายการสินค้าที่สั่ง"),
        subtitle: Text("รายการสินค้าค้างส่ง"),
        onTap: () {
          setState(() {
            currentWidget = OrderListShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile foodMenu() => ListTile(
        leading: Icon(Icons.fastfood),
        title: Text("รายการสินค้า"),
        subtitle: Text("รายการสินค้า ของร้าน"),
        onTap: () {
          setState(() {
            currentWidget = ListFoodMenuShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile informationMenu() => ListTile(
        leading: Icon(Icons.info),
        title: Text("รายละเอียดของร้าน"),
        subtitle: Text("รายละเอียดของร้าน พร้อมแก้ไข"),
        onTap: () {
          setState(() {
            currentWidget = InformationShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile signOut() => ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text("Sign Out"),
        subtitle: Text("Sign Out และกลับไปหน้าแรก"),
        onTap: () => signOutProcess(context),
      );

  UserAccountsDrawerHeader showHeadDrawer(String nameFrame) {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration("$nameFrame.jpg"),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        nameFrame,
        style: TextStyle(color: MyStyle().darkColor),
      ),
      accountEmail: Text(
        "LogIn",
        style: TextStyle(color: MyStyle().darkColor),
      ),
    );
  }
}
