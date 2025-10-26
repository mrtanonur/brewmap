import 'package:bloc/bloc.dart';
import 'package:brewmap/dependency_injection.dart';
import 'package:brewmap/features/favorites/data/repositories/favorites_repository.dart';
import 'package:brewmap/features/maps/models/cafe_model.dart';
import 'package:equatable/equatable.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoritesRepository _favoritesRepository = sl
      .get<FavoritesRepository>();

  FavoriteCubit() : super(FavoriteState.initial());

  Future getFavorites() async {
    final response = await _favoritesRepository.getFavorites();
    if (response != null) {
      emit(
        state.copyWith(
          favoriteCafes: response,
          favoriteStatus: FavoriteStatus.favoritesLoaded,
        ),
      );
    }
  }

  Future favorite(CafeModel cafeModel) async {
    final List<CafeModel> updatedFavorites = List.from(
      state.favoriteCafes ?? [],
    );

    if (updatedFavorites.any((cafe) => cafe.id == cafeModel.id)) {
      updatedFavorites.removeWhere((item) => item.id == cafeModel.id);
      await _favoritesRepository.removeFavorite(cafeModel);
    } else {
      updatedFavorites.add(cafeModel);
      await _favoritesRepository.addFavorite(cafeModel);
    }
    emit(state.copyWith(favoriteCafes: updatedFavorites));
  }

  bool isFavorite(CafeModel cafeModel) {
    if (state.favoriteCafes!.any((cafe) => cafe.id == cafeModel.id)) {
      return true;
    } else {
      return false;
    }
  }
}
