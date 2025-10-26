import 'package:brewmap/core/cubits/main/main_cubit.dart';
import 'package:brewmap/features/auth/cubits/auth_cubit.dart';
import 'package:brewmap/features/auth/data/data_providers/remote_data_providers/auth_remote_data_provider.dart';
import 'package:brewmap/features/auth/data/repositories/auth_repository.dart';
import 'package:brewmap/features/favorites/cubits/favorite_cubit.dart';
import 'package:brewmap/features/favorites/data/local_data_providers/favorites_local_data_provider.dart';
import 'package:brewmap/features/favorites/data/remote_data_providers/favorites_remote_data_provider.dart';
import 'package:brewmap/features/favorites/data/repositories/favorites_repository.dart';
import 'package:brewmap/features/maps/cubits/maps_cubit.dart';
import 'package:brewmap/features/maps/data/remote_data_providers/maps_remote_data_provider.dart';
import 'package:brewmap/features/maps/data/repositories/maps_repository.dart';
import 'package:brewmap/features/maps/models/cafe_model.dart';
import 'package:brewmap/features/settings/cubits/settings_cubit.dart';
import 'package:brewmap/features/settings/data/data_providers/local_data_providers/settings_local_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

final sl = GetIt.instance;

Future initializeDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp();

  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(CafeModelAdapter());
  await SettingsLocalDataProvider.openBox();
  await FavoritesLocalDataProvider.openBox();

  sl.registerLazySingleton(() => Dio());

  sl.registerSingleton(FirebaseAuth.instance);
  sl.registerSingleton(FirebaseFirestore.instance);

  sl.registerSingleton(AuthRemoteDataProvider());
  sl.registerSingleton(MapsRemoteDataProvider());
  sl.registerLazySingleton(() => FavoritesRemoteDataProvider());
  sl.registerLazySingleton(() => FavoritesLocalDataProvider());

  sl.registerSingleton(AuthRepository());
  sl.registerSingleton(MapsRepository());
  sl.registerLazySingleton(() => FavoritesRepository());

  sl.registerSingleton(AuthCubit());
  sl.registerSingleton(MainCubit());
  sl.registerLazySingleton(() => FavoriteCubit());
  sl.registerSingleton(SettingsCubit());
  sl.registerSingleton(MapsCubit());
}
