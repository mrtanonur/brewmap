import 'package:brewmap/core/utils/constants/constants.dart';
import 'package:brewmap/core/widgets/brewmap_app_bar.dart';
import 'package:brewmap/features/settings/cubits/settings_cubit.dart';
import 'package:brewmap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrewmapAppBar(
        title: AppLocalizations.of(context)!.language,
        color: Theme.of(context).colorScheme.surfaceBright,
        hasLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeConstants.s24,
          vertical: SizeConstants.s24,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox.adaptive(
                  value:
                      context.watch<SettingsCubit>().state.language ==
                      Languages.en,
                  onChanged: (value) {
                    context.read<SettingsCubit>().changeLanguage(Languages.en);
                  },
                ),
                Text("English"),
              ],
            ),
            Row(
              children: [
                Checkbox.adaptive(
                  value:
                      context.watch<SettingsCubit>().state.language ==
                      Languages.tr,
                  onChanged: (value) {
                    context.read<SettingsCubit>().changeLanguage(Languages.tr);
                  },
                ),
                Text("Turkish"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
