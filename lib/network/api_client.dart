import 'package:dio/dio.dart';
import 'package:dog_app/models/response_entity.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/breeds/list/all")
  Future<ResponseEntity> getAllBreeds();

  @GET("/breed/{breedType}/images")
  Future<ResponseEntity> getDogUrls(@Path("breedType") String breedType);
}
