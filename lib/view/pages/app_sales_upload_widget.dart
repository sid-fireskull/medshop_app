import 'package:flutter/material.dart';
import 'package:medshop/controller/sales_presenter.dart';
import 'package:medshop/entity/monthlySalesInfo.dart';
import 'package:medshop/utils/app_common_helper.dart';
import 'package:medshop/view/shared/app_centered_view_widget.dart';
import 'package:medshop/view/shared/app_nav_bar_widget.dart';
import 'package:medshop/view/shared/app_upload_button_widget.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AppSalesUploadWidget extends StatefulWidget {
  const AppSalesUploadWidget({Key key}) : super(key: key);

  @override
  _AppSalesUploadWidgetState createState() => _AppSalesUploadWidgetState();
}

class _AppSalesUploadWidgetState extends State<AppSalesUploadWidget> {
  SalesPresenter _salesPresenter;
  List<MonthlySalesInfo> _prevMonthSales;

  @override
  void initState() {
    super.initState();
    _salesPresenter = SalesPresenter();
    _getPrevMonthData();
  }

  _getPrevMonthData() {
    _salesPresenter.getPrevMonthSales().then((value) {
      setState(() {
        _prevMonthSales = value;
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
                      child: _prevMonthSales == null
                          ? Container()
                          : _buildGraph()),
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
