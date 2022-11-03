import 'package:dog_app/repositories/dog_repository.dart';
import 'package:dog_app/network/api_client.dart';
import 'package:dog_app/network/api_util.dart';
import 'package:dog_app/ui/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiUtil.apiClient;
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DogRepository>(
            create: (context) => DogRepositoryImpl(_apiClient))
      ],
      child: MaterialApp(
        title: 'Dog App',
        theme: ThemeData(),
        home: const HomePage(),
      ),
    );
  }
}
