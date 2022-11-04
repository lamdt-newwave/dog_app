import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dog_app/models/breed_entity.dart';
import 'package:dog_app/models/dog_entity.dart';
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
      List<DogEntity> dogs = await dogRepository.getDogs();
      emit(
        state.copyWith(
          fetchInitDataStatus: LoadStatus.success,
          breeds: result,
          dogs: dogs.take(10).toList(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(fetchInitDataStatus: LoadStatus.failure),
      );
    }
  }

  void onSelectBreed(int breedIndex) {
    bool isSelected = state.selectedIndexes.contains(breedIndex);
    List<int> selectedIndexes = List.from(state.selectedIndexes);
    if (isSelected) {
      selectedIndexes.remove(breedIndex);
    } else {
      selectedIndexes.add(breedIndex);
    }
    emit(
      state.copyWith(selectedIndexes: selectedIndexes),
    );
    loadDogUrls(10, newIndex: breedIndex, isAdding: !isSelected);
  }

  Future<void> loadDogUrls(int count,
      {bool loadMore = false, int newIndex = -1, bool isAdding = false}) async {
    emit(state.copyWith(fetchDogDataStatus: LoadStatus.loading));
    try {
      List<DogEntity> dogs = [];
      if (state.selectedIndexes.isEmpty) {
        dogs = await dogRepository.getDogs();
      } else {
        if (loadMore) {
          for (int selectedBreedIndex in state.selectedIndexes) {
            final result = await dogRepository.getDogs(
                breedType: state.breeds[selectedBreedIndex].name);
            dogs.addAll(result);
          }
        } else {
          if (isAdding) {
            if (state.selectedIndexes.length == 1) {
              dogs = await dogRepository.getDogs(
                  breedType: state.breeds[newIndex].name);
            } else {
              final result = await dogRepository.getDogs(
                  breedType: state.breeds[newIndex].name);
              dogs.addAll(state.dogs);
              dogs.addAll(result);
            }
          } else {
            state.dogs.removeWhere(
                (element) => element.breedType == state.breeds[newIndex].name);
            if (state.dogs.isEmpty) {
              for (int selectedBreedIndex in state.selectedIndexes) {
                final result = await dogRepository.getDogs(
                    breedType: state.breeds[selectedBreedIndex].name);
                dogs.addAll(result);
              }
            } else {
              dogs = List.from(state.dogs);
            }
          }
          dogs.shuffle(Random());
        }
      }

      emit(
        state.copyWith(
            fetchDogDataStatus: LoadStatus.success,
            dogs:
                dogs.take(count < dogs.length ? count : dogs.length).toList()),
      );
    } catch (e) {
      emit(
        state.copyWith(fetchDogDataStatus: LoadStatus.failure),
      );
    }
  }
}
