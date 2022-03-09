import 'package:json_annotation/json_annotation.dart';
part 'stockInfo.g.dart';

@JsonSerializable()
class StockInfo {
  int productAlias;
  double quantity;

  StockInfo({this.productAlias, this.quantity});

  factory StockInfo.fromJson(Map<String, dynamic> jsonData) =>
      _$StockInfoFromJson(jsonData);

  Map<String, dynamic> toJson() => _$StockInfoToJson(this);

}
