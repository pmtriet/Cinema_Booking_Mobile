import 'package:cinemabooking/common/services/preference.dart';
import 'package:cinemabooking/config/route.dart';
import 'package:cinemabooking/config/ui.dart';
import 'package:cinemabooking/presentation/cubit/auth/app_cubit.dart';
import 'package:cinemabooking/presentation/states/auth/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppAuthCubit(),
      child: BlocBuilder<AppAuthCubit, AppAuthState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(appColor)),
              useMaterial3: true,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
