import 'package:cinemabooking/domain/repo_interface/auth_repo_interface.dart';
import 'package:cinemabooking/presentation/cubit/auth/app_cubit.dart';
import 'package:cinemabooking/presentation/states/splash/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  final IAuthRepository authRepository;

  SplashCubit({required this.authRepository}) : super(SplashInitialState());

  Future<void> checkToken() async {
    final result = await authRepository.checkToken();

    if (result) {
      AppAuthCubit().login();
      emit(SplashHomeState());
    } else {
      AppAuthCubit().logout();
      emit(SplashWelcomeState());
    }
  }
}
