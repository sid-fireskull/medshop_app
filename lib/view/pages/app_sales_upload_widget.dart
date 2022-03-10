import 'package:flutter/material.dart';
import 'package:medshop/controller/product_presenter.dart';
import 'package:medshop/controller/sales_presenter.dart';
import 'package:medshop/entity/monthlySalesInfo.dart';
import 'package:medshop/entity/productInfo.dart';
import 'package:medshop/utils/app_common_helper.dart';
import 'package:medshop/view/shared/app_centered_view_widget.dart';
import 'package:medshop/view/shared/app_nav_bar_widget.dart';
import 'package:medshop/view/shared/app_section_description_widget.dart';
import 'package:medshop/view/shared/app_upload_button_widget.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:velocity_x/velocity_x.dart';

class AppSalesUploadWidget extends StatefulWidget {
  const AppSalesUploadWidget({Key key}) : super(key: key);

  @override
  _AppSalesUploadWidgetState createState() => _AppSalesUploadWidgetState();
}

class _AppSalesUploadWidgetState extends State<AppSalesUploadWidget> {
  SalesPresenter _salesPresenter;
  ProductPresenter _productPresenter;
  List<MonthlySalesInfo> _prevMonthSales;
  Map<int, ProductInfo> prodMapper;
  int len = 0;

  @override
  void initState() {
    super.initState();
    _salesPresenter = SalesPresenter();
    _productPresenter = ProductPresenter();
    _prevMonthSales = [];
    prodMapper = {};
    _productPresenter.getAllProducts().then((val) {
      if (val != null) {
        for (var element in val) {
          prodMapper[element.productAlias] = element;
        }
        _getPrevMonthData();
      }
    });
  }

  _getPrevMonthData() {
    _salesPresenter.getPrevMonthSales().then((value) {
      setState(() {
        _prevMonthSales = value;
        if (_prevMonthSales.isNotEmpty && _prevMonthSales.length < 4) {
          len = _prevMonthSales.length;
        } else if (_prevMonthSales.isEmpty) {
          len = 0;
        } else {
          len = 4;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppCenteredViewWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppNavBarWidget(
              active: 2,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _prevMonthSales == null ||
                            _prevMonthSales.length <= 0
                        ? AppSectionDescriptionWidget(
                            title: "Upload Sales",
                            desc: "Top performing products will appear here")
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 100),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: "Top Performing Products"
                                    .text
                                    .bold
                                    .size(18)
                                    .black
                                    .make(),
                              ),
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8,
                                          mainAxisExtent: 120,
                                          crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    MonthlySalesInfo sale =
                                        _prevMonthSales[index];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          prodMapper[sale.productAlias]
                                              .productName
                                              .selectableText
                                              .black
                                              .bold
                                              .size(16)
                                              .make(),
                                          "Product Alias: ${sale.productAlias}"
                                              .selectableText
                                              .gray600
                                              .bold
                                              .size(15)
                                              .make(),
                                          Expanded(child: Container()),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: sale.quantity
                                                .toString()
                                                .text
                                                .size(30)
                                                .bold
                                                .color(Colors.grey.shade300)
                                                .make(),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: len ?? 0,
                                ),
                              ),
                            ],
                          ),
                  ),
                  Expanded(
                    child: Center(
                      child: AppUploadButtonWidget(
                          buttonLabel: "Upload Sales",
                          onTap: () {
                            _salesPresenter.uploadSales().then((value) {
                              if (value != null) {
                                //  _getData();
                                AppCommonHelper.customToast(
                                    "Products Uploaded Successfully\nTotal Updated Records: ${value.totalUpdatedRecord}");
                              }
                            });
                          }),
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

  dynamic _getSeries() {
    return [
      charts.Series(
        domainFn: (MonthlySalesInfo clickData, _) => clickData.productName,
        measureFn: (MonthlySalesInfo clickData, _) => clickData.quantity,
        colorFn: (MonthlySalesInfo clickData, _) => charts.Color(
            r: Colors.green.red,
            g: Colors.green.green,
            b: Colors.green.blue,
            a: Colors.green.value),
        id: 'MonthlySales',
        data: _prevMonthSales,
      ),
    ];
  }

  Widget _buildGraph() {
    return Container(
      height: 251,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: charts.BarChart(
        _getSeries(),
        animate: true,
      ),
    );
  }
}
