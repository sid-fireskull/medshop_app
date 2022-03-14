import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:medshop/entity/insertionSummaryInfo.dart';
import 'package:medshop/entity/monthlySalesInfo.dart';
import 'package:medshop/entity/productInfo.dart';
import 'package:medshop/entity/stockInfo.dart';
import 'package:medshop/entity/weeklySales.dart';
import 'package:medshop/services/sales_service.dart';
import 'package:medshop/utils/app_common_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as webFile;

class SalesPresenter {
  SalesService _salesService;

  SalesPresenter() {
    _salesService = SalesService();
  }

  Future<List<WeeklySales>> getWeeklySales(int productAlias) {
    //return Future.value(getDemoSummaryData());
    return _salesService.getSalesSummary(productAlias);
  }

  Future<InsertionSummaryInfo> uploadSales() async {
    FilePickerResult result = await AppCommonHelper.pickCSV();
    if (result != null) {
      PlatformFile file = result.files.first;
      return _salesService.uploadSales(file);
    } else {
      AppCommonHelper.customToast("No File is Selected");
      return null;
    }
  }

  Future<List<MonthlySalesInfo>> getPrevMonthSales() {
    return _salesService.getPreviousMonthSales();
  }

  List<WeeklySales> getDemoSummaryData() {
    String txt =
        '[{"id":55,"productAlias":511,"week":2,"month":4,"year":2022,"invoiceCount":1,"quantity":12},{"id":55,"productAlias":511,"week":2,"month":3,"year":2022,"invoiceCount":2,"quantity":3},{"id":55,"productAlias":511,"week":2,"month":2,"year":2022,"invoiceCount":2,"quantity":4},{"id":55,"productAlias":511,"week":1,"month":1,"year":2022,"invoiceCount":2,"quantity":4},{"id":55,"productAlias":511,"week":2,"month":1,"year":2022,"invoiceCount":2,"quantity":4},{"id":55,"productAlias":511,"week":2,"month":0,"year":2022,"invoiceCount":2,"quantity":7},{"id":55,"productAlias":511,"week":3,"month":0,"year":2022,"invoiceCount":2,"quantity":17},{"id":55,"productAlias":511,"week":4,"month":0,"year":2022,"invoiceCount":1,"quantity":5},{"id":56,"productAlias":511,"week":5,"month":11,"year":2021,"invoiceCount":1,"quantity":1}]';
    var data = json.decode(txt);
    Iterable iterable = data;
    return iterable.map((e) => WeeklySales.fromJson(e)).toList();
  }

  void generateCSVLocally(List<ProductInfo> productList) async {
    String fileName =
        "reorder_${AppCommonHelper.formatDate(DateTime.now().toString())}.csv";
    List<List<dynamic>> rows = [[]];
    for (int i = 0; i < productList.length; i++) {
      List<dynamic> singleRow = [];
      singleRow.add(productList[i].productAlias);
      singleRow.add(productList[i].productName);
      singleRow.add(productList[i].marketingGroup);
      singleRow.add(productList[i].stockQuantity);
      singleRow.add(productList[i].reOrderQuantity);
      singleRow.add(productList[i].vendor);
      rows.add(singleRow);
      //   print(rows);
    }

    List<dynamic> headers = [
      "ProductAlias",
      "Products",
      "Marketing Group",
      "Stock Quantity",
      "Re-order Quantity",
      "Vendor"
    ];
    rows.insert(0, headers);
    String csv = const ListToCsvConverter().convert(rows);

    if (kIsWeb) {
      var blob = webFile.Blob([csv], 'text/plain', 'native');

      webFile.AnchorElement(
        href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
      )
        ..setAttribute("download", fileName)
        ..click();
    }
  }
}
