import 'dart:convert';
import 'package:aekfooddelivery/Screen/add_food_menu.dart';
import 'package:aekfooddelivery/Screen/edit_food_menu.dart';
import 'package:aekfooddelivery/model/food_model.dart';
import 'package:aekfooddelivery/utility/my_constant.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListFoodMenuShop extends StatefulWidget {
  @override
  _ListFoodMenuShopState createState() => _ListFoodMenuShopState();
}

class _ListFoodMenuShopState extends State<ListFoodMenuShop> {
  bool status = true; //Have  data
  bool loadStatus = true; //Process Loan JSON
  List<FoodModel> foodModels = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    if (foodModels.length != 0) {
      foodModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString("id");
    // print("ID Shop = $idShop");

    String url =
        "${MyConstant().domain}/aekchaifood/getFoodWhereIdShop.php?isAdd=true&idShop=$idShop";
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != "null") {
        var result = json.decode(value.data);
        for (var map in result) {
          FoodModel foodModel = FoodModel.fromJson(map);
          setState(() {
            foodModels.add(foodModel);
          });
        }
      } else {
        setState(() {
          status = true;
        });
      }
    });

    // print("response ======>>>>>>$response");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        loadStatus ? MyStyle().showProgress() : showContent(),
        addMenuButton(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? shoListFood()
        : Center(
            child: Text("ยังไม่มีรายการอาหาร"),
          );
  }

  Widget shoListFood() => ListView.builder(
        itemCount: foodModels.length,
        itemBuilder: (context, index) => Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: Image.network(
                "${MyConstant().domain}${foodModels[index].pathImage}",
                fit: BoxFit.cover,
              ),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      foodModels[index].nameFood,
                      style: MyStyle().mainTitle,
                    ),
                    Text(
                      "ราคา ${foodModels[index].price} บาท",
                      style: MyStyle().mainH2Title,
                    ),
                    Text(
                      foodModels[index].detail,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => EditFoodMenu(foodModel: foodModels[index],),
                            );
                            Navigator.push(context, route)
                                .then((value) => readFoodMenu());
                          },
                          icon: Icon(Icons.edit, color: Colors.green),
                        ),
                        IconButton(
                          onPressed: () => deleteFood(foodModels[index]),
                          icon: Icon(Icons.delete, color: Colors.red),
                          color: Colors.red,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Future<Null> editFood(FoodModel foodModel) async {}

  Future<Null> deleteFood(FoodModel foodModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title:
            MyStyle().showTitleH2("คุณต้องการลบเมนู ${foodModel.nameFood} ?"),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String url =
                      "${MyConstant().domain}/aekchaifood/deletefoodWhereId.php?isAdd=true&id=${foodModel.id}";
                  await Dio().get(url).then((value) => readFoodMenu());
                },
                child: Text("ยืนยันการลบ"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("ยกเลิกการลบ"),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget addMenuButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(
                  bottom: 16.0,
                  right: 16.0,
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route =
                        MaterialPageRoute(builder: (context) => AddFoodMenu());
                    Navigator.push(context, route)
                        .then((value) => readFoodMenu());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
}
