import 'package:dog_app/models/breed_entity.dart';
import 'package:dog_app/models/response_entity.dart';
import 'package:dog_app/network/api_client.dart';

abstract class DogRepository {
  Future<List<BreedEntity>> getAllBreeds();

  Future<List<String>> getDogUrls(String breedType);
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
  Future<List<String>> getDogUrls(String breedType) async {
    final ResponseEntity responseEntity = await apiClient.getDogUrls(breedType);
    return List.from(responseEntity.message);
  }
}
