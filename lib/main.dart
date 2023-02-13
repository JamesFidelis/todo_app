import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:todo_app/Service/ThemeServices.dart';
import 'package:todo_app/ui/homepage.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:get_storage/get_storage.dart';
import 'db/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do App',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      home: HomePage(),
    );
  }
}
