import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BreedEntity {
  BreedEntity({required this.name, this.subBreeds = const []});

  final String name;
  final List<String> subBreeds;

  BreedEntity copyWith({
    List<String>? subBreeds,
    String? name,
  }) {
    return BreedEntity(
        name: name ?? this.name, subBreeds: subBreeds ?? this.subBreeds);
  }
}
