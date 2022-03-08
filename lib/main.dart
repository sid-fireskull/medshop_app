import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/theme/theme-data.dart';
import 'view/pages/app_sales_upload_widget.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Med Shop',
      theme: appTheme(context),
      home: const AppSalesUploadWidget(),
    );
  }
}
