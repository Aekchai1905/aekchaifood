import 'dart:convert';
import 'dart:ui';
import 'package:aekfooddelivery/model/cart_model.dart';
import 'package:aekfooddelivery/model/food_model.dart';
import 'package:aekfooddelivery/model/user_model.dart';
import 'package:aekfooddelivery/utility/my_api.dart';
import 'package:aekfooddelivery/utility/my_constant.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:aekfooddelivery/utility/normal_dialog.dart';
import 'package:aekfooddelivery/utility/sqllite_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:toast/toast.dart';

class ShowMenuFood extends StatefulWidget {
  final UserModel userModel;

  ShowMenuFood({Key key, this.userModel}) : super(key: key);

  @override
  _ShowMenuFoodState createState() => _ShowMenuFoodState();
}

class _ShowMenuFoodState extends State<ShowMenuFood> {
  UserModel userModel;
  String idShop;
  List<FoodModel> foodModels = List.empty(growable: true);
  int amount = 1;
  double lat1, lng1, lat2, lng2;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    readFoodMenu();
    findLocation();
  }

  Future<Null> findLocation() async {
    LocationData locationData = await MyAPI().findLocationData();
    lat1 = locationData.latitude;
    lng1 = locationData.longitude;
    // print("Lat1 = $lat1 ,Lng1= $lng1");
    // if (lat1 == null) {
    //   location.onLocationChanged.listen((event) {
    //     lat1 = event.latitude;
    //     lng1 = event.longitude;
    //     print("Lat1 = $lat1 ,Lng1= $lng1");
    //   });
    // }
  }

  Future<Null> readFoodMenu() async {
    idShop = userModel.id;
    String url =
        "${MyConstant().domain}/aekchaifood/getFoodWhereIdShop.php?isAdd=true&idShop=${userModel.id}";
    Response response = await Dio().get(url);
    // print("res ====>$response");

    var result = json.decode(response.data);
    // print("result = $result");

    for (var map in result) {
      FoodModel foodModel = FoodModel.fromJson(map);
      setState(() {
        foodModels.add(foodModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return foodModels.length == 0
        ? MyStyle().showProgress()
        : ListView.builder(
            itemCount: foodModels.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                // print("You click index = $index");
                amount = 1;
                confirmOrder(index);
              },
              child: Row(
                children: [
                  showFoodImage(context, index),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // MyStyle().showTitle(foodModels[index].nameFood),
                        Row(
                          children: [
                            Text(
                              foodModels[index].nameFood,
                              style: MyStyle().mainTitle,
                            ),
                          ],
                        ),
                        Text("${foodModels[index].price} บาท",
                            style: TextStyle(
                                fontSize: 30,
                                color: MyStyle().darkColor,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 8.0,
                              child: Text(foodModels[index].detail),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Container showFoodImage(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      width: MediaQuery.of(context).size.width * 0.5 - 16.0,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
            image: NetworkImage(
                "${MyConstant().domain}${foodModels[index].pathImage}"),
            fit: BoxFit.cover),
      ),
    );
  }

  Future<Null> confirmOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      foodModels[index].nameFood,
                      style: MyStyle().mainH2Title,
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 180,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: NetworkImage(
                                "${MyConstant().domain}${foodModels[index].pathImage}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              amount++;
                            });
                          },
                          icon: Icon(
                            Icons.add_circle,
                            size: 36,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          amount.toString(),
                          style: MyStyle().mainTitle,
                        ),
                        IconButton(
                          onPressed: () {
                            if (amount > 1) {
                              setState(() {
                                amount--;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.remove_circle,
                            size: 36,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 110,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // print("Order ${foodModels[index].nameFood} Amount = $amount");

                              addOrderToCart(index);
                            },
                            child: Text("Order"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                // onPrimary: Colors.white,
                                // shadowColor: Colors.red,
                                // elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                        ),
                        Container(
                          width: 110,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                // onPrimary: Colors.white,
                                // shadowColor: Colors.red,
                                // elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
    );
  }

  Future<Null> addOrderToCart(int index) async {
    String nameShop = userModel.nameShop;
    String idFood = foodModels[index].id;
    String nameFood = foodModels[index].nameFood;
    String price = foodModels[index].price;
    int priceInt = int.parse(price);
    int sumInt = priceInt * amount;

    lat2 = double.parse(userModel.lat);
    lng2 = double.parse(userModel.lng);
    double distance = MyAPI().calculateDistance(lat1, lng1, lat2, lng2);

    var myFormat = NumberFormat("#,##0.0#", "en_US");
    String distanceString = myFormat.format(distance);

    int transport = MyAPI().calculateTransport(distance);
    // String distance = foodModels[index].
    print("idShop = $idShop ,nameShop = $nameShop");
    print(
        "idFood = $idFood ,nameFood = $nameFood ,Price = $price,Qty Order =$amount ,Total Amount = $sumInt,distance =$distanceString ,transport = $transport");
    Map<String, dynamic> map = Map();

    map["idShop"] = idShop;
    map["nameShop"] = nameShop;
    map["idFood"] = idFood;
    map["nameFood"] = nameFood;
    map["price"] = price;
    map["amount"] = amount.toString();
    map["sum"] = sumInt.toString();
    map["distance"] = distance.toString();
    map["transport"] = transport.toString();
    print("Map =====>${map.toString()}");

    CartModel cartModel = CartModel.fromJson(map);

    var object = await SQLiteHelper().readAllDataFromSQLite();
    print("object lenght = ${object.length}");

    if (object.length == 0) {
      await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
        // print("Insert Success.");
        showToast("Insert Success");
      });
    } else {
      String idShopSQLite = object[0].idShop;
      print("id Shop = $idShopSQLite");
      if (idShopSQLite == idShop) {
        await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
          print("Insert Success.");
          showToast("Insert Success");
        });
      } else {
        normalDialog(context,
            "ตะกร้ามีรายการอาหารของร้าน ${object[0].nameShop} อยู่ กรุณาซื้อจากร้านนี้ให้จบก่อน");
      }
    }
  }

  void showToast(String string) {
    Toast.show(
      string,
      context,
      duration: Toast.LENGTH_LONG,
    );
  }
}
