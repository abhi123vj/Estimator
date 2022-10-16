import 'dart:convert';
import 'dart:developer';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:hyundai_expense/constants/app_colors.dart';
import 'package:hyundai_expense/model/carmodel.dart';
import 'package:hyundai_expense/services/db_services.dart';

class AppController extends GetxController {
  @override
  void onInit() {
    activeIndex.listen((value) {
      totalAmnt.value = 0;
      newCarItemList.clear();
      carItemList.clear();
      if (carDataList.elementAt(value).carItems != null) {
        newCarItemList.addAll(carDataList.elementAt(value).carItems);
      }
    });
    viewObjectToDB();
    super.onInit();
  }

  RxList newCarItemList = [].obs;

  RxInt activeIndex = 0.obs;

  RxList<CarItem> carItemList = <CarItem>[].obs;
  RxList carList = [].obs;
  RxList carDataList = [].obs;
  RxDouble totalAmnt = 0.0.obs;
  List<CarModel> res = carModelFromJson("""[
    {
      "carsName": "Venue",
      "CarItems": [
        {"ItemName": "Air Filter", "ItemPrice": "2000.5", "ItemCode": "AF"},
        {"ItemName": "Ignition Coil", "ItemPrice": "2000.5", "ItemCode": "AF"}
      ]
    },
    {
      "carsName": "i10",
      "CarItems": [
        {"ItemName": "Air Filter", "ItemPrice": "2000.5", "ItemCode": "AF"}
      ]
    }
  ]""");
  String newData = """{
      "carsName": "i10000",
      "CarItems": [
        {"ItemName": "Air Filter", "ItemPrice": "2000.5", "ItemCode": "AF"},
          {"ItemName": "Air Filter 2", "ItemPrice": "2000.5", "ItemCode": "AF"}
      ]
    }""";

  addObjectToDB(CarModel carModelData) {
    DbServices.addToDB(carModelData);
  }

  viewObjectToDB() async {
    try {
      var carData = await DbServices.viewToDB();
      carDataList.clear();
      carDataList.addAll(carData.values);
      newCarItemList.clear();
      newCarItemList.addAll(carData.getAt(0).carItems);
    } catch (e) {
      log("error $e");
    }

    // CarModel carData = CarModel.fromJson(jsonDecode(newData));
    // DbServices.updateToDB(0, carData);
  }

  createNewCar() {
    final TextEditingController txtC = TextEditingController();
    Get.defaultDialog(
        content: SizedBox(
          child: TextField(
            controller: txtC,
            decoration: new InputDecoration.collapsed(hintText: 'Car Name'),
          ),
        ),
        onConfirm: () {
          CarModel carModelData = CarModel(carsName: txtC.text);
          DbServices.addToDB(carModelData);
          viewObjectToDB();
          Get.back();
        },
        backgroundColor: AppColors.yellowPale,
        radius: 10);
  }

