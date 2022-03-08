import 'package:flutter/material.dart';
import 'package:medshop/controller/sales_presenter.dart';
import 'package:medshop/view/shared/app_centered_view_widget.dart';
import 'package:medshop/view/shared/app_nav_bar_widget.dart';
import 'package:medshop/view/shared/app_section_description_widget.dart';
import 'package:medshop/view/shared/app_upload_button_widget.dart';

class AppSalesUploadWidget extends StatefulWidget {
  const AppSalesUploadWidget({Key key}) : super(key: key);

  @override
  _AppSalesUploadWidgetState createState() => _AppSalesUploadWidgetState();
}

class _AppSalesUploadWidgetState extends State<AppSalesUploadWidget> {
  SalesPresenter _salesPresenter;

  @override
  void initState() {
    super.initState();
    _salesPresenter = SalesPresenter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppCenteredViewWidget(
        child: Column(
          children: [
            AppNavBarWidget(
              active: 2,
            ),
            Expanded(
              child: Row(
                children: [
                  AppSectionDescriptionWidget(
                      title: "Flutter Basic Widget",
                      desc:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"),
                  Expanded(
                    child: Center(
                      child: AppUploadButtonWidget(
                          buttonLabel: "Upload Sales",
                          onTap: () {
                            _salesPresenter.uploadSales();
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
}
