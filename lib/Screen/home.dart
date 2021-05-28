import 'package:aekfooddelivery/Screen/main_rider.dart';
import 'package:aekfooddelivery/Screen/main_shop.dart';
import 'package:aekfooddelivery/Screen/main_user.dart';
import 'package:aekfooddelivery/Screen/signin.dart';
import 'package:aekfooddelivery/Screen/signup.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:aekfooddelivery/utility/normal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkPreferrence();
  }
  
  
  Future<Null> checkPreferrence() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String chooseType = preferences.getString("chooseType");
      print("Your choose Type = $chooseType");
      if (chooseType != null && chooseType.isNotEmpty) {
        if (chooseType == "User") {
          routeToService(MainUser());
        } else if (chooseType == "Shop") {
          routeToService(MainShop());
        } else if (chooseType == "Rider") {
          routeToService(MainRider());
        } else {
          normalDialog(context, "Error User Type");
        }
      }
    } catch (e) {}
  }

  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            signInMenu(),
            signUpMenu(),
          ],
        ),
      );

  ListTile signInMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text("Sign In"),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignIn());
        Navigator.push(context, route);
      },
    );
  }

  ListTile signUpMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text("Sign Up"),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignUp());
        Navigator.push(context, route);
      },
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration("Guest.jpg") ,
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text("Guest"),
      accountEmail: Text("Please LogIn"),
    );
  }
}
