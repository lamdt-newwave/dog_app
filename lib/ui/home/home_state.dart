part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<BreedEntity> breeds;
  final LoadStatus fetchInitDataStatus;
  final LoadStatus fetchDogDataStatus;
  final List<int> selectedIndexes;
  final List<DogEntity> dogs;

  const HomeState({
    this.dogs = const [],
    this.fetchDogDataStatus = LoadStatus.initial,
    this.fetchInitDataStatus = LoadStatus.initial,
    this.breeds = const [],
    this.selectedIndexes = const [],
  });

  @override
  List<Object?> get props => [
        breeds,
        fetchInitDataStatus,
        selectedIndexes,
        dogs,
      ];

  HomeState copyWith(
      {List<BreedEntity>? breeds,
      LoadStatus? fetchInitDataStatus,
      LoadStatus? fetchDogDataStatus,
      List<int>? selectedIndexes,
      List<DogEntity>? dogs,
      List<String>? selectedBreeds}) {
    return HomeState(
        fetchDogDataStatus: fetchDogDataStatus ?? this.fetchDogDataStatus,
        dogs: dogs ?? this.dogs,
        selectedIndexes: selectedIndexes ?? this.selectedIndexes,
        fetchInitDataStatus: fetchInitDataStatus ?? this.fetchInitDataStatus,
        breeds: breeds ?? this.breeds);
  }
}
