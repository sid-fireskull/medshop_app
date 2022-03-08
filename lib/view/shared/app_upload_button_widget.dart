import 'package:flutter/material.dart';
import 'package:medshop/config/theme/app-colors.dart';
import 'package:velocity_x/velocity_x.dart';

class AppUploadButtonWidget extends StatelessWidget {
  String buttonLabel;
  Function onTap;
  AppUploadButtonWidget(
      { this.buttonLabel,  this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        child: buttonLabel.text.size(16).bold.white.make(),
        decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
