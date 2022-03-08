import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:medshop/entity/insertionSummaryInfo.dart';
import 'package:medshop/entity/productInfo.dart';
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
}
