import 'package:brewmap/core/cubits/main/main_cubit.dart';
import 'package:brewmap/core/pages/splash_page.dart';
import 'package:brewmap/core/utils/themes/dark_theme.dart';
import 'package:brewmap/core/utils/themes/light_theme.dart';
import 'package:brewmap/dependency_injection.dart';
import 'package:brewmap/features/auth/cubits/auth_cubit.dart';
import 'package:brewmap/features/settings/cubits/settings_cubit.dart';
import 'package:brewmap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await initializeDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl.get<MainCubit>()),
        BlocProvider.value(value: sl.get<SettingsCubit>()),
        BlocProvider.value(value: sl.get<AuthCubit>()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      themeMode: context.watch<SettingsCubit>().state.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(context.watch<SettingsCubit>().state.language.name),
    );
  }
}
