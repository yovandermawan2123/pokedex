import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokedex_app/views/DetailView.dart';
import 'package:pokedex_app/views/HomeView.dart';
import 'views/SplashScreenView.dart';

main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    if (box.read('token') != null) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // home: Scaffold(
        //   // body: screens[index],
        //   // body: screens[index],
        // ),
        initialRoute: AppLinks.homePage,
        getPages: AppRoutes.pages,
      );
    } else {
      return FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                // home: Scaffold(
                //   // body: screens[index],
                //   // body: screens[index],
                // ),
                initialRoute: AppLinks.homePage,
                getPages: AppRoutes.pages,
              );
            }

            return SplashScreen();
          });
    }
  }
}

class AppRoutes {
  static final pages = [
    GetPage(name: AppLinks.splashPage, page: () => SplashScreen()),
    GetPage(name: AppLinks.homePage, page: () => Home()),
    GetPage(name: AppLinks.detailPage, page: () => Detail()),
  ];
}

class AppLinks {
  static const String splashPage = "/";
  static const String homePage = "/home";
  static const String detailPage = "/detail";
}
