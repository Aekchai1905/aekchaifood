import 'package:aekfooddelivery/utility/my_constant.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:aekfooddelivery/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String chooseType, name, user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          myLogo(),
          MyStyle().mySizebox(),
          showAppName(),
          MyStyle().mySizebox(),
          nameForm(),
          MyStyle().mySizebox(),
          userForm(),
          MyStyle().mySizebox(),
          passwordForm(),
          MyStyle().mySizebox(),
          MyStyle().showTitleH2("ชนิดของสมาชิก :"),
          MyStyle().mySizebox(),
          userRadio(),
          shopRadio(),
          riderRadio(),
          MyStyle().mySizebox(),
          registerButton(),
        ],
      ),
    );
  }

  Widget userRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: Row(
              children: <Widget>[
                Radio(
                  value: "User",
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(
                      () {
                        chooseType = value;
                      },
                    );
                  },
                ),
                Text(
                  "ผู้สั่งอาหาร",
                  style: TextStyle(color: MyStyle().darkColor),
                )
              ],
            ),
          ),
        ],
      );

  Widget registerButton() => Container(
        width: 250,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: MyStyle().darkColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          onPressed: () {
            // print("name= $name ,user=$user ,password=$password ,chooseType = $chooseType");
            if (name == null ||
                name.isEmpty ||
                user == null ||
                user.isEmpty ||
                password == null ||
                password.isEmpty) {
              print("Have Space");
              normalDialog(context, "มีช่องว่าง กรุณากรอกทุกช่อง");
            } else if (chooseType == null || chooseType.isEmpty) {
              normalDialog(context, "โปรดเลือกชนิดของผู้สมัคร");
            } else {
              checkUser();
            }
          },
          child: Text("Register"),
        ),
      );

  Future<Null> checkUser() async {
    String url =
        "${MyConstant().domain}/aekchaifood/getUserWhere.php?isAdd=true&user=$user";

    try {
      Response response = await Dio().get(url);
      if (response.toString() == "null") {
        print("before register");
        registerThread();
      } else {
        normalDialog(
            context, "user $user มีคนอื่นใช้ไปแล้ว กรุณาเปลี่ยน user ใหม่");
      }
    } catch (e) {}
  }

  Future<Null> registerThread() async {
    String url =
        "${MyConstant().domain}/aekchaifood/adduser.php?isAdd=true&name=$name&user=$user&password=$password&ChooseType=$chooseType";

    try {
      Response response = await Dio().get(url);
      print("res= $response");

      if (response.toString() == "true") {
        Navigator.pop(context);
      } else {
        normalDialog(context, "ไม่สามารถ สมัครได้ กรุณาลองใหม่อีกครั้ง");
      }
    } catch (e) {}
  }

  Widget riderRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: Row(
              children: <Widget>[
                Radio(
                  value: "Rider",
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(
                      () {
                        chooseType = value;
                      },
                    );
                  },
                ),
                Text(
                  "ผู้ส่งอาหาร",
                  style: TextStyle(color: MyStyle().darkColor),
                )
              ],
            ),
          ),
        ],
      );

  Widget shopRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: Row(
              children: <Widget>[
                Radio(
                  value: "Shop",
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(
                      () {
                        chooseType = value;
                      },
                    );
                  },
                ),
                Text(
                  "เจ้าของร้านอาหาร",
                  style: TextStyle(color: MyStyle().darkColor),
                )
              ],
            ),
          ),
        ],
      );

  Row showAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyStyle().showTitle(MyStyle().applicationName),
      ],
    );
  }

  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyStyle().showLogo(),
        ],
      );

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: TextField(
              onChanged: (value) => name = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.face,
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: "name :",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
          ),
        ],
      );

  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
          ),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
          ),
        ],
      );
}
