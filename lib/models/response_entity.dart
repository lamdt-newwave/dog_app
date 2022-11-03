import 'package:json_annotation/json_annotation.dart';

part 'response_entity.g.dart';

@JsonSerializable()
class ResponseEntity {
  final String status;
  final dynamic message;

  ResponseEntity({required this.status, required this.message});

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory ResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$ResponseEntityFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ResponseEntityToJson(this);
}
