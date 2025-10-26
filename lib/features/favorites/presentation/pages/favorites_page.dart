import 'package:brewmap/core/utils/constants/constants.dart';
import 'package:brewmap/core/widgets/brewmap_cafe_tile.dart';
import 'package:brewmap/features/favorites/cubits/favorite_cubit.dart';
import 'package:brewmap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteCubit>().getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          return state.favoriteCafes!.isEmpty
              ? Center(
                  child: Text(AppLocalizations.of(context)!.noFavoritesYet),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SizeConstants.s24,
                    vertical: SizeConstants.s24,
                  ),
                  child: ListView.separated(
                    itemCount: state.favoriteCafes!.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: SizeConstants.s8);
                    },
                    itemBuilder: (context, index) {
                      return BrewmapCafeTile(cafe: state.favoriteCafes![index]);
                    },
                  ),
                );
        },
      ),
    );
  }
}
