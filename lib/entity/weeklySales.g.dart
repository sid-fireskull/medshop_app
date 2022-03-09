// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weeklySales.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklySales _$WeeklySalesFromJson(Map<String, dynamic> json) {
  return WeeklySales(
    id: json['id'] as int,
    productAlias: json['productAlias'] as int,
    week: json['week'] as int,
    month: json['month'] as int,
    year: json['year'] as int,
    invoiceCount: json['invoiceCount'] as int,
    quantity: (json['quantity'] as num)?.toDouble(),
    createdAt: json['createdAt'] as String,
    lastUpdatedAt: json['lastUpdatedAt'] as String,
  );
}

Map<String, dynamic> _$WeeklySalesToJson(WeeklySales instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productAlias': instance.productAlias,
      'week': instance.week,
      'month': instance.month,
      'year': instance.year,
      'invoiceCount': instance.invoiceCount,
      'quantity': instance.quantity,
      'createdAt': instance.createdAt,
      'lastUpdatedAt': instance.lastUpdatedAt,
    };
