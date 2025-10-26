import 'package:brewmap/core/widgets/brewmap_button.dart';
import 'package:brewmap/core/widgets/brewmap_textformfield.dart';
import 'package:brewmap/features/auth/cubits/auth_cubit.dart';
import 'package:brewmap/features/auth/presentation/pages/email_verification_page.dart';
import 'package:brewmap/features/auth/presentation/pages/sign_in_page.dart';
import 'package:brewmap/features/auth/presentation/widgets/brewmap_google_apple_sign_in.dart';
import 'package:brewmap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.verificationProcess) {
          context.read<AuthCubit>().storeUserData();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => EmailVerificationPage()),
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetConstants.brewmapTransparent,
                    height: SizeConstants.s200,
                  ),
                  SignUpForm(),

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
                      Text(AppLocalizations.of(context)!.ifYouHaveAnAccount),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.signIn),
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

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
          BrewmapTextFormfield(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterYourConfirmPassword;
              }

              return null;
            },
            hintText: AppLocalizations.of(context)!.confirmPassword,
            controller: _confirmPasswordController,
            obscureText: true,
          ),

          BrewmapButton(
            isLoading: isLoading,
            onTap: () async {
              if (_confirmPasswordController.text == _passwordController.text) {
                if (_globalKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  await context.read<AuthCubit>().signUp(
                    _emailController.text,
                    _passwordController.text,
                  );

                  setState(() {
                    isLoading = false;
                  });
                }
              }
            },
            text: AppLocalizations.of(context)!.signUp,
          ),
        ],
      ),
    );
  }
}
