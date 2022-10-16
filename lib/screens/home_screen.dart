import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hyundai_expense/constants/app_colors.dart';
import 'package:hyundai_expense/model/carmodel.dart';
import 'package:sizer/sizer.dart';
import '../controller/app_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final AppController appC = Get.put(AppController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Estimator"),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed("/edit");
              },
              icon: Icon(Icons.edit,color: AppColors.yellowPale,))
        ],
      ),
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
                    children: List.generate(appC.carDataList.length, (index) {
                      CarModel carModel = appC.carDataList.elementAt(index);

                      return ChoiceChip(
                        padding: const EdgeInsets.all(5),
                        backgroundColor: AppColors.white,
                        label: Text(
                          carModel.carsName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.blackGlaze),
                        ),
                        selected: appC.activeIndex.value == index,
                        onSelected: (selected) {
                          appC.activeIndex.value = index;
                          //appC.addObjectToDB(carModel);
                          //appC.viewObjectToDB();
                        },
                      );
                    })),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Obx(() => Text(
                      "Total : ₹${appC.totalAmnt}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w700, fontSize: 20),
                    )),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: appC.carItemList.length,
                      itemBuilder: ((context, index) {
                        CarItem itemList = appC.carItemList.elementAt(index);
                        return Container(
                            padding: EdgeInsets.only(top: 10),
                            margin: EdgeInsets.only(bottom: 10),
                            decoration:
                                BoxDecoration(color: AppColors.blackGlaze),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  itemList.itemName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.white),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration:
                                      BoxDecoration(color: AppColors.white),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                itemList.qty = itemList.qty - 1;
                                                if (itemList.qty <= 0) {
                                                  itemList.qty =
                                                      itemList.qty + 1;
                                                  appC.carItemList
                                                      .remove(itemList);
                                                }

                                                appC.calculateTotal();
                                                appC.carItemList.refresh();
                                              },
                                              icon: Icon(Icons.remove)),
                                          Text(
                                            appC.carItemList
                                                .elementAt(index)
                                                .qty
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: AppColors.black),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                itemList.qty = itemList.qty + 1;
                                                appC.carItemList.refresh();
                                                appC.calculateTotal();
                                                log(itemList.qty.toString());
                                              },
                                              icon: Icon(Icons.add))
                                        ],
                                      ),
                                      Text(
                                       "₹${itemList.itemPrice}" ,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ));
                      }))),
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appC.selectNewItem(context);
        },
        backgroundColor: AppColors.yellowDark,
        child: const Icon(Icons.navigation),
      ),
    );
  }
}
