import 'package:flutter/material.dart';
import 'package:medshop/config/theme/app-colors.dart';

class CustomLoaderWidget extends StatelessWidget {
  const CustomLoaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }
}
