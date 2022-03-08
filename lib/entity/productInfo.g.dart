// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductInfo _$ProductInfoFromJson(Map<String, dynamic> json) {
  return ProductInfo(
    id: json['id'] as int,
    productAlias: json['productAlias'] as int,
    productName: json['productName'] as String,
    marketingGroup: json['marketingGroup'] as String,
    vendor: json['vendor'] as String,
    attr: json['attr'] as String,
    stockQuantity: json['stockQuantity'] as int,
    reOrderQuantity: json['reOrderQuantity'] as int,
    createdAt: json['createdAt'] as String,
    lastUpdatedAt: json['lastUpdatedAt'] as String,
  );
}

Map<String, dynamic> _$ProductInfoToJson(ProductInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productAlias': instance.productAlias,
      'productName': instance.productName,
      'marketingGroup': instance.marketingGroup,
      'vendor': instance.vendor,
      'attr': instance.attr,
      'createdAt': instance.createdAt,
      'lastUpdatedAt': instance.lastUpdatedAt,
      'stockQuantity': instance.stockQuantity,
      'reOrderQuantity': instance.reOrderQuantity,
    };
