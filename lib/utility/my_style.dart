import 'package:aekfooddelivery/Screen/show_cart.dart';
import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.green.shade900;
  Color whiteColor = Colors.white;
  String applicationName = "MKL Delivery";

  MyStyle();

  Widget iconShowCart(BuildContext context) {
    return IconButton(
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(builder: (context) => ShowCart(),);
          Navigator.push(context, route);
        },
        icon: Icon(Icons.add_shopping_cart));
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  SizedBox mySizebox() => SizedBox(
        width: 8.0,
        height: 8.0,
      );

  Container showLogo() {
    return Container(
      width: 120,
      height: 120,
      child: Image.asset("images/fooddelivery.png"),
    );
  }

  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/$namePic"), fit: BoxFit.cover));
  }

  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 20,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      );

  Text showTitleH2(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      );

  Text showTitleH3(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.w500,
        ),
      );


       Text showTitleH3Red(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.red ,
          fontWeight: FontWeight.w500,
        ),
      );


  Drawer showDrawer(String nameFrame) => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(nameFrame),
          ],
        ),
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

  Widget titleCenter(BuildContext context, String string) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          string,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  TextStyle mainTitle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.purple,
  );

  TextStyle mainH2Title = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.green.shade700,
  );


}
