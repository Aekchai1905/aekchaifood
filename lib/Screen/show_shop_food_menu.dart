import 'package:aekfooddelivery/model/user_model.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:aekfooddelivery/widget/about_shop.dart';
import 'package:aekfooddelivery/widget/show_menu_food.dart';
import 'package:flutter/material.dart';

class ShowShopFoodMenu extends StatefulWidget {
  const ShowShopFoodMenu({Key key, this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  _ShowShopFoodMenuState createState() => _ShowShopFoodMenuState();
}

class _ShowShopFoodMenuState extends State<ShowShopFoodMenu> {
  UserModel userModel;
  List<Widget> listWidgets = List.empty(growable: true);
  int indexPage = 0;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    listWidgets.add(AboutShop(userModel: userModel));
    listWidgets.add(ShowMenuFood(
      userModel: userModel,
    ));
  }

  BottomNavigationBarItem aboutShopNav() {
    return BottomNavigationBarItem(
        icon: Icon(Icons.restaurant), label: "รายละเอียดร้าน");
  }

  BottomNavigationBarItem showMenuFood() {
    return BottomNavigationBarItem(
        icon: Icon(Icons.restaurant_menu), label: "เมนูอาหาร");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [MyStyle().iconShowCart(context)],
        title: Text(userModel.nameShop),
      ),
      body: listWidgets.length == 0
          ? MyStyle().showProgress()
          : listWidgets[indexPage],
      bottomNavigationBar: showButtomNavigationBar(),
    );
  }

  BottomNavigationBar showButtomNavigationBar() => BottomNavigationBar(
        backgroundColor: Colors.green.shade500,
        selectedItemColor: Colors.yellow.shade300,
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          aboutShopNav(),
          showMenuFood(),
        ],
      );
}
