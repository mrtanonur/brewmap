import 'dart:async';

import 'package:brewmap/core/pages/main_page.dart';
import 'package:brewmap/core/utils/constants/constants.dart';
import 'package:brewmap/features/auth/cubits/auth_cubit.dart';
import 'package:brewmap/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 2), () {
      context.read<AuthCubit>().authCheck();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.userExists) {
          context.read<AuthCubit>().getUserData();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignUpPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset(
            AssetConstants.brewmapTransparent,
            height: SizeConstants.s250,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
