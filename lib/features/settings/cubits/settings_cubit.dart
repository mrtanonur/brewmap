import 'package:bloc/bloc.dart';
import 'package:brewmap/features/settings/data/data_providers/local_data_providers/settings_local_data_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState.initial());

  void changeLanguage(Languages selectedLanguage) {
    emit(state.copyWith(language: selectedLanguage));
    SettingsLocalDataProvider.add("language", selectedLanguage.name);
  }

  void changeTheme(ThemeMode theme) {
    emit(state.copyWith(themeMode: theme));
    SettingsLocalDataProvider.add("theme", theme.name);
  }
}
