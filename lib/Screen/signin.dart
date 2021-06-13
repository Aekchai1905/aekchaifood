import 'dart:convert';
import 'package:aekfooddelivery/Screen/main_rider.dart';
import 'package:aekfooddelivery/Screen/main_shop.dart';
import 'package:aekfooddelivery/Screen/main_user.dart';
import 'package:aekfooddelivery/model/user_model.dart';
import 'package:aekfooddelivery/utility/my_constant.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:aekfooddelivery/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: <Color>[Colors.white, MyStyle().primaryColor],
              center: Alignment(0, -0.3),
              radius: 1.0),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MyStyle().showLogo(),
                MyStyle().mySizebox(),
                MyStyle().showTitle(MyStyle().applicationName),
                MyStyle().mySizebox(),
                userForm(),
                MyStyle().mySizebox(),
                passwordForm(),
                MyStyle().mySizebox(),
                loginButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() => Container(
        width: 250,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: MyStyle().darkColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          onPressed: () {
            if (user == null ||
                user.isEmpty ||
                password == null ||
                password.isEmpty) {
              normalDialog(context, "มีช่องว่าง กรุณากรอกให้ครบครับ");
            } else {
              checkAuthen();
            }
          },
          child: Text("Login"),
        ),
      );

  Future<Null> checkAuthen() async {
    String url =
        "${MyConstant().domain}/aekchaifood/getUserWhere.php?isAdd=true&user=$user";
    print(url);
    try {
      Response response = await Dio().get(url);
      print("response = $response");
      var result = json.decode(response.data);
      print("result = $result");
      if (result == null) {
        normalDialog(context, "User ไม่ถูกต้อง กรุณาลองใหม่");
      } else {
        for (var map in result) {
          UserModel userModel = UserModel.fromJson(map);
          print(user);
          if (password == userModel.password) {
            String chooseType = userModel.chooseType;

            if (chooseType == "User") {
              routeToService(MainUser(), userModel);
            } else if (chooseType == "Shop") {
              routeToService(MainShop(), userModel);
            } else if (chooseType == "Rider") {
              routeToService(MainRider(), userModel);
            } else {
              normalDialog(context, "Error");
            }
          } else {
            normalDialog(context, "Password ไม่ถูกต้อง กรุณาลองใหม่");
          }
        }
      }
    } catch (e) {}
  }

  Future<Null> routeToService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("id", userModel.id);
    preferences.setString("chooseType", userModel.chooseType);
    preferences.setString("user", userModel.user);
    preferences.setString("name", userModel.name);

    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userForm() => Container(
        width: 250,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: "User :",
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
          ),
        ),
      );
  Widget passwordForm() => Container(
        width: 250,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: "Password :",
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
          ),
        ),
      );
}
