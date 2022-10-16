import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_colors.dart';
import '../controller/app_controller.dart';
import '../model/carmodel.dart';

class EditScreen extends StatelessWidget {
  EditScreen({super.key});
  final AppController appC = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Estimater")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
            child: Obx(
          () => Column(
            children: [
              SizedBox(
                width: 100.w,
                child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children:
                        List.generate(appC.carDataList.length + 1, (index) {
                      if (appC.carDataList.length == index) {
                        return ChoiceChip(
                          padding: const EdgeInsets.all(5),
                          backgroundColor: AppColors.white,
                          label: Text(
                            "+",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: AppColors.blackGlaze),
                          ),
                          selected: false,
                          onSelected: (selected) {
                            appC.createNewCar();
                          },
                        );
                      }
                      CarModel carModel = appC.carDataList.elementAt(index);
                      if (appC.activeIndex.value == index) {
                        return Container(
                          decoration: BoxDecoration(color: AppColors.cyanLight),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 5, top: 5, right: 5, bottom: 5),
                                color: AppColors.cyanLight,
                                child: Bounce(
                                  duration: Duration(milliseconds: 110),
                                  onPressed: () {
                                    appC.deleteCar(index);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 20,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, right: 5, bottom: 5, left: 5),
                                color: AppColors.black,
                                child: Text(
                                  carModel.carsName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: AppColors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container(
                        decoration: BoxDecoration(color: AppColors.white),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: AppColors.white,
                              child: Bounce(
                                duration: Duration(milliseconds: 110),
                                onPressed: () {
                                  appC.activeIndex.value = index;
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 5, right: 5, bottom: 5, left: 5),
                                  color: AppColors.white,
                                  child: Text(carModel.carsName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color: AppColors.blackGlaze)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.cyanLight),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Code"),
                      Text("itemName"),
                      Text("itemPrice"),
                    ],
                  )),
              Expanded(
                  child: ListView.builder(
                      itemCount: appC.newCarItemList.isEmpty
                          ? 0
                          : appC.newCarItemList.length,
                      itemBuilder: ((context, index) {
                        CarItem itemList = appC.newCarItemList.elementAt(index);
                        return Bounce(
                          duration: Duration(milliseconds: 110),
                          onPressed: () {
                            appC.modifyItem(index);
                          },
                          child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(color: AppColors.white),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(itemList.itemCode),
                                  Text(itemList.itemName),
                                  Text(itemList.itemPrice),
                                ],
                              )),
                        );
                      }))),
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (appC.carDataList.isEmpty) {
            appC.createNewCar();
            return;
          }
          appC.addNewItem();
        },
        label: Obx(() => appC.carDataList.isEmpty
            ? const Text('Add Cars')
            : Text('Add Items')),
        icon: const Icon(Icons.add_comment),
        backgroundColor: AppColors.yellowDark,
      ),
    );
  }
}
