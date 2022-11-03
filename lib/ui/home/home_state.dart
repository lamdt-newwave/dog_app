part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<BreedEntity> breeds;
  final LoadStatus fetchInitDataStatus;
  final LoadStatus fetchDogDataStatus;
  final int selectedIndex;
  final List<String> imageUrls;
  final String selectedBreed;

  const HomeState({
    this.selectedBreed = "hound",
    this.imageUrls = const [],
    this.fetchDogDataStatus = LoadStatus.initial,
    this.fetchInitDataStatus = LoadStatus.initial,
    this.breeds = const [],
    this.selectedIndex = -1,
  });

  @override
  List<Object?> get props =>
      [breeds, fetchInitDataStatus, selectedIndex, imageUrls, selectedBreed];

  HomeState copyWith(
      {List<BreedEntity>? breeds,
      LoadStatus? fetchInitDataStatus,
      LoadStatus? fetchDogDataStatus,
      int? selectedIndex,
      List<String>? imageUrls,
      String? selectedBreed}) {
    return HomeState(
        fetchDogDataStatus: fetchDogDataStatus ?? this.fetchDogDataStatus,
        selectedBreed: selectedBreed ?? this.selectedBreed,
        imageUrls: imageUrls ?? this.imageUrls,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        fetchInitDataStatus: fetchInitDataStatus ?? this.fetchInitDataStatus,
        breeds: breeds ?? this.breeds);
  }
}
