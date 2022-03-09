import 'package:flutter/material.dart';
import 'package:medshop/config/theme/app-colors.dart';
import 'package:medshop/controller/product_presenter.dart';
import 'package:medshop/entity/productInfo.dart';
import 'package:medshop/utils/app_common_helper.dart';
import 'package:medshop/view/shared/app_centered_view_widget.dart';
import 'package:medshop/view/shared/app_nav_bar_widget.dart';
import 'package:medshop/view/shared/app_product_description_widget.dart';
import 'package:medshop/view/shared/app_product_list_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class AppProductWidget extends StatefulWidget {
  const AppProductWidget({Key key}) : super(key: key);

  @override
  State<AppProductWidget> createState() => _AppProductWidgetState();
}

class _AppProductWidgetState extends State<AppProductWidget> {
  ProductPresenter _productPresenter;
  List<ProductInfo> _products;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _productPresenter = ProductPresenter();
    _getData();
  }

  void _getData() {
    _selectedIndex = -1;
    _productPresenter.getAllProducts().then((value) {
      setState(() {
        _products = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppCenteredViewWidget(
        child: Column(
          children: [
            AppNavBarWidget(active: 1),
            Expanded(
              child: Row(
                children: [
                  _products == null
                      ? Container(
                          width: 350,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        )
                      : AppProductListWidget(_products, onSelect: (val) {
                          setState(() {
                            _selectedIndex = val;
                          });
                        }),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Expanded(
                            child: _selectedIndex < 0
                                ? Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 20),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: "No Product is Selected"
                                        .text
                                        .size(14)
                                        .make(),
                                  )
                                : AppProductDescription(
                                    product: _products[_selectedIndex],
                                  ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.cloud_upload_sharp),
                                  label: const Text('Upload Product CSV'),
                                  onPressed: () {
                                    _productPresenter
                                        .uploadProducts()
                                        .then((value) {
                                      if (value != null) {
                                        _getData();
                                        AppCommonHelper.customToast(
                                            "Products Uploaded Successfully\nTotal Updated Records: ${value.totalUpdatedRecord}");
                                      }
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors.secondaryColor),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Product'),
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors.secondaryColor),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
