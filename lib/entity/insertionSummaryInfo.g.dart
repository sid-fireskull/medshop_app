// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insertionSummaryInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsertionSummaryInfo _$InsertionSummaryInfoFromJson(Map<String, dynamic> json) {
  return InsertionSummaryInfo(
    totalInsertedRecord: json['totalInsertedRecord'] as int,
    totalRecord: json['totalRecord'] as int,
    totalUpdatedRecord: json['totalUpdatedRecord'] as int,
  );
}

Map<String, dynamic> _$InsertionSummaryInfoToJson(
        InsertionSummaryInfo instance) =>
    <String, dynamic>{
      'totalRecord': instance.totalRecord,
      'totalInsertedRecord': instance.totalInsertedRecord,
      'totalUpdatedRecord': instance.totalUpdatedRecord,
    };
