import 'package:json_annotation/json_annotation.dart';
part 'weeklySales.g.dart';

@JsonSerializable()
class WeeklySales {
  int id;
  int productAlias;
  int week;
  int month;
  int year;
  int invoiceCount;
  double quantity;
  String createdAt;
  String lastUpdatedAt;

  WeeklySales(
      {this.id,
      this.productAlias,
      this.week,
      this.month,
      this.year,
      this.invoiceCount,
      this.quantity,
      this.createdAt,
      this.lastUpdatedAt});

  factory WeeklySales.fromJson(Map<String, dynamic> jsonData) =>
      _$WeeklySalesFromJson(jsonData);

  Map<String, dynamic> toJson() => _$WeeklySalesToJson(this);
}
