import 'package:aekfooddelivery/model/user_model.dart';
import 'package:flutter/material.dart';


class OrderListShop extends StatefulWidget {
  @override
  _OrderListShopState createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    
  }

  

  @override
  Widget build(BuildContext context) {
    return Text("แสดงรายการสินค้าที่ลูกค้าสั่ง");
  }
}
