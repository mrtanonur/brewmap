import 'package:brewmap/core/utils/widgets/brewmap_app_bar.dart';
import 'package:brewmap/core/utils/widgets/brewmap_button.dart';
import 'package:brewmap/core/utils/widgets/brewmap_textformfield.dart';
import 'package:brewmap/features/auth/cubits/auth_cubit.dart';
import 'package:brewmap/features/auth/presentation/pages/sign_in_page.dart';
import 'package:brewmap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        AuthCubit authCubit = context.read<AuthCubit>();
        if (authCubit.state.status == AuthStatus.resetPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.checkYourEmail),
            ),
          );
        } else if (authCubit.state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.somethingWentWrong),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        appBar: BrewmapAppBar(
          title: AppLocalizations.of(context)!.forgotPassword,
          color: Theme.of(context).colorScheme.surfaceBright,
          hasLeading: false,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetConstants.brewmapTransparent,
                  height: SizeConstants.s200,
                ),
                SizedBox(height: SizeConstants.s36),
                Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.inOrderToGetAResetEmail,
                ),
                SizedBox(height: SizeConstants.s36),

                ForgotPasswordForm(),
                SizedBox(height: SizeConstants.s36),
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
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  // final AuthViewModel _authViewModel = sl.get<AuthViewModel>();

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          BrewmapTextFormfield(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterYourEmail;
              }
              return null;
            },
            hintText: AppLocalizations.of(context)!.email,
            controller: _emailController,
            obscureText: false,
          ),
          SizedBox(height: SizeConstants.s24),

          BrewmapButton(
            isLoading: isLoading,
            onTap: () {
              if (_globalKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                context.read<AuthCubit>().resetPassword(_emailController.text);
                setState(() {
                  isLoading = false;
                });
              }
            },
            text: AppLocalizations.of(context)!.sendEmail,
          ),
        ],
      ),
    );
  }
}
