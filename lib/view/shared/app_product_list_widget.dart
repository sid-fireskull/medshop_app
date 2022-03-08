import 'package:flutter/material.dart';
import 'package:medshop/config/theme/app-colors.dart';
import 'package:medshop/entity/productInfo.dart';
import 'package:velocity_x/velocity_x.dart';

class AppProductListWidget extends StatefulWidget {
  List<ProductInfo> products;
  Function onSelect;

  AppProductListWidget(this.products, {this.onSelect});

  @override
  State<AppProductListWidget> createState() => _AppProductListWidgetState();
}

class _AppProductListWidgetState extends State<AppProductListWidget> {
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      width: 350,
      child: ListView.separated(
        itemBuilder: (context, index) {
          ProductInfo prod = widget.products[index];
          return InkWell(
            onTap: () {
              setState(() {
              selectedIndex = index;
              widget.onSelect(index);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? AppColors.secondaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  prod.productName.text.semiBold
                      .color(
                          selectedIndex != index ? Colors.black : Colors.white)
                      .size(16)
                      .make(),
                  ("Product Alias: ${prod.productAlias}")
                      .text
                      .color(
                          selectedIndex != index ? Colors.grey.shade600 : Colors.white70)
                      .size(12)
                      .make(),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 8,
          );
        },
        itemCount: widget.products?.length ?? 0,
      ),
    );
  }
}
