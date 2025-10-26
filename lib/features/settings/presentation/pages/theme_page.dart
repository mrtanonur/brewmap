import 'package:brewmap/core/utils/constants/constants.dart';
import 'package:brewmap/core/widgets/brewmap_app_bar.dart';
import 'package:brewmap/features/settings/cubits/settings_cubit.dart';
import 'package:brewmap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrewmapAppBar(
        title: AppLocalizations.of(context)!.theme,
        color: Theme.of(context).colorScheme.surfaceBright,
        hasLeading: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SizeConstants.s24),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox.adaptive(
                  value:
                      context.watch<SettingsCubit>().state.themeMode ==
                      ThemeMode.light,
                  onChanged: (value) {
                    context.read<SettingsCubit>().changeTheme(ThemeMode.light);
                  },
                ),
                Text(AppLocalizations.of(context)!.light),
              ],
            ),
            Row(
              children: [
                Checkbox.adaptive(
                  value:
                      context.watch<SettingsCubit>().state.themeMode ==
                      ThemeMode.dark,
                  onChanged: (value) {
                    context.read<SettingsCubit>().changeTheme(ThemeMode.dark);
                  },
                ),
                Text(AppLocalizations.of(context)!.dark),
              ],
            ),
            Row(
              children: [
                Checkbox.adaptive(
                  value:
                      context.watch<SettingsCubit>().state.themeMode ==
                      ThemeMode.system,
                  onChanged: (value) {
                    context.read<SettingsCubit>().changeTheme(ThemeMode.system);
                  },
                ),
                Text(AppLocalizations.of(context)!.system),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
