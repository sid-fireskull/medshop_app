import 'package:json_annotation/json_annotation.dart';
part 'productInfo.g.dart';

@JsonSerializable()
class ProductInfo {
  int id;
  int productAlias;
  String productName;
  String marketingGroup;
  String vendor;
  String attr;
  String createdAt;
  String lastUpdatedAt;
  double stockQuantity;
  double reOrderQuantity;

  ProductInfo(
      {this.id,
      this.productAlias,
      this.productName,
      this.marketingGroup,
      this.vendor,
      this.attr,
      this.stockQuantity,
      this.reOrderQuantity,
      this.createdAt,
      this.lastUpdatedAt});

  factory ProductInfo.fromJson(Map<String, dynamic> jsonData) =>
      _$ProductInfoFromJson(jsonData);

  Map<String, dynamic> toJson() => _$ProductInfoToJson(this);
}
