import 'package:dog_app/models/breed_entity.dart';
import 'package:dog_app/models/dog_entity.dart';
import 'package:dog_app/models/response_entity.dart';
import 'package:dog_app/network/api_client.dart';

abstract class DogRepository {
  Future<List<BreedEntity>> getAllBreeds();

  Future<List<DogEntity>> getDogs({String breedType});
}

class DogRepositoryImpl extends DogRepository {
  final ApiClient apiClient;

  DogRepositoryImpl(this.apiClient);

  @override
  Future<List<BreedEntity>> getAllBreeds() async {
    final ResponseEntity responseEntity = await apiClient.getAllBreeds();
    final data = responseEntity.message as Map<String, dynamic>;
    List<BreedEntity> result = [];
    result = data.keys.map((e) {
      BreedEntity breedEntity =
          BreedEntity(name: e, subBreeds: List.from(data[e]));
      return breedEntity;
    }).toList();
    return result;
  }

  @override
  Future<List<DogEntity>> getDogs({String breedType = "hound"}) async {
    final ResponseEntity responseEntity = await apiClient.getDogUrls(breedType);
    final List<DogEntity> dogs = List.from(responseEntity.message)
        .map((e) => DogEntity(breedType: breedType, url: e))
        .toList();
    return dogs;
  }
}
