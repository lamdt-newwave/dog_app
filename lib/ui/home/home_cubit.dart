import 'package:bloc/bloc.dart';
import 'package:dog_app/models/breed_entity.dart';
import 'package:dog_app/models/load_status.dart';
import 'package:dog_app/repositories/dog_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final DogRepository dogRepository;

  HomeCubit({required this.dogRepository}) : super(const HomeState());

  Future<void> fetchData() async {
    emit(state.copyWith(fetchInitDataStatus: LoadStatus.loading));
    try {
      final result = await dogRepository.getAllBreeds();
      final urls = await dogRepository.getDogUrls(state.selectedBreed);
      emit(
        state.copyWith(
          fetchInitDataStatus: LoadStatus.success,
          breeds: result,
          imageUrls: urls.take(10).toList(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(fetchInitDataStatus: LoadStatus.failure),
      );
    }
  }

  void onSelectBreed(int breedIndex) {
    emit(
      state.copyWith(
          selectedBreed: state.breeds[breedIndex].name,
          selectedIndex: breedIndex != state.selectedIndex ? breedIndex : -1),
    );
    loadDogUrls(10);
  }

  Future<void> loadDogUrls(int count) async {
    print(123);
    emit(state.copyWith(fetchDogDataStatus: LoadStatus.loading));
    try {
      final urls = await dogRepository.getDogUrls(state.selectedBreed);

      emit(
        state.copyWith(
            fetchDogDataStatus: LoadStatus.success,
            imageUrls:
                urls.take(count < urls.length ? count : urls.length).toList()),
      );
    } catch (e) {
      emit(
        state.copyWith(fetchDogDataStatus: LoadStatus.failure),
      );
    }
  }
}
