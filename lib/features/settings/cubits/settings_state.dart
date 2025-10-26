part of 'settings_cubit.dart';

enum Languages { en, tr }

class SettingsState extends Equatable {
  final Languages language;
  final ThemeMode themeMode;
  const SettingsState({required this.themeMode, required this.language});

  SettingsState copyWith({Languages? language, ThemeMode? themeMode}) {
    return SettingsState(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  factory SettingsState.initial() {
    return SettingsState(
      language: Languages.values.firstWhere(
        (language) =>
            language.name ==
            (SettingsLocalDataProvider.read("language") ?? Languages.en.name),
      ),
      themeMode: ThemeMode.values.firstWhere(
        (language) =>
            language.name ==
            (SettingsLocalDataProvider.read("theme") ?? ThemeMode.light.name),
      ),
    );
  }

  @override
  List<Object> get props => [language, themeMode];
}
