import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:hyundai_expense/model/carmodel.dart';

class DbServices {
  static addToDB(CarModel carModelData) async {
    var carData = await Hive.openBox('carData');
    carData.add(carModelData);
  }

  static Future viewToDB() async {
    var carData = await Hive.openBox('carData');
    log(carData.values.toString());
    return carData;
  }

  static deletwDB() async {
    await Hive.openBox('carData');

    Hive.box('carData').clear();
  }

  static updateToDB(int index, CarModel carModelData) async {
    var carData = await Hive.openBox('carData');
    await carData.putAt(index, carModelData);
    log(carData.keys.toString());
  }

  static deleteOneFromDB(int index) async {
    var carData = await Hive.openBox('carData');

    await carData.delete(carData.keys.elementAt(index));
    log(carData.keys.toString());
  }
}
