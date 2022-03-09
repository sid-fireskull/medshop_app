// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stockInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockInfo _$StockInfoFromJson(Map<String, dynamic> json) {
  return StockInfo(
    productAlias: json['productAlias'] as int,
    quantity: (json['quantity'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$StockInfoToJson(StockInfo instance) => <String, dynamic>{
      'productAlias': instance.productAlias,
      'quantity': instance.quantity,
    };
