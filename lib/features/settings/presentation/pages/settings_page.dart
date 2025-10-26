import 'package:brewmap/core/cubits/main/main_cubit.dart';
import 'package:brewmap/core/utils/constants/constants.dart';
import 'package:brewmap/core/widgets/brewmap_app_bar.dart';
import 'package:brewmap/core/widgets/brewmap_button.dart';
import 'package:brewmap/features/auth/cubits/auth_cubit.dart';
import 'package:brewmap/features/auth/presentation/pages/sign_in_page.dart';
import 'package:brewmap/features/maps/cubits/maps_cubit.dart';
import 'package:brewmap/features/settings/presentation/pages/language_page.dart';
import 'package:brewmap/features/settings/presentation/pages/profile_page.dart';
import 'package:brewmap/features/settings/presentation/pages/theme_page.dart';
import 'package:brewmap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // AuthStatus status = context.watch<AuthCubit>().state.status!;
        if (state.status == AuthStatus.signOut) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: BrewmapAppBar(
          title: AppLocalizations.of(context)!.settings,
          color: Theme.of(context).colorScheme.surfaceBright,
          hasLeading: false,
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: SizeConstants.s12,
            horizontal: SizeConstants.s24,
          ),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                leading: Icon(Icons.person),
                title: Text(AppLocalizations.of(context)!.profile),
                trailing: Icon(Icons.chevron_right),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThemePage()),
                  );
                },
                leading: Icon(Icons.contrast),
                title: Text(AppLocalizations.of(context)!.theme),
                trailing: Icon(Icons.chevron_right),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguagePage()),
                  );
                },
                leading: Icon(Icons.language),
                title: Text(AppLocalizations.of(context)!.language),
                trailing: Icon(Icons.chevron_right),
              ),

              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: SizeConstants.s48),
                child: BrewmapButton(
                  onTap: () async {
                    await context.read<AuthCubit>().signOut();
                    context.read<MapsCubit>().resetMap();
                    context.read<MainCubit>().resetNavigationIndex();
                  },
                  text: AppLocalizations.of(context)!.signOut,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
