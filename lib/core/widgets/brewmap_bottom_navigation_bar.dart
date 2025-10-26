import 'dart:io';

import 'package:brewmap/core/cubits/main/main_cubit.dart';
import 'package:brewmap/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrewmapBottomNavigationBar extends StatefulWidget {
  const BrewmapBottomNavigationBar({super.key});

  @override
  State<BrewmapBottomNavigationBar> createState() =>
      _BrewmapBottomNavigationBarState();
}

class _BrewmapBottomNavigationBarState
    extends State<BrewmapBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomNavigationBar(
        currentIndex: context.watch<MainCubit>().state.bottomNavigationIndex,
        onTap: (index) {
          context.read<MainCubit>().changeNavigationIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.maps,
            icon: Icon(Icons.map),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.favorites,
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.settings,
            icon: Icon(Icons.settings),
          ),
        ],
      );
    } else {
      return CupertinoTabBar(
        currentIndex: context.watch<MainCubit>().state.bottomNavigationIndex,
        onTap: (index) {
          context.read<MainCubit>().changeNavigationIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.maps,
            icon: Icon(Icons.map),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.favorites,
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.settings,
            icon: Icon(Icons.settings),
          ),
        ],
      );
    }
  }
}
