import 'package:brewmap/core/pages/main_page.dart';
import 'package:brewmap/core/widgets/brewmap_button.dart';
import 'package:brewmap/core/widgets/brewmap_textformfield.dart';
import 'package:brewmap/features/auth/cubits/auth_cubit.dart';
import 'package:brewmap/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:brewmap/features/auth/presentation/pages/sign_up_page.dart';
import 'package:brewmap/features/auth/presentation/widgets/brewmap_google_apple_sign_in.dart';
import 'package:brewmap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants/constants.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.unVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.pleaseVerifyYourEmail,
              ),
            ),
          );
        } else if (state.status == AuthStatus.signIn) {
          context.read<AuthCubit>().getUserData();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
            (route) => false,
          );
        } else if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.somethingWentWrong),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetConstants.brewmapTransparent,
                    height: SizeConstants.s200,
                  ),
                  SignInForm(),
                  SizedBox(height: SizeConstants.s24),
                  Text(AppLocalizations.of(context)!.orContinueWith),
                  SizedBox(height: SizeConstants.s48),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BrewmapGoogleAppleSignIn(
                        onTap: () async {
                          // await context.read<AuthCubit>().appleSignIn();
                        },
                        name: AssetConstants.appleLogo,
                        width: 54,
                      ),
                      SizedBox(width: SizeConstants.s48),
                      BrewmapGoogleAppleSignIn(
                        onTap: () async {
                          // await context.read<AuthCubit>().googleSignIn();
                        },
                        name: AssetConstants.googleLogo,
                        width: 54,
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConstants.s48),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.ifYouDontHaveAnAccount,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.signUp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
          BrewmapTextFormfield(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterYourPassword;
              }

              return null;
            },
            hintText: AppLocalizations.of(context)!.password,
            controller: _passwordController,
            obscureText: true,
          ),
          Padding(
            padding: const EdgeInsets.only(right: SizeConstants.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.forgotPassword),
                ),
              ],
            ),
          ),
          BrewmapButton(
            isLoading: isLoading,
            onTap: () async {
              if (_globalKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                await context.read<AuthCubit>().signIn(
                  _emailController.text,
                  _passwordController.text,
                );

                setState(() {
                  isLoading = false;
                });
              }
            },
            text: AppLocalizations.of(context)!.signIn,
          ),
        ],
      ),
    );
  }
}
