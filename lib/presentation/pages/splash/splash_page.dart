import 'package:cinemabooking/config/route.dart';
import 'package:cinemabooking/datalayer/repo/auth_repo.dart';
import 'package:cinemabooking/presentation/cubit/auth/splash_cubit.dart';
import 'package:cinemabooking/presentation/states/splash/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => SplashPage(),
    );
  }
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();

    return BlocProvider(
      create: (_) => SplashCubit(authRepository: authRepository),
      child: const MaterialApp(
        home: SplashView(),
      ),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.read<SplashCubit>().checkToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashWelcomeState) {
          context.go(RouteName.welcome);
        } else if (state is SplashHomeState) {
          context.go(RouteName.home);
        }
      },
      builder: (context, state) {
        if (state is SplashInitialState) {
          return splashWidget();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget splashWidget() {
    return SafeArea(
      child: Image.asset(
        'assets/images/splash.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
