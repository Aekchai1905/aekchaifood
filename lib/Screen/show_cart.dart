import 'package:aekfooddelivery/model/cart_model.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:aekfooddelivery/utility/sqllite_helper.dart';
import 'package:flutter/material.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<CartModel> cartModels = List.empty(growable: true);
  int total = 0;

  @override
  void initState() {
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFromSQLite();


    for (var model in object) {
      String sumString = model.sum;
      int sumint = int.parse(sumString);
      total = total + sumint;

    }

    setState(() {
      cartModels = object;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ตะกร้าของฉัน"),
      ),
      body: cartModels.length == 0 ? MyStyle().showProgress() : buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          buildNameShop(),
          buildHeadTitle(),
          buildListFood(),
          Divider(),
          buildTotal(),
        ],
      ),
    );
  }

  Widget buildTotal() => Row(
        children: [
          Expanded(flex: 5, child: Row(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyStyle().showTitleH2("Total :") ,
            ],
          )),
          Expanded(flex: 1, child: MyStyle().showTitleH3Red(total.toString()) ),
        ],
      );

  Widget buildNameShop() {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: [
          Row(
            children: [
              MyStyle().showTitleH2("ร้าน${cartModels[0].nameShop}"),
            ],
          ),
          Row(
            children: [
              MyStyle()
                  .showTitleH3("ระยะทาง = ${cartModels[0].distance} กิโลเมตร"),
            ],
          ),
          Row(
            children: [
              MyStyle()
                  .showTitleH3("ค่าขนส่ง = ${cartModels[0].transport} บาท"),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeadTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade400),
      child: Row(
        children: [
          Expanded(flex: 3, child: MyStyle().showTitleH3("รายการอาหาร")),
          Expanded(flex: 1, child: MyStyle().showTitleH3("ราคา")),
          Expanded(flex: 1, child: MyStyle().showTitleH3("จำนวน")),
          Expanded(flex: 1, child: MyStyle().showTitleH3("ยอดรวม")),
        ],
      ),
    );
  }

  Widget buildListFood() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(cartModels[index].nameFood),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].price),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].amount),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].sum),
            )
          ],
        ),
      );
}
