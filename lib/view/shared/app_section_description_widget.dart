import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AppSectionDescriptionWidget extends StatelessWidget {
  String title;
  String desc;
  AppSectionDescriptionWidget({ this.title,  this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title.text.size(40).bold.black.make(),
          const SizedBox(
            height: 20,
          ),
          desc.text.size(18).gray600.make()
        ],
      ),
    );
  }
}
