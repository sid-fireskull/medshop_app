// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthlySalesInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlySalesInfo _$MonthlySalesInfoFromJson(Map<String, dynamic> json) {
  return MonthlySalesInfo(
    productAlias: json['productAlias'] as int,
    productName: json['productName'] as String,
    quantity: (json['quantity'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$MonthlySalesInfoToJson(MonthlySalesInfo instance) =>
    <String, dynamic>{
      'productAlias': instance.productAlias,
      'productName': instance.productName,
      'quantity': instance.quantity,
    };
