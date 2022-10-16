import 'package:hive/hive.dart';

import 'dart:convert';

part 'carmodel.g.dart';

List<CarModel> carModelFromJson(String str) =>
    List<CarModel>.from(json.decode(str).map((x) => CarModel.fromJson(x)));

@HiveType(typeId: 1)
class CarModel {
  CarModel({
    required this.carsName,
    this.carItems,
  });
  @HiveField(0)
  String carsName;
  @HiveField(1)
  List<CarItem>? carItems;

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        carsName: json["carsName"] == null ? null : json["carsName"],
        carItems: json["CarItems"] == null
            ? null
            : List<CarItem>.from(
                json["CarItems"].map((x) => CarItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "carsName": carsName == null ? null : carsName,
        "CarItems": carItems == null
            ? null
            : List<dynamic>.from(carItems!.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 2)
class CarItem {
  CarItem({
    required this.itemName,
    required this.itemPrice,
    required this.itemCode,
  });

  @HiveField(0)
  String itemName;
  @HiveField(1)
  String itemPrice;
  @HiveField(2)
  String itemCode;
  int qty = 1;
  factory CarItem.fromJson(Map<String, dynamic> json) => CarItem(
        itemName: json["ItemName"] == null ? null : json["ItemName"],
        itemPrice: json["ItemPrice"] == null ? null : json["ItemPrice"],
        itemCode: json["ItemCode"] == null ? null : json["ItemCode"],
      );

  Map<String, dynamic> toJson() => {
        "ItemName": itemName == null ? null : itemName,
        "ItemPrice": itemPrice == null ? null : itemPrice,
        "ItemCode": itemCode == null ? null : itemCode,
      };
}