  addNewItem() {
    final TextEditingController txtName = TextEditingController();
    final TextEditingController txtCode = TextEditingController();

    final TextEditingController txtPrice = TextEditingController();

    Get.defaultDialog(
        title: "Add New Item",
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtName,
                decoration:
                    new InputDecoration.collapsed(hintText: 'Item Name'),
              ),
              TextField(
                controller: txtCode,
                decoration:
                    new InputDecoration.collapsed(hintText: 'Item Code'),
              ),
              TextField(
                controller: txtPrice,
                decoration: new InputDecoration.collapsed(hintText: 'Price'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
                ], // Only numbers can be entered
              ),
            ],
          ),
        ),
        onConfirm: () {
          if (txtName.text.isEmpty ||
              txtCode.text.isEmpty ||
              txtPrice.text.isEmpty) {
            //! add notifiaction
            return;
          }
          CarModel carModelData = carDataList.elementAt(activeIndex.value);
          CarItem newCarItem = CarItem(
              itemName: txtName.text,
              itemPrice: txtPrice.text,
              itemCode: txtCode.text);
          carModelData.carItems ??= [];
          carModelData.carItems?.add(newCarItem);
          DbServices.updateToDB(activeIndex.value, carModelData);
          viewObjectToDB();
          Get.back();
        },
        buttonColor: AppColors.cyanDark,
        backgroundColor: AppColors.yellowPale,
        titleStyle: TextStyle(color: AppColors.blackGlaze),
        radius: 10);
  }

  selectNewItem(context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: AppColors.cyanDark,
            ),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: newCarItemList.length,
                itemBuilder: ((context, index) {
                  CarItem itemListData = newCarItemList.elementAt(index);
                  return Bounce(
                      duration: Duration(milliseconds: 110),
                      onPressed: () {
                        if (carItemList.contains(itemListData)) {
                          carItemList.remove(itemListData);
                          calculateTotal();
                          return;
                        }
                        carItemList.add(itemListData);
                        calculateTotal();
                      },
                      child: Obx(() => Container(
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: carItemList.contains(itemListData)
                                  ? AppColors.cyanLight
                                  : AppColors.yellowPale),
                          child: Text(itemListData.itemName))));
                })));
      },
    );
  }

  calculateTotal() {
    try {
      totalAmnt.value = 0;
      for (var element in carItemList) {
        var long2 = num.tryParse(element.itemPrice)?.toDouble();
        totalAmnt.value =
            (totalAmnt.value + long2! * element.qty).toPrecision(2);
        log(totalAmnt.value.toString());
      }
    } catch (e) {
      log("Calculatio Error");
    }
  }

  deleteCar(index) async {
    await DbServices.deleteOneFromDB(index);
    activeIndex.value = activeIndex.value == 0 ? 0 : activeIndex.value - 1;
    viewObjectToDB();
  }

  modifyItem(index) {
    final TextEditingController txtName = TextEditingController();
    final TextEditingController txtCode = TextEditingController();

    final TextEditingController txtPrice = TextEditingController();
    txtName.text = newCarItemList.elementAt(index).itemName;
    txtCode.text = newCarItemList.elementAt(index).itemCode;

    txtPrice.text = newCarItemList.elementAt(index).itemPrice;

    log(newCarItemList.toString());
    Get.defaultDialog(
        title: "Update",
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtName,
                decoration:
                    new InputDecoration.collapsed(hintText: 'Item Name'),
              ),
              TextField(
                controller: txtCode,
                decoration:
                    new InputDecoration.collapsed(hintText: 'Item Code'),
              ),
              TextField(
                controller: txtPrice,
                decoration: new InputDecoration.collapsed(hintText: 'Price'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
                ], // Only numbers can be entered
              ),
            ],
          ),
        ),
        onConfirm: () {
          if (txtName.text.isEmpty ||
              txtCode.text.isEmpty ||
              txtPrice.text.isEmpty) {
            //! add notifiaction
            return;
          }
          CarModel carModelData = carDataList.elementAt(activeIndex.value);
          CarItem newCarItem = CarItem(
              itemName: txtName.text,
              itemPrice: txtPrice.text,
              itemCode: txtCode.text);
          carModelData.carItems!.removeAt(index);
          carModelData.carItems!.insert(index, newCarItem);
          DbServices.updateToDB(activeIndex.value, carModelData);
          viewObjectToDB();
          Get.back();
        },
        confirm: ElevatedButton(
          onPressed: () {
            if (txtName.text.isEmpty ||
                txtCode.text.isEmpty ||
                txtPrice.text.isEmpty) {
              //! add notifiaction
              return;
            }
            CarModel carModelData = carDataList.elementAt(activeIndex.value);
            CarItem newCarItem = CarItem(
                itemName: txtName.text,
                itemPrice: txtPrice.text,
                itemCode: txtCode.text);
            carModelData.carItems!.removeAt(index);
            carModelData.carItems!.insert(index, newCarItem);
            DbServices.updateToDB(activeIndex.value, carModelData);
            viewObjectToDB();
            Get.back();
          },
          child: Text("Update"),
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyanDark,
              textStyle: TextStyle(fontWeight: FontWeight.w700)),
        ),
        cancel: ElevatedButton(
          onPressed: () {
            CarModel carModelData = carDataList.elementAt(activeIndex.value);
            carModelData.carItems!.removeAt(index);
            DbServices.updateToDB(activeIndex.value, carModelData);
            viewObjectToDB();
            Get.back();
          },
          child: Text("Delete"),
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redDark,
              textStyle: TextStyle(fontWeight: FontWeight.w700)),
        ),
        backgroundColor: AppColors.yellowPale,
        middleTextStyle: TextStyle(color: Colors.white),
        radius: 10);
  }
}
