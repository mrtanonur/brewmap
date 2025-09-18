import 'package:brewmap/core/cubits/main/main_cubit.dart';
import 'package:brewmap/core/utils/widgets/brewmap_bottom_navigation_bar.dart';
import 'package:brewmap/features/favorites/presentation/pages/favorites_page.dart';
import 'package:brewmap/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BrewmapBottomNavigationBar(),
      body: IndexedStack(
        index: context.watch<MainCubit>().state.bottomNavigationIndex,
        children: [FavoritesPage(), SettingsPage()],
      ),
    );
  }
}
