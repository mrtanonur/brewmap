import 'package:brewmap/core/utils/constants/constants.dart';
import 'package:brewmap/core/widgets/brewmap_app_bar.dart';
import 'package:brewmap/features/auth/cubits/auth_cubit.dart';
import 'package:brewmap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrewmapAppBar(
        title: AppLocalizations.of(context)!.profile,
        color: Theme.of(context).colorScheme.surfaceBright,
        hasLeading: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SizeConstants.s48,
              ),
              child: Column(
                children: [
                  Icon(Icons.person, size: SizeConstants.s150),
                  SizedBox(height: SizeConstants.s48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.email}:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConstants.s16,
                        ),
                      ),
                      Text(
                        state.userData!.email,
                        style: TextStyle(fontSize: SizeConstants.s16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
