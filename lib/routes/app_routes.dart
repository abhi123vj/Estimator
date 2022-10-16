import 'package:get/get.dart';
import 'package:hyundai_expense/screens/edit_screen.dart';

import '../screens/home_screen.dart';
class AppRoutes {
  static List<GetPage> pages = [

    GetPage(
      name: '/',
      page: () =>  HomeScreen(),
    ),
    GetPage(
      name: '/edit',
      page: () =>  EditScreen(),
    ),
  ];
}
