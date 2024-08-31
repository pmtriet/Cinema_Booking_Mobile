import 'package:cinemabooking/domain/data_request/auth/login_request.dart';
import 'package:cinemabooking/domain/repo_interface/auth_repo_interface.dart';
import 'package:cinemabooking/presentation/cubit/auth/app_cubit.dart';
import 'package:cinemabooking/presentation/states/auth/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final IAuthRepository authRepository;

  LoginCubit({required this.authRepository}) : super(LoginInitialState());

  Future<void> validLogin() async {
    emit(LoginInitialState());
  }

  Future<void> login(String email, String password) async {
    emit(LoginLoadingState());
    try {
      var loginRequestDTO = LoginRequest(email: email, password: password);
      final result = await authRepository.login(loginRequestDTO);
      if (result == null) {
        emit(LoginSuccessState());
        AppAuthCubit().login();
      } else {
        emit(LoginErrorState(result));
      }
    } catch (e) {
      emit(LoginErrorState('Login failed: ${e.toString()}'));
    }
  }
}
