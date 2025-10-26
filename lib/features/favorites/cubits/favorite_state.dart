part of 'favorite_cubit.dart';

enum FavoriteStatus { initial, favoritesLoaded, failure }

class FavoriteState extends Equatable {
  final List<CafeModel>? favoriteCafes;
  final FavoriteStatus? favoriteStatus;
  final String? error;
  const FavoriteState({this.favoriteStatus, this.favoriteCafes, this.error});

  FavoriteState copyWith({
    List<CafeModel>? favoriteCafes,
    FavoriteStatus? favoriteStatus,
    String? error,
  }) {
    return FavoriteState(
      favoriteCafes: favoriteCafes ?? this.favoriteCafes,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
      error: error ?? this.error,
    );
  }

  factory FavoriteState.initial() {
    return FavoriteState(
      favoriteCafes: [],
      favoriteStatus: FavoriteStatus.initial,
    );
  }

  @override
  List<Object?> get props => [favoriteCafes, favoriteStatus, error];
}
