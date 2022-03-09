import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:medshop/entity/insertionSummaryInfo.dart';
import 'package:medshop/entity/productInfo.dart';
import 'package:medshop/entity/stockInfo.dart';
import 'package:medshop/utils/api_client.dart';

class ProductService extends ApiClient {
  final String _allProductsUrl = "/products";
  final String _uploadProductsUrl = "/product";
  final String _uploadStockUrl = "/stock";

  ProductService();

  Future<List<ProductInfo>> getAllProducts() {
    return getRequest(_allProductsUrl, "").then((response) {
      if (response != null) {
        var result = json.decode(response.body);
        if (result != null) {
          Iterable iterable = result;
          return iterable.map((e) => ProductInfo.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    });
  }

  Future<InsertionSummaryInfo> uploadProducts(PlatformFile platformFile) {
    return multipartFileUpload(_uploadProductsUrl, platformFile)
        .then((response) {
      if (response != null && response.statusCode == 200) {
        var result = json.decode(response.body);
        return InsertionSummaryInfo.fromJson(result);
      } else {
        return null;
      }
    });
  }

  Future<List<StockInfo>> uploadStocks(PlatformFile platformFile) {
    return multipartFileUpload(_uploadStockUrl, platformFile).then((response) {
      if (response != null && response.statusCode == 200) {
        Iterable iterable = json.decode(response.body);
        return iterable.map((e) => StockInfo.fromJson(e)).toList();
      } else {
        return [];
      }
    });
  }
}
