import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog_app/configs/app_colors.dart';
import 'package:dog_app/models/load_status.dart';
import 'package:dog_app/repositories/dog_repository.dart';
import 'package:dog_app/ui/home/home_cubit.dart';
import 'package:dog_app/ui/home/widgets/breed_widget.dart';
import 'package:dog_app/ui/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
          dogRepository: RepositoryProvider.of<DogRepository>(context)),
      child: const HomeChildPage(),
    );
  }
}

class HomeChildPage extends StatefulWidget {
  const HomeChildPage({Key? key}) : super(key: key);

  @override
  State<HomeChildPage> createState() => _HomeChildPageState();
}

class _HomeChildPageState extends State<HomeChildPage> {
  late final ScrollController scrollController;
  late final ScrollController dogImageScrollController;
  late final HomeCubit _cubit;
  final _scrollThreshold = 200.0;
  bool isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    dogImageScrollController = ScrollController();
    _cubit = context.read<HomeCubit>();
    _cubit.fetchData();

    dogImageScrollController.addListener(scrollListener);
  }

  Future<void> scrollListener() async {
    final maxScroll = dogImageScrollController.position.maxScrollExtent;
    final currentScroll = dogImageScrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold && !isLoadMoreRunning) {
      isLoadMoreRunning = true;
      int index = _cubit.state.dogs.length;
      await _cubit.loadDogUrls(index + 10, loadMore: true);
      isLoadMoreRunning = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    dogImageScrollController.removeListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.darkSecondary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Dog App",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 32,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 40,
                ),
                _buildBreedList(),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _cubit.loadDogUrls(10),
                    child: _buildDogList(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildDogList() {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state.fetchInitDataStatus == LoadStatus.success) {
          return _buildSuccessDogList();
        } else if (state.fetchInitDataStatus == LoadStatus.loading) {
          return _buildLoadingDogList();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildLoadingDogList() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            scrollDirection: Axis.vertical,
            itemBuilder: (_, index) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: AppShimmer(
                  cornerRadius: 20,
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSuccessDogList() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ListView.builder(
          controller: dogImageScrollController,
          shrinkWrap: true,
          itemCount: state.dogs.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (_, index) {
            final dog = state.dogs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.secondary,
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              child: CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.width * 0.2,
                              minWidth: MediaQuery.of(context).size.width * 0.3,
                            ),
                            child: Image(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                  placeholder: (context, url) => Lottie.asset(
                      "assets/lotties/lottie_loading_dots_message.json"),
                  imageUrl: dog.url),
            );
          },
        );
      },
    );
  }

  Widget _buildBreedList() {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state.fetchInitDataStatus == LoadStatus.success ||
            state.fetchDogDataStatus == LoadStatus.success) {
          return _buildSuccessBreedList();
        } else if (state.fetchInitDataStatus == LoadStatus.loading ||
            state.fetchDogDataStatus == LoadStatus.loading) {
          return _buildLoadingBreedList();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildSuccessBreedList() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SizedBox(
          height: 56,
          child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            itemCount: state.breeds.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final breed = state.breeds[index];
              return BreedWidget(
                onPressed: () async {
                  _cubit.onSelectBreed(index);
                  dogImageScrollController.jumpTo(0);
                },
                breed: breed,
                isSelected: state.selectedIndexes.contains(index),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingBreedList() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SizedBox(
          height: 56,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: const AppShimmer(
                  cornerRadius: 20,
                  height: 36,
                  width: 100,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
