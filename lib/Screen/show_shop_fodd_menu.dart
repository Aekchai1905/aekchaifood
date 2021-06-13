import 'package:aekfooddelivery/model/user_model.dart';
import 'package:flutter/material.dart';

class ShowShopFoodMenu extends StatefulWidget {
  const ShowShopFoodMenu({Key key, this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  _ShowShopFoodMenuState createState() => _ShowShopFoodMenuState();
}

class _ShowShopFoodMenuState extends State<ShowShopFoodMenu> {
  UserModel userModel;


  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel.nameShop),
      ),
    );
  }
}
