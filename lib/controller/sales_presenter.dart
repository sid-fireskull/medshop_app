import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:medshop/entity/insertionSummaryInfo.dart';
import 'package:medshop/entity/weeklySales.dart';
import 'package:medshop/services/sales_service.dart';
import 'package:medshop/utils/app_common_helper.dart';

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

  List<WeeklySales> getDemoSummaryData() {
    String txt =
        '[{"id":55,"productAlias":511,"week":2,"month":4,"year":2022,"invoiceCount":1,"quantity":12},{"id":55,"productAlias":511,"week":2,"month":3,"year":2022,"invoiceCount":2,"quantity":3},{"id":55,"productAlias":511,"week":2,"month":2,"year":2022,"invoiceCount":2,"quantity":4},{"id":55,"productAlias":511,"week":1,"month":1,"year":2022,"invoiceCount":2,"quantity":4},{"id":55,"productAlias":511,"week":2,"month":1,"year":2022,"invoiceCount":2,"quantity":4},{"id":55,"productAlias":511,"week":2,"month":0,"year":2022,"invoiceCount":2,"quantity":7},{"id":55,"productAlias":511,"week":3,"month":0,"year":2022,"invoiceCount":2,"quantity":17},{"id":55,"productAlias":511,"week":4,"month":0,"year":2022,"invoiceCount":1,"quantity":5},{"id":56,"productAlias":511,"week":5,"month":11,"year":2021,"invoiceCount":1,"quantity":1}]';
    var data = json.decode(txt);
    Iterable iterable = data;
    return iterable.map((e) => WeeklySales.fromJson(e)).toList();
  }
}
