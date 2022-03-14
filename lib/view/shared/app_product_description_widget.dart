import 'package:flutter/material.dart';
import 'package:medshop/config/theme/app-colors.dart';
import 'package:medshop/entity/productInfo.dart';
import 'package:medshop/view/shared/app_edit_product_dialog.dart';
import 'package:velocity_x/velocity_x.dart';

class AppProductDescription extends StatelessWidget {
  ProductInfo product;
  Function func;

  AppProductDescription({this.product, this.func});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: "Product Information".text.bold.black.size(18).make(),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildTextWidget("Product Name", product.productName),
              _buildTextWidget("Marketing Group", product.marketingGroup),
              _buildTextWidget(
                  "Product Alias", product.productAlias.toString()),
              _buildTextWidget("Vendor", product.vendor),
            ],
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AppEditProductDialog(product, (val) {
                      func(val);
                    });
                  });
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTextWidget(String label, String desc) {
    desc ??= "Not Provided";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label.text.color(AppColors.secondaryColor).make(),
          const SizedBox(
            height: 4,
          ),
          desc.text.black.size(16).make()
        ],
      ),
    );
  }
}
