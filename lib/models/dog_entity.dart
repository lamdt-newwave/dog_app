import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DogEntity {
  DogEntity({required this.breedType, required this.url});

  final String breedType;
  final String url;

  DogEntity copyWith({
    String? breedType,
    String? url,
  }) {
    return DogEntity(
        breedType: breedType ?? this.breedType, url: url ?? this.url);
  }
}
