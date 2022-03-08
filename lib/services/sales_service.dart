import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:medshop/entity/insertionSummaryInfo.dart';
import 'package:medshop/entity/weeklySales.dart';
import 'package:medshop/utils/api_client.dart';

class SalesService extends ApiClient {
  final String _uploadSalesUrl = "/sales";
  final String _salesSummaryUrl = "/sales/summary";

  SalesService();

  Future<InsertionSummaryInfo> uploadSales(PlatformFile platformFile) {
    return multipartFileUpload(_uploadSalesUrl, platformFile).then((response) {
      if (response != null && response.statusCode == 200) {
        var result = json.decode(response.body);
        return InsertionSummaryInfo.fromJson(result);
      } else {
        return null;
      }
    });
  }

  Future<List<WeeklySales>> getSalesSummary(int productAlias) {
    return getRequest(_salesSummaryUrl, "/$productAlias").then((response) {
      if (response != null) {
        var result = json.decode(response.body);
        if (result != null) {
          Iterable iterable = result;
          return iterable.map((e) => WeeklySales.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    });
  }
}
