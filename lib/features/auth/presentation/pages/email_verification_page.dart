import 'package:brewmap/core/utils/widgets/brewmap_app_bar.dart';
import 'package:brewmap/core/utils/widgets/brewmap_button.dart';
import 'package:brewmap/features/auth/cubits/auth_cubit.dart';
import 'package:brewmap/features/auth/presentation/pages/sign_in_page.dart';
import 'package:brewmap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants/constants.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrewmapAppBar(
        title: AppLocalizations.of(context)!.emailVerification,
        color: Theme.of(context).colorScheme.surfaceBright,
        hasLeading: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AssetConstants.brewmapTransparent),
          SizedBox(height: SizeConstants.s36),

          Text(
            AppLocalizations.of(context)!.weHaveSentYouAnEmailVerificationLink,
          ),
          SizedBox(height: SizeConstants.s48),
          Text(
            textAlign: TextAlign.center,
            AppLocalizations.of(context)!.ifYouHaventReceivedOne,
          ),
          SizedBox(height: SizeConstants.s24),
          BrewmapButton(
            onTap: () async {
              await context.read<AuthCubit>().sendEmailVerificationLink();
            },
            text: AppLocalizations.of(context)!.sendAgain,
          ),

          SizedBox(height: SizeConstants.s48),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
            child: Text(AppLocalizations.of(context)!.goToSignInPage),
          ),
        ],
      ),
    );
  }
}
