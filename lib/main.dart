import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hyundai_expense/model/carmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(CarModelAdapter());
  Hive.registerAdapter(CarItemAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        initialRoute: '/',
        getPages: AppRoutes.pages,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
      );
    });
  }
}
