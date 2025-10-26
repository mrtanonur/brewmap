import 'package:brewmap/dependency_injection.dart';
import 'package:brewmap/features/favorites/data/local_data_providers/favorites_local_data_provider.dart';
import 'package:brewmap/features/favorites/data/remote_data_providers/favorites_remote_data_provider.dart';
import 'package:brewmap/features/maps/models/cafe_model.dart';
import 'package:either_dart/either.dart';

class FavoritesRepository {
  final FavoritesRemoteDataProvider _favoritesRemoteDataProvider = sl
      .get<FavoritesRemoteDataProvider>();

  final FavoritesLocalDataProvider _favoritesLocalDataProvider = sl
      .get<FavoritesLocalDataProvider>();

  Future addFavorite(CafeModel cafeModel) async {
    final response = await _favoritesRemoteDataProvider.addFavorite(
      cafeModel.id,
      cafeModel.toJson(),
    );

    return response.fold(
      (String errorMessage) {
        _favoritesLocalDataProvider.add(cafeModel);
        return Left(errorMessage);
      },
      (_) {
        _favoritesLocalDataProvider.add(cafeModel);
        return Right(null);
      },
    );
  }

  Future removeFavorite(CafeModel cafeModel) async {
    final response = await _favoritesRemoteDataProvider.removeFavorite(
      cafeModel.id,
    );

    return response.fold(
      (String errorMessage) {
        _favoritesLocalDataProvider.delete(cafeModel.id);
        return Left(errorMessage);
      },
      (_) {
        _favoritesLocalDataProvider.delete(cafeModel.id);
        return Right(null);
      },
    );
  }

  Future<List<CafeModel>?> getFavorites() async {
    final response = await _favoritesRemoteDataProvider.getFavorites();
    return response.fold(
      (String errorMessage) {
        List<CafeModel>? favoritesList = _favoritesLocalDataProvider.readAll();

        return favoritesList;
      },
      (List<Map<String, dynamic>> listMap) {
        List<CafeModel> favoritesList = listMap
            .map((json) => CafeModel.fromFirestore(json))
            .toList();
        return favoritesList;
      },
    );
  }
}
