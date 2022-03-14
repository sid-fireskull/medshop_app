import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:medshop/entity/insertionSummaryInfo.dart';
import 'package:medshop/entity/productInfo.dart';
import 'package:medshop/entity/stockInfo.dart';
import 'package:medshop/services/product_service.dart';
import 'package:medshop/utils/app_common_helper.dart';

class ProductPresenter {
  ProductService productService;

  ProductPresenter() {
    productService = ProductService();
  }

  Future<List<ProductInfo>> getAllProducts() {
    return productService.getAllProducts();
  }

  Future<InsertionSummaryInfo> uploadProducts() async {
    FilePickerResult result = await AppCommonHelper.pickCSV();
    if (result != null) {
      PlatformFile file = result.files.first;
      return productService.uploadProducts(file);
    } else {
      AppCommonHelper.customToast("No File is Selected");
      return null;
    }
  }

  Future<Map<int, String>> uploadStocks() async {
    FilePickerResult result = await AppCommonHelper.pickCSV();
    if (result != null) {
      PlatformFile file = result.files.first;
      List<StockInfo> stocks = await productService.uploadStocks(file);
      Map<int, String> maps = {};
      for (var element in stocks) {
        maps[element.productAlias] = element.quantity.toString();
      }
      return maps;
    } else {
      AppCommonHelper.customToast("No File is Selected");
      return null;
    }
  }

  Future<bool> saveProduct(ProductInfo prod) {
    if (prod.id == null || prod.id <= 0) {
      return productService.addProduct(prod);
    } else {
      return productService.updateProduct(prod);
    }
  }
}
