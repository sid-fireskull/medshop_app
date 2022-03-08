import 'package:flutter/material.dart';
import 'package:medshop/config/app_assets_config.dart';
import 'package:medshop/config/theme/app-colors.dart';
import 'package:medshop/utils/app_common_helper.dart';
import 'package:medshop/view/pages/app_products_widget.dart';
import 'package:medshop/view/pages/app_reorder_widget.dart';
import 'package:medshop/view/pages/app_sales_upload_widget.dart';
import "package:velocity_x/velocity_x.dart";

class AppNavBarWidget extends StatelessWidget {
  int active;
  AppNavBarWidget({this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Image.asset(AppAssetsConfig.logo),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  AppCommonHelper.pushReplacement(context, AppProductWidget());
                },
                child: _NavBarItem(
                  "Products",
                  active: active == 1,
                ),
              ),
              const SizedBox(
                width: 60,
              ),
              InkWell(
                  onTap: () {
                    AppCommonHelper.pushReplacement(
                        context, AppSalesUploadWidget());
                  },
                  child: _NavBarItem("Sales", active: active == 2)),
              const SizedBox(
                width: 60,
              ),
              InkWell(
                  onTap: () {
                    AppCommonHelper.pushReplacement(
                        context, AppReorderWidget());
                  },
                  child: _NavBarItem("Re-Order", active: active == 3))
            ],
          )
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  bool active;

  _NavBarItem(this.title, {this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: title.text
            .size(18)
            .semiBold
            .color(active ? AppColors.secondaryColor : Colors.black)
            .make());
  }
}
