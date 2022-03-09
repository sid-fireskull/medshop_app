import 'package:json_annotation/json_annotation.dart';
part 'monthlySalesInfo.g.dart';

@JsonSerializable()
class MonthlySalesInfo {
  int productAlias;
  String productName;
  double quantity;

  MonthlySalesInfo({this.productAlias, this.productName, this.quantity});

  factory MonthlySalesInfo.fromJson(Map<String, dynamic> jsonData) =>
      _$MonthlySalesInfoFromJson(jsonData);

  Map<String, dynamic> toJson() => _$MonthlySalesInfoToJson(this);
}
