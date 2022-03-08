import 'package:json_annotation/json_annotation.dart';
part 'insertionSummaryInfo.g.dart';

@JsonSerializable()
class InsertionSummaryInfo {
  int totalRecord;
  int totalInsertedRecord;
  int totalUpdatedRecord;

  InsertionSummaryInfo(
      {this.totalInsertedRecord, this.totalRecord, this.totalUpdatedRecord});


  factory InsertionSummaryInfo.fromJson(Map<String, dynamic> jsonData) =>
      _$InsertionSummaryInfoFromJson(jsonData);

  Map<String, dynamic> toJson() => _$InsertionSummaryInfoToJson(this);
  
}
