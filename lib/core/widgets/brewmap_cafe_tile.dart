import 'package:brewmap/features/favorites/cubits/favorite_cubit.dart';
import 'package:brewmap/features/maps/models/cafe_model.dart';
import 'package:brewmap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/constants/constants.dart';

class BrewmapCafeTile extends StatelessWidget {
  final CafeModel cafe;
  final Function()? onTap;
  bool showGetDirections;
  BrewmapCafeTile({
    super.key,
    required this.cafe,
    this.onTap,
    this.showGetDirections = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                cafe.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConstants.s18,
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await context.read<FavoriteCubit>().favorite(cafe);
              },
              icon: context.watch<FavoriteCubit>().isFavorite(cafe)
                  ? const Icon(Icons.bookmark)
                  : const Icon(Icons.bookmark_outline),
            ),
          ],
        ),
        Text(cafe.address, style: const TextStyle(fontSize: SizeConstants.s14)),

        const SizedBox(height: SizeConstants.s4),

        showGetDirections
            ? GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(SizeConstants.s8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.getDirections,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      Icon(
                        Icons.directions,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ],
                  ),
                ),
              )
            : Text(""),
      ],
    );
  }
}
